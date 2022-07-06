package Classi;

import java.sql.*;

public class ConnessioneMySql {
	public static void main(String[] args) throws SQLException {
		Connection cn;
		Statement st;
		ResultSet rs;
		
		// ________________________________connessione
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
		} catch (ClassNotFoundException e) {
			System.out.println("ClassNotFoundException: ");
			System.err.println(e.getMessage());
		} // fine try-catch

		// Creo la connessione al database
		cn = DriverManager.getConnection("jdbc:mysql://localhost:3306/dbscout?user=root&password=root"+"&useJDBCCompliantTimezoneShift=true&useLegacyDatetimeCode=false&serverTimezone=Europe/Rome");
		// dbscout è il nome del database

		String OP13 =   "select Atleta.ID,Nome,Cognome,CompetizioneNome,"
				+ "count(CompetizioneNome) as Partecipazione from Atleta,"
				+ "Partecipa where ( Atleta.ID=Partecipa.ID and CompetizioneNome='Mondiale')"
				+ " group by (Atleta.ID) having Partecipazione >= all (select count(CompetizioneNome) as Partecipazione "
				+ "from Atleta,Partecipa where ( Atleta.ID=Partecipa.ID and CompetizioneNome='Mondiale') group by (Atleta.ID));";
		// ________________________________query
		try {
			st = cn.createStatement(); // creo sempre uno statement sulla
										// connessione
			rs = st.executeQuery(OP13); // faccio la query su uno statement
			while (rs.next() == true) {
				System.out.println(rs.getString("Atleta.ID") +  "\t" + rs.getString("Nome")+"\t" + rs.getString("Cognome") + "\t" + rs.getString("CompetizioneNome")+ "\t" + rs.getString("Partecipazione"));
			}
		} catch (SQLException e) {
			System.out.println("errore:" + e.getMessage());
		} // fine try-catch
		cn.close(); // chiusura connessione
	}// fine main
}// fine classe
