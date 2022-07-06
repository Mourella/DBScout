package GUI;

import java.awt.*;
import java.awt.event.*;
import javax.swing.*;
import static Classi.TestQuery.*;


public class ButtonClickListener implements ActionListener {

	
	
	 
	 
	 
	 public void actionPerformed(ActionEvent e) {
		
         String command = e.getActionCommand();  
         
         
         switch(command){
             case "Operazione 1":
                 //JOptionPane.showMessageDialog(null, "aggiornamento");
           
                 doSomething("Operazione 1");
                 
                
                 break;
             case "Operazione 2":
                 //JOptionPane.showMessageDialog(null, "inserimento");
            	 
            	 doSomething("Operazione 2");
                 break;
             case "Operazione 3":
            	 //JOptionPane.showMessageDialog(null, "operazioni");
                 doSomething("Operazione 3");
                 break;
             case "Operazione 4":
            	 //JOptionPane.showMessageDialog(null, "operazioni");
                 doSomething("Operazione 4");
                 break;
             case "Operazione 5":        // NOTA BENEEEEEEEEEEEEEEEEEEEEEE rimetter OPERAZIONE 5 sia qua che sotto che nel PannelloOperazioni al buttom5 al posto di insert
            	 //JOptionPane.showMessageDialog(null, "operazioni");
                 doSomething("Operazione 5");
                 break;
             case "Operazione 6":
            	 //JOptionPane.showMessageDialog(null, "operazioni");
                 doSomething("Operazione 6");
                 break;
             case "Operazione 7":
            	 //JOptionPane.showMessageDialog(null, "operazioni");
                 doSomething("Operazione 7");
                 break;
             case "Operazione 8":
            	 //JOptionPane.showMessageDialog(null, "operazioni");
                 doSomething("Operazione 8");
                 break;
             case "Operazione 9":
            	 //JOptionPane.showMessageDialog(null, "operazioni");
                 doSomething("Operazione 9");
                 break;
             case "Operazione 10":
            	 //JOptionPane.showMessageDialog(null, "operazioni");
                 doSomething("Operazione 10");
                 break;
             case "Operazione 11":
            	 //JOptionPane.showMessageDialog(null, "operazioni");
                 doSomething("Operazione 11");
                 break;
             case "Operazione 12":
            	 //JOptionPane.showMessageDialog(null, "operazioni");
                 doSomething("Operazione 12");
                 break;
             case "Operazione 13":
            	 //JOptionPane.showMessageDialog(null, "operazioni");
                 doSomething("Operazione 13");
                 break;
             case "Insert":
            	 //JOptionPane.showMessageDialog(null, "operazioni");
                 doSomething("Insert");
                 break;
                 
             case "Lista Inserimenti":
            	 //JOptionPane.showMessageDialog(null, "operazioni");
                 Frame.appendiTesto("\n"
                 		+ "  LISTA INSERIMENTI\n"
                 		+ "  E' possibile inserire: \n"
                 		+ "  1. Nuovi atleti con relative caratteristiche e palmarès \n"
                 		+ "  2. Nuovi infortuni\n"
                 		+ "  3. Nuove statistiche\n"
                 		+ "  4. Nuovi agenti \n"
                 		+ "  5. Nuovi trasferimenti e contratti associati \n"
                 		+ "  6. Nuovi contratti\n"
                 		+ "  7. Nuove competizioni con edizione associate \n"
                 		+ "\n");
                 break;
              /*Richiamo i metodi del Frame per cancellare e inserire testo nella text area*/
             case "Lista Operazioni":
            	 //JOptionPane.showMessageDialog(null, "operazioni");
            	 Frame.appendiTesto("\n"
            	 		+ " LISTA OPERAZIONI\n"
            	 		+ " OPERAZIONE  1: Restituisce tutti gli atleti under “X”, attaccanti che hanno segnato più di “Y” reti nella competizione “W.\n"
            	 		+ " OPERAZIONE  2: Restituisce le generalità dell’agente che fino all’anno “X” ha concluso i trasferimenti più onerosi.\n"
            	 		+ " OPERAZIONE  3: Restituisce nome,cognome e numero di trofei totali dei giocatori che giocano in un determinato ruolo “X”  e che calciano con il piede “Y”.\n"
            	 		+ " OPERAZIONE  4: Restituisce Nome e cognome dell’atleta che è stato acquistato più di una volta dalla stessa squadra.\n"
            	 		+ " OPERAZIONE  5: Restituisce i difensori con meno ammonizioni nelle partite di campionato.\n"
            	 		+ " OPERAZIONE  6: Restituisce ID,nome e cognome degli atleti con somma di trasferimento minore o uguale a “X” il cui contratto attuale disponga di un ingaggio non superiore “Y”.\n"
            	 		+ " OPERAZIONE  7: Restituisce la nazione che ha atleti under “X” con più “Y” (Assist, gol, ammonizioni,espulsioni,presenze).\n"
            	 		+ " OPERAZIONE  8: Restituisce gli atleti che hanno subito un infortunio nell’ultimo anno.\n"
            	 		+ " OPERAZIONE  9: Restituisce ID degli atleti che hanno partecipato ad una competizione “X” negli ultimi “C” anni  e che hanno come agente “Nome Y Cognome Z”.\n"
            	 		+ " OPERAZIONE 10: Restituisce l’agente che ha “ruolo atleta X”  con il maggior numero di “statistica Y” nell’ultima stagione.\n"
            	 		+ " OPERAZIONE 11: Restituisce le calciatrici assistite dall’agente che ha i calciatori più proficui in termini di gol e assist in tutte le competizioni.\n"
            	 		+ " OPERAZIONE 12: Restituisce gli atleti che hanno il maggior numero di partecipazioni a una determinata competizione X.\n"
            	 		+ "\n"
            	 		);
                 break;
                 
             case "Lista Aggiornamenti":
            	 //JOptionPane.showMessageDialog(null, "operazioni");
            	 Frame.appendiTesto("\n"
            	 		+ "  LISTA AGGIORNAMENTI\n"
            	 		+ "  E' possibile aggiornare le seguenti tabelle:\n"
            	 		+ "  1. Palmarès \n"
            	 		+ "  2. Statistiche riguardanti le competizione a cui partecipa o ha partecipato l'atleta\n"
            	 		+ "  3. Le caratteristiche dei singoli giocatori\n"
            	 		+ "  4. Infortuni\n"
            	 		+ "  5. Le informazioni inerenti ad un atleta\n"
            	 		+ "\n");
                 break;
             case "Libera TextArea":
            	 Frame.canc(); break;
            	 
             case "Help":
            	 Frame.appendiTesto("\n"
            	 		+ "  AIUTO\n"
            	 		+ "  Inserimento/aggiornamento: Selezionare la tabella da aggiornare o su cui inserire dati dai menù a tendina. Per visualizzare quale inserimenti o"
            	 		+ "aggiornamenti si possono eseguire, premere i tasti LISTA INSERIMENTI o LISTA AGGIORNAMENTI\n"
            	 		+ "  I pulsianti OPERAZIONI attivano differenti operazioni sulla basi di dati, visualizzzabili premendo il tasto LISTA OPERAZIONI\n"
            	 		+ "  Il pulsante CANCELLA, libera spazio sulla text area\n");
            default:
                
         }
            
      }  

}
