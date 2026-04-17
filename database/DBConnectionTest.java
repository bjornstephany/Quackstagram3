import java.sql.*;

public class DBConnectionTest {
        private static String dbUrl = "jdbc:mysql://localhost:3306/Quackstagram";
        private static String dbUsername = "root";
        private static String dbPassword = "";

        public static void main(String[] args) {
            try {
            Connection conn = DriverManager.getConnection(dbUrl, dbUsername, dbPassword);
            System.out.println("Connection successful");
            Statement stmt = conn.createStatement();
            String sql = "SELECT username FROM User WHERE username = 'checkpointmember'";
            ResultSet rs = stmt.executeQuery(sql);

                if (rs.next()){
                System.out.println("Checkpoint Member found: " + rs.getString("username"));
                }
                conn.close();
            } catch (SQLException e) {
            e.printStackTrace();
            }
    }
}
