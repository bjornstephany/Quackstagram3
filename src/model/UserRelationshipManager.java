package src.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class UserRelationshipManager {
    private final UserStore userStore = new UserStore();

    public void followUser(String follower, String followed) {
        userStore.followUser(follower, followed);
    }

    public List<String> getFollowers(String username) {
        return findUsers("SELECT follower_username FROM Follow WHERE followed_username = ?", username);
    }

    public List<String> getFollowing(String username) {
        return findUsers("SELECT followed_username FROM Follow WHERE follower_username = ?", username);
    }

    private List<String> findUsers(String sql, String username) {
        List<String> users = new ArrayList<>();

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, username);

            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    users.add(resultSet.getString(1));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Could not load relationships", e);
        }

        return users;
    }
}
