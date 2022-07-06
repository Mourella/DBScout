package Classi;

import java.awt.Color;
import java.awt.Font;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import java.util.Scanner;

import javax.swing.BorderFactory;

import javax.swing.JOptionPane;
import javax.swing.JTextPane;
import javax.swing.border.Border;
import javax.swing.text.SimpleAttributeSet;

import GUI.Frame;
import GUI.TextAreaPanel;

import java.sql.ResultSetMetaData;




public class TestQuery {
	
	
	
	
    
	
	/**
	 * Preleva dal database il valore dell'email e della password, se corretti crea la sessione 
	 * altrimenti stampa un messaggio di non presenza nel database
	 */
	public static void doSomething(String operazione)
	{
		    
		
			Connection c = DBconnection.getInstance();
			
			
			try {
			
				
				switch(operazione) {
				
				
				case "Operazione 1" : OP1(c); break;
				case "Operazione 2" : OP2(c); break;
				case "Operazione 3" : OP3(c); break;
				case "Operazione 4" : OP4(c); break;
				case "Operazione 5" : OP5(c); break;
				case "Operazione 6" : OP6(c); break;
				case "Operazione 7" : OP7(c); break;
				case "Operazione 8" : OP8(c); break;
				case "Operazione 9" : OP9(c); break;
				case "Operazione 10" : OP10(c); break;
				case "Operazione 11" : OP11(c); break;
				case "Operazione 12" : OP12(c); break;
				case "Operazione 13" : OP13(c); break;
				case "Insert" : Insert(c); break;
				default : System.out.println("Null");
				}
			
			
			}
			
			catch(SQLException e) {
				e.printStackTrace();
			}
		
		
		
			
			
		
	}
	


	

	
	
	
	
	
	
	public static void STAMPA1(ResultSet rs) {
		
		 try {
			
	           
	            ResultSetMetaData rsmd = rs.getMetaData();
	           
	            if(rs.next()){
	            rs.beforeFirst();
	            int columnsNumber = rsmd.getColumnCount();
	            Frame.appendiTesto("\n");
	            for(int j = 1; j <= columnsNumber; j++) {   // questo if controlla se la query ha risultato e in quel caso stampa, altrimenti va all'else 
	            	if (j<columnsNumber) {
	            		
	            	
	            		Frame.appendiTesto("   "+rsmd.getColumnName(j) + "   |");}
	            	else {
	            		Frame.appendiTesto("   "+rsmd.getColumnName(j) + " |\n");
	            		Frame.appendiTesto("\n");}
	            	
	            	
	                
	            }
	          
	            
	          
	            while (rs.next()) {
	                
	                for (int i = 1; i <= columnsNumber; i++) {
	                    String columnValue = rs.getString(i);
	                    if (i<columnsNumber)
	                    	Frame.appendiTesto("  "+columnValue + "    ");
	                    else
	                    	Frame.appendiTesto("  "+columnValue + "\n");
	                }
	                Frame.appendiTesto("");
	                
	            }
	            Frame.appendiTesto("");}
	            else {Frame.appendiTesto(" L'operazione non ha prodotto alcun risultato");}
	            
	        } catch (SQLException ex) {
	            // TODO Auto-generated catch block
	        	Frame.appendiTesto("SQLException: " + ex.getMessage());
	        	Frame.appendiTesto("SQLState: " + ex.getSQLState());
	        	Frame.appendiTesto("VendorError: " + ex.getErrorCode());
	        }
	}
	
	
	public static void libera () { Frame.canc();}
	
	public static void OP1(Connection c)  throws SQLException {
		String a =JOptionPane.showInputDialog("Inserire un numero che identifica il range di età\nEsempio: Under 20");
	    String b = JOptionPane.showInputDialog("Inserire un numero di gol: ");
        String d = JOptionPane.showInputDialog("Inserire una competizione tra:\nCampionato,Coppa,Coppa Europea,Mondiale,Europeo/Copa Amèrica");
       
		PreparedStatement stm = c.prepareStatement("select ID,Nome,Cognome\r\n"
				+ "from AtletaPosizioni\r\n"
				+ "where ((Year(current_date())-Year(DataNascita)<="+a+") and Ruolo='Attaccante' and ID in (select distinct Atleta from statistiche_torneo where (Gol>"+b+" and CompetizioneNome="+"'"+d+"'"+")));");
		
		ResultSet rs = stm.executeQuery();
	
		STAMPA1(rs);
		
		
		
		
	};
	public static void OP2(Connection c) throws SQLException {
		
		libera();
        String a = JOptionPane.showInputDialog("Inserire anno:");
		PreparedStatement stm = c.prepareStatement("select Codice,Nome_Agente,Cognome_Agente from trasferimentiagente where(ID_trasferimento in (select ID_trasferimento from trasferimenti  where (Year(Data_inizio)<"+a+"))) group by (Codice) order by sum(Somma) desc limit 1 ; ");
		
		ResultSet rs = stm.executeQuery();
		
		STAMPA1(rs);
		
	}
	public static void OP3(Connection c) throws SQLException { 
		libera();

        String a = JOptionPane.showInputDialog("Inserire un ruolo tra:\nPortiere,difensore,centrocampista,attaccante");
        String b =JOptionPane.showInputDialog("Inserire il piede con cui calcia l'atleta:\nSx o Dx ");

		
		PreparedStatement stm = c.prepareStatement("select Nome, Cognome, Trofei_totali(Numero_trofei_squadra,Numero_trofei_personali) as Trofei_Totali\r\n"
				+ "from atletaposizioni join palmarès on palmarès.Atleta=Atletaposizioni.ID\r\n"
				+ "where ( Ruolo="+"'"+a+"'"+" and  ID in (select Atleta from caratteristiche where (Piede="+"'"+b+"'"+")));");
		ResultSet rs = stm.executeQuery();
	
		STAMPA1(rs);
		
		
	};
	
	public static void OP4(Connection c) throws SQLException{
		libera();
		JOptionPane.showMessageDialog(null, "OPERAZIONE  4:\nRestituisce Nome e cognome dell’atleta che è stato acquistato più di una volta dalla stessa squadra. ");
		PreparedStatement stm = c.prepareStatement("select ID,Nome,Cognome from Atleta where (ID in \r\n"
				+ "(select Atleta from trasferimenti group by Atleta,Acquirente having count(Acquirente)>=2));");
		ResultSet rs = stm.executeQuery();
		STAMPA1(rs);
		
		
	};
	
	public static void OP5(Connection c) throws SQLException{
		 int Gol = Integer.parseInt(JOptionPane.showInputDialog("Inserire Gol da aggiungere :"));
		 int Assist = Integer.parseInt(JOptionPane.showInputDialog("Inserire Assist da aggiugere:"));
		 int  Presenze = Integer.parseInt(JOptionPane.showInputDialog("Inserire Presenze da aggiugere:"));
		 int Espulsioni = Integer.parseInt(JOptionPane.showInputDialog("Inserire Espulsioni da aggiungere:"));
		 int Ammonizioni = Integer.parseInt(JOptionPane.showInputDialog("Inserire Ammonizioni da aggiungere:"));
		 int Doppie = Integer.parseInt(JOptionPane.showInputDialog("Inserire Doppie ammonizioni da aggiungere:"));
		 String ID = JOptionPane.showInputDialog("Inserire ID atleta:\nOBBLIGATORIO");
		 String Edizione = JOptionPane.showInputDialog("Inserire Edizione:\nOBBLIGATORIO");
		 String Comp = JOptionPane.showInputDialog("Inserire nome della Competizione:\nOBBLIGATORIO");
		 System.out.print(ID);
		
		 try {

			PreparedStatement stm = c.prepareStatement("Update Statistiche_torneo SET Gol=(Gol+ ?), Assists=(Assists+?), Presenze=(Presenze+ ?),Espulsioni=(Espulsioni+?),"
						+ "Ammonizioni=(Ammonizioni+?),Doppie_Ammonizioni=(Doppie_Ammonizioni+?)"
						+ "where (Atleta=? and EdizioneA=? and CompetizioneNome=?);");
	            
	            //Inserisco i parametri di input
	            stm.setInt(1, Gol);
	            stm.setInt(2, Assist);
	            stm.setInt(3, Presenze);
	            stm.setInt(4, Espulsioni);
	            stm.setInt(5, Ammonizioni);
	            stm.setInt(6, Doppie);
	            stm.setString(7, ID);
	            stm.setString(8, Edizione);
	            stm.setString(9, Comp);
	            stm.executeUpdate();
	            stm.close();
	        //Query che fa vedere il risultato aggiornato prendendo id,Edizione e competizione obbligatori per riconoscere la tupla    
	        PreparedStatement stm1 = c.prepareStatement("select * from Statistiche_torneo where(Atleta="+"'"+ID+"'"+" and EdizioneA="+"'"+Edizione+"'"+" and CompetizioneNome="+"'"+Comp+"'"+");");
	     
	        Frame.appendiTesto("L'aggiornamento ha prodotto il seguente risultato:\n");
	        ResultSet rs=stm1.executeQuery();
	        STAMPA1(rs);
	        
	        } catch (SQLException ex) {
	            Frame.appendiTesto(" SQLException: " + ex.getMessage()+"\n");
	            Frame.appendiTesto(" SQLState: " + ex.getSQLState()+"\n");
	            Frame.appendiTesto(" VendorError: " + ex.getErrorCode()+"\n");
	        }
			
		
		
	};
	public static void OP6(Connection c) throws SQLException{
		libera();
		JOptionPane.showMessageDialog(null, "OPERAZIONE  5:\nRestituisce i difensori con meno ammonizioni nelle partite di campionato. ");
		PreparedStatement stm = c.prepareStatement("select ID, Nome,Cognome,Ammonizioni from  AmmonizioniCampionato join atletaposizioni  On Atletaposizioni.ID=AmmonizioniCampionato.Atleta where (Ruolo='Difensore') order by(Ammonizioni) limit 1;");
		ResultSet rs = stm.executeQuery();
		
		STAMPA1(rs);
		
	};
	public static void OP7(Connection c) throws SQLException{
		libera();
		
 
        String a = JOptionPane.showInputDialog("Inserire la somma di trasferimento entro il quale si vuole cercare: ");
        
        String b = JOptionPane.showInputDialog("Inserire ingaggio dell'atleta entro il quale si vuole cercare:");
        
       
		
		PreparedStatement stm = c.prepareStatement("select Nome, Cognome,ID\r\n"
				+ "from Atleta as A\r\n"
				+ "where ( ID in (select Atleta\r\n"
				+ "				from trasferimenti as T\r\n"
				+ "				 where (T.Somma_trasferimento<="+a+" and T.Atleta = any (select Atleta \r\n"
				+ "																		from contratti as C\r\n"
				+ "																		where ( C.Ingaggio<="+b+" and Scaduto=0 )))));");
		ResultSet rs = stm.executeQuery();
		
		STAMPA1(rs);
		
	};
	public static void OP8(Connection c) throws SQLException{
		libera();
	
        
		
        String a = JOptionPane.showInputDialog("Inserire un numero che identifica il range di età\nEsempio: Under 20");
        String b = JOptionPane.showInputDialog("Inserire la statistica tra:\nGol,Assists,Presenze,Espulsioni,Ammonizioni,Doppie_Ammonizioni ");
        
        
		PreparedStatement stm = c.prepareStatement("select Nazionalità  from atleta join statistiche_torneo on ID=Atleta  where (Year(current_date())-Year(Data_di_nascita)<="+a+")  group by (Nazionalità) order by  sum("+b+") desc limit 1;");
		ResultSet rs = stm.executeQuery();
		STAMPA1(rs);
	};
	public static void OP9(Connection c) throws SQLException{
		libera();
		JOptionPane.showMessageDialog(null, "OPERAZIONE  8:\nRestituisce gli atleti che hanno subito un infortunio nell’ultimo anno.");
		PreparedStatement stm = c.prepareStatement("select ID,Nome,Cognome,Data_inizio,Data_fine from atleta join infortuni on ID=Atleta where (Year(Data_inizio)=Year(current_date())-1 and Year(Data_fine)=Year(current_date())-1); ");
		ResultSet rs = stm.executeQuery();
		STAMPA1(rs);
	};
	public static void OP10(Connection c) throws SQLException{
		libera();
		
        
		
        String a = JOptionPane.showInputDialog("Inserire una competizione tra:\nCampionato,Coppa,Coppa Europea,Mondiale,Europeo/Copa Amèrica ");
        String b = JOptionPane.showInputDialog("Inserire un range di anni:\nEsempio 5 (sta a significare 'ultimi 5 anni') ");
        String d = JOptionPane.showInputDialog("Inserire il nome dell'agente: ");
        String e = JOptionPane.showInputDialog("Inserire il cognome dell'agente: ");
        
        
		PreparedStatement stm = c.prepareStatement("select ID_Atleta as Atleta from agenteatleta  where (Nome_Agente="+"'"+d+"'"+" and Cognome_Agente="+"'"+e+"'"+" and ID_Atleta = any (select ID from partecipa where (CompetizioneNome="+"'"+a+"'"+" and Year(current_date())-"+b+")));");
		ResultSet rs = stm.executeQuery();
		STAMPA1(rs);
	};
	public static void OP11(Connection c) throws SQLException{
		libera();
		
       
		
        String a = JOptionPane.showInputDialog("Inserire un ruolo tra:\nPortiere,difensore,centrocampista,attaccante");
        String b = JOptionPane.showInputDialog("Inserire la statistica tra:\nGol,Assists,Presenze,Espulsioni,Ammonizioni,Doppie_Ammonizioni ");
        
       
		PreparedStatement stm = c.prepareStatement("select Codice,Nome,Cognome\r\n"
				+ "from Agente\r\n"
				+ "where (Codice = (select Agente\r\n"
				+ "				 from statistiche_torneo join atleta on ID=Atleta \r\n"
				+ "				 where (ID in (select Atleta from Ricopre \r\n"
				+ "									 where (Posizione="+"'"+a+"'"+")))\r\n"
				+ "																		   group by(Agente) \r\n"
				+ "																		   order by sum("+b+") desc limit 1));");
		ResultSet rs = stm.executeQuery();
		STAMPA1(rs);
	};
	public static void OP12(Connection c) throws SQLException{
		libera();
		JOptionPane.showMessageDialog(null, "OPERAZIONE 11:\nRestituisce le calciatrici assistite dall’agente che ha i calciatori più proficui in termini di gol e assist in tutte le competizioni.");
		PreparedStatement stm = c.prepareStatement("select ID,Nome,Cognome,Nazionalità,Genere,Data_di_nascita,Valore_di_mercato,Agente\r\n"
				+ "from Atleta \r\n"
				+ "where (Genere='F' and Agente= (select Codice\r\n"
				+ "								from statistichetotaligiocatori as T , Agente\r\n"
				+ "								where ( Agente.Codice=Agente and Genere='M')\r\n"
				+ "								group by (Codice)\r\n"
				+ "								order by Sum(Gol+Assist) desc limit 1));");
		ResultSet rs = stm.executeQuery();
		STAMPA1(rs);
	};
	public static void OP13(Connection c) throws SQLException{
		libera();
	
        
		
        String a = JOptionPane.showInputDialog("Inserire una competizione tra:\nCampionato,Coppa,Coppa Europea,Mondiale,Europeo/Copa Amèrica");
        
        
		PreparedStatement stm = c.prepareStatement("select ID,Nome,Cognome,Competizione,Partecipazioni\r\n"
				+ "from Giocatorepartecipazioni\r\n"
				+ "where (Competizione='Mondiale')\r\n"
				+ "Having Partecipazioni >= all (select Partecipazioni \r\n"
				+ "							 from Giocatorepartecipazioni \r\n"
				+ "							where (Competizione="+"'"+a+"'"+"));");
		ResultSet rs = stm.executeQuery();
		STAMPA1(rs);
		
	};
	
	public static void Insert(Connection c) throws SQLException{
		libera();
		String ID = JOptionPane.showInputDialog("Inserire ID atleta:");
		String Nome = JOptionPane.showInputDialog("Inserire Nome atleta:");
		String Cognome = JOptionPane.showInputDialog("Inserire Cognome atleta:");
		String Nazionalità = JOptionPane.showInputDialog("Inserire Nazionalità atleta:");
		String Genere = JOptionPane.showInputDialog("Inserire Genere atleta:");
	    String Data = JOptionPane.showInputDialog("Inserire Data di nascita atleta:");
	    int Valore = Integer.parseInt(JOptionPane.showInputDialog("Inserire valore:"));
	    String Agente= JOptionPane.showInputDialog("Inserire ID agente:");
		 try {

				PreparedStatement stm = c.prepareStatement("insert into Atleta values (?,?,?,?,?,?,?,?);");
		            
		            //Inserisco i parametri di input
		            stm.setString(1, ID);
		            stm.setString(2, Nome);
		            stm.setString(3, Cognome);
		            stm.setString(4, Nazionalità);
		            stm.setString(5, Genere);
		            stm.setString(6, Data);
		            stm.setInt(7, Valore);
		            stm.setString(8, Agente);
		     
		            stm.executeUpdate();
		            stm.close();
		            
		            //Query che fa vedere il risultato aggiornato prendendo id,Edizione e competizione obbligatori per riconoscere la tupla    
			        PreparedStatement stm1 = c.prepareStatement("select * from Atleta where(ID="+"'"+ID+"'"+" and Nome="+"'"+Nome+"'"+" and Cognome="+"'"+Cognome+"'"+");");
			        Frame.appendiTesto("L'inserimento ha prodotto il seguente risultato:\n");
			        ResultSet rs=stm1.executeQuery();
			        STAMPA1(rs);
		            
		            
		            
		        } catch (SQLException ex) {
		        	Frame.appendiTesto("SQLException: " + ex.getMessage()+"\n");
		            Frame.appendiTesto("SQLState: " + ex.getSQLState()+"\n");
		            Frame.appendiTesto("VendorError: " + ex.getErrorCode()+"\n");
		        }
	}
		
	
	public static void main(String[] args) {
		doSomething("Operazione 1");
		
		doSomething("Operazione 2");
		
		doSomething("Operazione 3");
		
		doSomething("Operazione 4");
		
	
		doSomething("Operazione 5");
		
		
		doSomething("Operazione 6");
		
	
		doSomething("Operazione 7");
		
		
		doSomething("Operazione 8");
		
		doSomething("Operazione 9");
		
		doSomething("Operazione 10");
		
		doSomething("Operazione 11");
		
		doSomething("Operazione 12");
		
		doSomething("Operazione 13");
		
		
		/*
		System.out.print("Enter Input : ");
        Scanner scanner = new Scanner(System.in);
        String a=scanner.nextLine();
        String b=scanner.nextLine();
        System.out.print(a + b);
       
     	
        
        scanner.close();*/
	}
}
	
	
