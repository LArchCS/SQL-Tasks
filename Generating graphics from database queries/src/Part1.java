import java.sql.*;
import edu.brandeis.cs127b.pa2.gnuplot.*;

public class Part1 {
	static final String JDBC_DRIVER = "com.postgresql.jdbc.Driver";
	static final String DB_TYPE = "postgresql";
	static final String DB_DRIVER = "jdbc";
	static final String DB_NAME = System.getenv("PGDATABASE");
	static final String DB_HOST = System.getenv("PGHOST");
	static final String DB_URL = String.format("%s:%s://%s/%s",DB_DRIVER, DB_TYPE, DB_HOST, DB_NAME);
	static final String DB_USER = System.getenv("PGUSER");
	static final String DB_PASSWORD = System.getenv("PGPASSWORD");
	static Connection conn;


    static final String QUERY = "SELECT region, year, month, SUM(sales_total) AS amount FROM (SELECT SUM(l_EXTENDEDPRICE * (1-l_DISCOUNT) * (1+l_TAX)) AS sales_total, region.r_name AS region, EXTRACT (MONTH from l_SHIPDATE) AS month, EXTRACT (YEAR from l_SHIPDATE) AS year FROM lineitem, supplier, nation, region WHERE r_regionkey = n_regionkey AND n_nationkey = s_nationkey AND s_suppkey = l_suppkey GROUP BY r_name, l_SHIPDATE) AS p GROUP BY p.region, p.month, p.year ORDER BY p.year, p.month, p.region;";

    public static void main(String[] args) throws SQLException {
    	conn = DriverManager.getConnection(DB_URL,DB_USER,DB_PASSWORD);
        final String title = "Monthly TPC-H Order Sales Total by region";
        final String xlabel = "Year";
        final String ylabel = "Order Total (Thousands)";
        TimeSeriesPlot plot = new TimeSeriesPlot(title, xlabel, ylabel);
        Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(QUERY);
		// construct datelines for different regions
		DateLine l0 = new DateLine("AFRICA");
		DateLine l1 = new DateLine("AMERICA");
		DateLine l2 = new DateLine("ASIA");
		DateLine l3 = new DateLine("EUROPE");
		DateLine l4 = new DateLine("MIDDLE EAST");
		int count = 0;

		while (rs.next()) {
			String region = rs.getString(1);
			double year = rs.getDouble(2);
			double month = rs.getDouble(3);
			double amount = rs.getDouble(4);

			Date d = new Date((int)year - 1900, (int)month, 1);
			DatePoint point = new DatePoint(d, amount / 1000);
			
			// add point to different region accordingly
			if (count % 5 == 0) {
				l0.add(point);
			} else if (count % 5 == 1) {
				l1.add(point);
			} else if (count % 5 == 2) {
				l2.add(point);
			} else if (count % 5 == 3) {
				l3.add(point);
			} else {
				l4.add(point);
			}
			count += 1;
		}
		// add lines to plot
		plot.add(l0);
		plot.add(l1);
		plot.add(l2);
		plot.add(l3);
		plot.add(l4);
		System.out.println(plot);
    }
}
