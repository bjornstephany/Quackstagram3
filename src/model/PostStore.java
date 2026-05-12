package src.model;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class PostStore {
    private final Path uploadedDir = Paths.get("img", "uploaded");

    public void saveUploadedPost(String username, File selectedFile, String caption) {
        int imageId = getNextImageId(username);
        String extension = getFileExtension(selectedFile);
        String newFileName = username + "_" + imageId + "." + extension;
        Path destPath = uploadedDir.resolve(newFileName);

        try {
            Files.createDirectories(uploadedDir);
            Files.copy(selectedFile.toPath(), destPath, StandardCopyOption.REPLACE_EXISTING);
            savePost(username, destPath.toString().replace('\\', '/'), caption);
        } catch (IOException e) {
            throw new RuntimeException("Could not save uploaded image", e);
        }
    }

    public List<PostData> findFeedPosts(String username) {
        String sql = """
                SELECT p.post_id, p.username, p.image_path, p.caption, p.posted_at,
                       COUNT(l.username) AS likes_count
                FROM Post p
                LEFT JOIN `Like` l ON p.post_id = l.post_id
                WHERE p.username = ?
                   OR p.username IN (
                       SELECT followed_username
                       FROM Follow
                       WHERE follower_username = ?
                   )
                GROUP BY p.post_id, p.username, p.image_path, p.caption, p.posted_at
                ORDER BY p.posted_at DESC
                """;
        return findPosts(sql, username, username);
    }

    public List<PostData> findAllPosts() {
        String sql = """
                SELECT p.post_id, p.username, p.image_path, p.caption, p.posted_at,
                       COUNT(l.username) AS likes_count
                FROM Post p
                LEFT JOIN `Like` l ON p.post_id = l.post_id
                GROUP BY p.post_id, p.username, p.image_path, p.caption, p.posted_at
                ORDER BY p.posted_at DESC
                """;
        return findPosts(sql);
    }

    public List<PostData> findPostsByUser(String username) {
        String sql = """
                SELECT p.post_id, p.username, p.image_path, p.caption, p.posted_at,
                       COUNT(l.username) AS likes_count
                FROM Post p
                LEFT JOIN `Like` l ON p.post_id = l.post_id
                WHERE p.username = ?
                GROUP BY p.post_id, p.username, p.image_path, p.caption, p.posted_at
                ORDER BY p.posted_at DESC
                """;
        return findPosts(sql, username);
    }

    public PostData findPostByImageId(String imageId) {
        String sql = """
                SELECT p.post_id, p.username, p.image_path, p.caption, p.posted_at,
                       COUNT(l.username) AS likes_count
                FROM Post p
                LEFT JOIN `Like` l ON p.post_id = l.post_id
                WHERE p.image_path LIKE ?
                GROUP BY p.post_id, p.username, p.image_path, p.caption, p.posted_at
                """;

        List<PostData> posts = findPosts(sql, "%" + imageId + ".%");
        return posts.isEmpty() ? null : posts.get(0);
    }

    public LikeResult likePost(String imageId, String username) {
        PostData post = findPostByImageId(imageId);
        if (post == null || username == null || username.isBlank()) {
            return null;
        }

        String sql = "INSERT IGNORE INTO `Like` (post_id, username) VALUES (?, ?)";

        boolean newLike;
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, post.getPostId());
            statement.setString(2, username);
            newLike = statement.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new RuntimeException("Could not like post", e);
        }

        return new LikeResult(post.getUsername(), countLikes(post.getPostId()), post.getPostId(), newLike);
    }

    private void savePost(String username, String imagePath, String caption) {
        String sql = "INSERT INTO Post (username, image_path, caption) VALUES (?, ?, ?)";

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, username);
            statement.setString(2, imagePath);
            statement.setString(3, caption);
            statement.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Could not save post metadata", e);
        }
    }

    private int getNextImageId(String username) {
        int maxId = 0;
        for (PostData post : findPostsByUser(username)) {
            String imageId = post.getImageId();
            if (imageId.startsWith(username + "_")) {
                try {
                    maxId = Math.max(maxId, Integer.parseInt(imageId.substring(username.length() + 1)));
                } catch (NumberFormatException ignored) {
                    // Existing filenames that do not use the username_N pattern are ignored.
                }
            }
        }
        return maxId + 1;
    }

    private int countLikes(int postId) {
        String sql = "SELECT COUNT(*) FROM `Like` WHERE post_id = ?";

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, postId);

            try (ResultSet resultSet = statement.executeQuery()) {
                return resultSet.next() ? resultSet.getInt(1) : 0;
            }
        } catch (SQLException e) {
            throw new RuntimeException("Could not count likes", e);
        }
    }

    private List<PostData> findPosts(String sql, String... parameters) {
        List<PostData> posts = new ArrayList<>();

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            for (int i = 0; i < parameters.length; i++) {
                statement.setString(i + 1, parameters[i]);
            }

            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    Timestamp postedAt = resultSet.getTimestamp("posted_at");
                    posts.add(new PostData(
                            resultSet.getInt("post_id"),
                            resultSet.getString("username"),
                            resultSet.getString("image_path"),
                            resultSet.getString("caption"),
                            postedAt == null ? LocalDateTime.now() : postedAt.toLocalDateTime(),
                            resultSet.getInt("likes_count")));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Could not load posts", e);
        }

        return posts;
    }

    private String getFileExtension(File file) {
        String fileName = file.getName();
        int dotIndex = fileName.lastIndexOf('.');
        if (dotIndex >= 0 && dotIndex < fileName.length() - 1) {
            return fileName.substring(dotIndex + 1);
        }
        return "png";
    }

    public static class LikeResult {
        private final String imageOwner;
        private final int likesCount;
        private final int postId;
        private final boolean newLike;

        public LikeResult(String imageOwner, int likesCount, int postId, boolean newLike) {
            this.imageOwner = imageOwner;
            this.likesCount = likesCount;
            this.postId = postId;
            this.newLike = newLike;
        }

        public String getImageOwner() {
            return imageOwner;
        }

        public int getLikesCount() {
            return likesCount;
        }

        public int getPostId() {
            return postId;
        }

        public boolean isNewLike() {
            return newLike;
        }
    }
}
