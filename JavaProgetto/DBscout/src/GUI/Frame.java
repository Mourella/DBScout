package GUI;

import javax.swing.*;
import java.awt.*;
public class Frame extends JFrame{

	
	private static TextAreaPanel  textArea;
	private JButton button;

	private PannelloOperazioni pannello;
	private BarraStrumenti barra;
	private PannelloBasso pannelloBasso;
	public static void appendiTesto(String testo) {  //STAMPA NELLA TEXTAREA
		textArea.getPs().append(testo); 
	}
 
	
	
	public static void canc() { textArea.getPs().setText(" ");} //LIBERA LA TEXTAREA
	
	public Frame() {
		
		
		
		 super("DBScout"); //richiamo costruttore
		
		
		 setLayout( new BorderLayout());
		
		 
		 // CREAZIONI COMPONENTI
		 pannello= new PannelloOperazioni();
		 textArea = new TextAreaPanel();
		 barra= new BarraStrumenti();
		 pannelloBasso= new PannelloBasso();
		 
		 
		 
		 
		 //AGGIUNGO COMPONENTI
		
		 add(barra , BorderLayout.PAGE_START);
		 add(new JScrollPane(textArea), BorderLayout.CENTER);
		 
		
		 add(pannello, BorderLayout.LINE_START);
		 add(pannelloBasso, BorderLayout.PAGE_END);
		 
		 
		
		
		 setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE); //chiusura definitiva
	     setSize(1200,500); //dimensione finestra
	       
	     setLocationRelativeTo(null);// fa apparire la finestra al centro
	       //c'è anche la funzione per bloccare la dimensione della classe
	     setVisible(true);
		
	}
}
