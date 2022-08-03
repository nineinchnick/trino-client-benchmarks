import java.nio.file.Files;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

import static java.lang.String.format;

class Client
{
    public static void main(String[] args)
            throws Exception
    {
        String query = Files.readString(Paths.get("query.sql"));

        String url = "jdbc:trino://localhost:8080";
        Connection connection = DriverManager.getConnection(url, "java", "");
        Statement stmt = connection.createStatement();
        ResultSet resultSet = stmt.executeQuery(query);

        int size = 0;
        while (resultSet.next()) {
            size++;
        }
        if (size != 100000) {
            throw new Exception(format("Expected 100000 rows but got %d", size));
        }
    }
}
