package src.model;

import java.time.LocalDateTime;

public class PostData {
    private final int postId;
    private final String username;
    private final String imagePath;
    private final String caption;
    private final LocalDateTime postedAt;
    private final int likesCount;

    public PostData(int postId, String username, String imagePath, String caption,
                    LocalDateTime postedAt, int likesCount) {
        this.postId = postId;
        this.username = username;
        this.imagePath = imagePath;
        this.caption = caption;
        this.postedAt = postedAt;
        this.likesCount = likesCount;
    }

    public int getPostId() {
        return postId;
    }

    public String getUsername() {
        return username;
    }

    public String getImagePath() {
        return imagePath;
    }

    public String getCaption() {
        return caption;
    }

    public LocalDateTime getPostedAt() {
        return postedAt;
    }

    public int getLikesCount() {
        return likesCount;
    }

    public String getImageId() {
        String fileName = new java.io.File(imagePath).getName();
        int dotIndex = fileName.lastIndexOf('.');
        return dotIndex > 0 ? fileName.substring(0, dotIndex) : fileName;
    }
}
