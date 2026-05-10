package src.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

public class NotificationStore {
    private static final DateTimeFormatter FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    public List<Notification> findNotificationsFor(String username) {
        List<Notification> result = new ArrayList<>();
        String sql = """
                SELECT n.username AS recipient_username,
                       p.image_path,
                       n.notified_at
                FROM Notification n
                JOIN Post p ON n.post_id = p.post_id
                WHERE n.username = ?
                ORDER BY n.notified_at DESC
                """;

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, username);

            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    Timestamp notifiedAt = resultSet.getTimestamp("notified_at");
                    String imagePath = resultSet.getString("image_path");
                    result.add(new Notification(
                            resultSet.getString("recipient_username"),
                            "Someone",
                            imageIdFromPath(imagePath),
                            notifiedAt.toLocalDateTime().format(FORMATTER)));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Could not read notifications", e);
        }

        return result;
    }

    public void addNotification(String recipientUsername, String actorUsername, int postId) {
        if (recipientUsername == null || actorUsername == null || recipientUsername.equals(actorUsername)) {
            return;
        }

        String sql = "INSERT INTO Notification (username, post_id) VALUES (?, ?)";

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, recipientUsername);
            statement.setInt(2, postId);
            statement.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Could not write notification", e);
        }
    }

    private String imageIdFromPath(String imagePath) {
        String fileName = new java.io.File(imagePath).getName();
        int dotIndex = fileName.lastIndexOf('.');
        return dotIndex > 0 ? fileName.substring(0, dotIndex) : fileName;
    }
}
