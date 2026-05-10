package src.model;

public class SessionStore {
    private static String loggedInUsername;

    public String getLoggedInUsername() {
        return loggedInUsername;
    }

    public void setLoggedInUsername(String username) {
        loggedInUsername = username;
    }

    public void clear() {
        loggedInUsername = null;
    }
}
