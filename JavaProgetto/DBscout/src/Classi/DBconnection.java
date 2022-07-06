package Classi;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Classe per connessione al database MySQL
 * @author Morelli
 *
 */
public class DBconnection 
{
	/**
	 * Contiene la connessione al database
	 */
	private static Connection c;
	/**
	 * Indirizzo del database
	 */
	private final static String URL = "jdbc:mysql://localhost:3306/dbscout";
	/**
	 * Nome utente
	 */
	private final static String USER = "root";
	/**
	 * Password 
	 */
	private final static String PASSWORD = "root";
	/**
	 * Classe driver per collegamento a MySQL
	 */
	private final static String DRIVER = "com.mysql.cj.jdbc.Driver";
    
    private DBconnection() { }
    
    /**
     * Restituisce la connessione al database
     * @return c connessione
     */
    public static Connection getInstance()
    {
    	if(c == null) 
    	{
    		try 
        	{
        		Class.forName(DRIVER);
        	}
        	catch(ClassNotFoundException e)
        	{
        		e.printStackTrace();
        	}
        	
        	try
        	{
        		c = DriverManager.getConnection("jdbc:mysql://localhost:3306/dbscout?user=root&password=root"+"&useJDBCCompliantTimezoneShift=true&useLegacyDatetimeCode=false&serverTimezone=Europe/Rome");
        	}
        	catch(SQLException e)
        	{
        		e.printStackTrace();
        	}
    	}
    	
    	return c;
    }
}

