package src.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UserStore {
    private final SessionStore sessionStore = new SessionStore();

    public ProfileData loadProfile(String viewedUsername) {
        String loggedInUsername = sessionStore.getLoggedInUsername();

        return new ProfileData(
                viewedUsername,
                findBio(viewedUsername),
                countPosts(viewedUsername),
                countFollowers(viewedUsername),
                countFollowing(viewedUsername),
                viewedUsername != null && viewedUsername.equals(loggedInUsername),
                loggedInUsername != null
                        && !loggedInUsername.equals(viewedUsername)
                        && isFollowing(loggedInUsername, viewedUsername)
        );
    }

    public boolean usernameExists(String username) {
        String sql = "SELECT 1 FROM User WHERE username = ?";

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, username);

            try (ResultSet resultSet = statement.executeQuery()) {
                return resultSet.next();
            }
        } catch (SQLException e) {
            throw new RuntimeException("Could not check username", e);
        }
    }

    public void registerUser(String username, String password, String bio) {
        String sql = "INSERT INTO User (username, password, bio) VALUES (?, ?, ?)";

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, username);
            statement.setString(2, password);
            statement.setString(3, bio);
            statement.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Could not register user", e);
        }
    }

    public User verifyCredentials(String username, String password) {
        String sql = "SELECT username, password, bio FROM User WHERE username = ? AND password = ?";

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, username);
            statement.setString(2, password);

            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return new User(
                            resultSet.getString("username"),
                            resultSet.getString("bio"),
                            resultSet.getString("password"));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Could not verify credentials", e);
        }

        return null;
    }

    public boolean isFollowing(String followerUsername, String followedUsername) {
        String sql = "SELECT 1 FROM Follow WHERE follower_username = ? AND followed_username = ?";

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, followerUsername);
            statement.setString(2, followedUsername);

            try (ResultSet resultSet = statement.executeQuery()) {
                return resultSet.next();
            }
        } catch (SQLException e) {
            throw new RuntimeException("Could not check following status", e);
        }
    }

    public void followUser(String followerUsername, String followedUsername) {
        if (followerUsername == null || followerUsername.isBlank()
                || followedUsername == null || followedUsername.isBlank()
                || followerUsername.equals(followedUsername)
                || isFollowing(followerUsername, followedUsername)) {
            return;
        }

        String sql = "INSERT INTO Follow (follower_username, followed_username) VALUES (?, ?)";

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, followerUsername);
            statement.setString(2, followedUsername);
            statement.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Could not update following relationship", e);
        }
    }

    private int countPosts(String username) {
        return count("SELECT COUNT(*) FROM Post WHERE username = ?", username);
    }

    private int countFollowers(String username) {
        return count("SELECT COUNT(*) FROM Follow WHERE followed_username = ?", username);
    }

    private int countFollowing(String username) {
        return count("SELECT COUNT(*) FROM Follow WHERE follower_username = ?", username);
    }

    private int count(String sql, String username) {
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, username);

            try (ResultSet resultSet = statement.executeQuery()) {
                return resultSet.next() ? resultSet.getInt(1) : 0;
            }
        } catch (SQLException e) {
            throw new RuntimeException("Could not load profile count", e);
        }
    }

    private String findBio(String username) {
        String sql = "SELECT bio FROM User WHERE username = ?";

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, username);

            try (ResultSet resultSet = statement.executeQuery()) {
                return resultSet.next() ? resultSet.getString("bio") : "";
            }
        } catch (SQLException e) {
            throw new RuntimeException("Could not load bio", e);
        }
    }
}
