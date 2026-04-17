import java.sql.*;

public class DBConnectionTest {

    public class Main {
        private static String dbUrl = "jdbc:mysql://localhost:3306/Quackstagram";
        private static String dbUsername = "root";
        private static String dbPassword = "";

        public static void main(String[] args) {
            try {
            Connection conn = DriverManager.getConnection(dbUrl, dbUsername, dbPassword);
            System.out.println("Connection successful");
            Statement stmt = conn.createStatement();
            String sql = "SELECT alias FROM User WHERE alias = 'checkpointmember'";
            ResultSet rs = stmt.executeQuery(sql);

                if (rs.next()){
                System.out.println("Checkpoint Member found: " + rs.getString("alias"));
                }
                conn.close();
            } catch (SQLException e) {
            e.printStackTrace();
            }
        }
    }
}
