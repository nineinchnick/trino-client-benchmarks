package pl.net.was;

import org.openjdk.jmh.annotations.Level;
import org.openjdk.jmh.annotations.Scope;
import org.openjdk.jmh.annotations.Setup;
import org.openjdk.jmh.annotations.State;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

@State(Scope.Benchmark)
public class BenchmarkState
{
    public Connection connection;

    @Setup(Level.Invocation)
    public void setUp()
            throws SQLException
    {
        String url = "jdbc:trino://localhost:8080";
        connection = DriverManager.getConnection(url, "java", "");
    }
}