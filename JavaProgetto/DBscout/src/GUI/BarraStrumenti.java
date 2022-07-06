package GUI;
import javax.swing.*;
import javax.swing.border.Border;

import java.awt.*;

public class BarraStrumenti extends JPanel {
	private JButton button1;
	private JButton button2;
	private JButton button3;
	private JButton button4;
	public BarraStrumenti() {
		
		button1= new JButton("Lista Inserimenti");
		button2= new JButton("Lista Operazioni");
		button3= new JButton("Lista Aggiornamenti");
		button4= new JButton("Cancella");
		
		setLayout( new FlowLayout());
		
		
		/* Gli stessi nomi all'interno dei setAction, devono essere presenti anche nel  switch case
		 * nella calsse ButtonClickListener, altrimenti non si attiva il bottone
		 * 
		 */
		button1.setActionCommand("Lista Inserimenti");
		button2.setActionCommand("Lista Operazioni");
		button3.setActionCommand("Lista Aggiornamenti");
		button4.setActionCommand("Libera TextArea");       
		
		
		button1.addActionListener(new ButtonClickListener());
		button2.addActionListener(new ButtonClickListener());
		button3.addActionListener(new ButtonClickListener());
		button4.addActionListener(new ButtonClickListener());
		//Bordo bottoni e aggiunta bottone
		Border bordoBottoni= BorderFactory.createLineBorder(Color.BLACK, 1);
		button1.setBackground(Color.WHITE);
		add(button1); 
		button2.setBackground(Color.WHITE);
		add(button2);
		button3.setBackground(Color.WHITE);
		add(button3);
		
		button4.setBackground(Color.RED);
		add(button4);
		
	};
	
}
