import java.sql.*;
import edu.brandeis.cs127b.pa2.graphviz.*;
public class Part2 {
	static final String JDBC_DRIVER = "com.postgresql.jdbc.Driver";
	static final String DB_TYPE = "postgresql";
	static final String DB_DRIVER = "jdbc";
	static final String DB_NAME = System.getenv("PGDATABASE");
	static final String DB_HOST = System.getenv("PGHOST");
	static final String DB_URL = String.format("%s:%s://%s/%s",DB_DRIVER, DB_TYPE, DB_HOST, DB_NAME);
	static final String DB_USER = System.getenv("PGUSER");
	static final String DB_PASSWORD = System.getenv("PGPASSWORD");

	static final String QUERY = "SELECT  c.r_name, s.r_name, SUM(s.total) FROM (SELECT SUM(l_EXTENDEDPRICE * (1-l_DISCOUNT) * (1+l_TAX)) AS total, r_name, l_orderkey FROM lineitem, supplier, nation, region WHERE r_regionkey = n_regionkey AND n_nationkey = s_nationkey AND s_suppkey = l_suppkey GROUP BY r_name, l_orderkey) AS s, (SELECT o_orderkey, r_name FROM orders, customer, nation, region WHERE r_regionkey = n_regionkey AND n_nationkey = c_nationkey AND c_custkey = o_custkey GROUP BY r_name, o_orderkey) AS c WHERE c.o_orderkey = s.l_orderkey GROUP BY c.r_name, s.r_name;";

	public static void main(String[] args) throws SQLException{
		DirectedGraph g = new DirectedGraph();
		try {
			Connection conn = DriverManager.getConnection(DB_URL,DB_USER,DB_PASSWORD);
			Statement st = conn.createStatement();
     		ResultSet rs = st.executeQuery(QUERY);
			String fromLabel;
			String toLabel;
			String weight;
			while ( rs.next() ) {
				fromLabel = rs.getString(1).trim();
				toLabel = rs.getString(2).trim();
				weight = rs.getString(3).trim();
				// trim weight to "M"
				weight = "$" + weight.substring(0, weight.length() - 13) + "M";
				Node from = new Node(fromLabel);
				Node to = new Node(toLabel);
				DirectedEdge e = new DirectedEdge(from, to);
				e.addLabel(weight);
				g.add(e);
			}
			System.out.println(g);
		} catch (SQLException s) {
			throw s;
		}
	}
}
