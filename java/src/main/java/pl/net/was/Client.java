package pl.net.was;

import org.openjdk.jmh.annotations.Benchmark;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.List;

import static java.lang.String.format;


class Client
{
    public static void main(String[] args)
            throws Exception
    {
        String url = "jdbc:trino://localhost:8080";
        Connection connection = DriverManager.getConnection(url, "java", "");
        int numRows = query(connection);
        if (numRows != 100000) {
            throw new Exception(format("Expected 100000 rows but got %d", numRows));
        }
    }

    public static int query(Connection connection)
            throws SQLException
    {
        Statement stmt = connection.createStatement();
        String query = """
SELECT
  orderkey
  , custkey
  , orderstatus
  , totalprice
  , orderdate
  , orderpriority
  , clerk
  , shippriority
  , comment
  , now
FROM memory.default.orders""";
        ResultSet resultSet = stmt.executeQuery(query);

        int numRows = 0;
        int allCommentsLength = 0;
        while (resultSet.next()) {
            List<Object> values = List.of(
                    resultSet.getLong(1),
                    resultSet.getLong(2),
                    resultSet.getString(3),
                    resultSet.getDouble(4),
                    resultSet.getDate(5),
                    resultSet.getString(6),
                    resultSet.getString(7),
                    resultSet.getInt(8),
                    resultSet.getString(9),
                    resultSet.getString(10));
            numRows++;
            allCommentsLength += ((String)values.get(8)).length();
        }
        System.out.printf("Average comment length: %.2f\n", (double) allCommentsLength / numRows);
        return numRows;
    }
}
