import java.sql.*;
import edu.brandeis.cs127b.pa2.latex.*;
import java.util.Map;
import java.util.HashMap;
import java.util.TreeSet;
import java.util.Scanner;
import java.util.Set;
public class Part3 {
	static final String JDBC_DRIVER = "com.postgresql.jdbc.Driver";
	static final String DB_TYPE = "postgresql";
	static final String DB_DRIVER = "jdbc";
	static final String DB_NAME = System.getenv("PGDATABASE");
	static final String DB_HOST = System.getenv("PGHOST");
	static final String DB_URL = String.format("%s:%s://%s/%s",DB_DRIVER, DB_TYPE, DB_HOST, DB_NAME);
	static final String DB_USER = System.getenv("PGUSER");
	static final String DB_PASSWORD = System.getenv("PGPASSWORD");
	static Connection conn;

	public static void main(String[] args) throws SQLException{
		conn = DriverManager.getConnection(DB_URL,DB_USER,DB_PASSWORD);
		Scanner in = new Scanner(System.in);
		Document doc = new Document();
		while (in.hasNextLine()){
			String[] arr = in.nextLine().split(":");
			String purchaseNumber = arr[0];
			Set<Part> parts = new TreeSet<Part>();
			Map<Supplier,Set<Part>> suppliers = new HashMap<Supplier,Set<Part>>();

			// Part x = new Part(String number, int quantity);
			//		part.setCost(double cost);
			// Supplier x = new Supplier(String number)
			//------
			// add all parts to buy into parts
			String[] toBuy = arr[1].split(",");
			for (String combo : toBuy) {
				//construct new part
				String[] temp = combo.split("x");
				int quantity = Integer.parseInt(temp[0]);
				String partkey = temp[1];
				Part newPart = new Part(partkey, quantity);
				// find supplier and minCost
				String QUERY = findMin(partkey);
				Statement st = conn.createStatement();
				ResultSet rs = st.executeQuery(QUERY);
				while (rs.next()) {
					String suppkey = rs.getString(1);
					Double cost = rs.getDouble(2);
          newPart.setCost(cost);
          parts.add(newPart);
					// pair supplier and new part
          boolean added = false;
					for (Supplier su : suppliers.keySet()){
            if (su.toString().equals(suppkey)) {
              suppliers.get(su).add(newPart);
              added = true;
              break;
            }
					}
          if (added == false) {
            Supplier supplier = new Supplier(suppkey);
            suppliers.put(supplier, new TreeSet<Part>());
            suppliers.get(supplier).add(newPart);
          }
				}
			}
			//------

			Purchase p = new Purchase(purchaseNumber);
			for (Supplier supp : suppliers.keySet()){
				Suborder o = new Suborder(supp);
				p.add(o);
				for (Part part : suppliers.get(supp)){
                    o.add(part);
				}
			}
			doc.add(p);
		}
		System.out.println(doc);
	}

	public static String findMin(String partkey) {
		String a = "SELECT ps_suppkey, ps_supplycost FROM partsupp WHERE ps_partkey = ";
		String b = "AND ps_supplycost = (SELECT MIN(ps_supplycost) FROM partsupp WHERE ps_partkey = ";
		String c = ");";
		return a + partkey + b + partkey + c;
	}
}
