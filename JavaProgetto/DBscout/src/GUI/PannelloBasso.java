package GUI;
import javax.swing.*;
import javax.swing.border.Border;

import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

public class PannelloBasso extends JPanel{
	private JLabel labelUpdate;
	private JList listUpdate;
	private JLabel labelInsert;
	private JComboBox menuAggiornamenti;
	private JComboBox menuInserimento;
	private JButton button1;
	
	public PannelloBasso() {
		//Setto Layout
		setLayout(new GridBagLayout());
		
		//Dimensioni pannello
		 Dimension dimensioni= getPreferredSize();
		 dimensioni.height=60;
		 setPreferredSize(dimensioni);
		 
		
		 
		 
		 //Bordo
		 Border bordo=BorderFactory.createLineBorder(Color.BLACK, 3);
		 Border bordoInterno= BorderFactory.createTitledBorder(bordo,"  Aggiornamento-Inserimento  ", 2, 0);
		 setBorder(bordoInterno); //setta il bordo
		
		//LABEL e LIST UPDATE
		 labelUpdate = new JLabel("            Aggiornamenti:        "); //messo lo spazio così mi viene preciso
		 
		 String [] opzioniAggiornamenti= {"1.Palmarès","2.Statistiche","3.Caratteristiche","4.Infortuni","5.Atleta"};
		 menuAggiornamenti= new JComboBox(opzioniAggiornamenti);
		 
		 //Button
		 button1= new JButton("Aiuto");
		 Border bordoBottone= BorderFactory.createEtchedBorder(Color.BLACK, Color.BLACK);
	
		 //LABEL LIST INSERT
		 labelInsert = new JLabel("                                                                                                                                               "
		 		+ "                                                    Inserimenti:");
		 
		 String [] opzioniInserimenti= {"1.Atleta","2.Infortuni","3.Caratteristiche","4.Trasferimenti-Contratti","5.Agente","6.Contratti","7.Competizioni","8.Edizioni"};
		 menuInserimento= new JComboBox(opzioniInserimenti);
		 
		 
		 
		 
		 
		 
		 //Layout
		 GridBagConstraints gbc = new GridBagConstraints();
		 
		 gbc.gridx = 0;
		 gbc.gridy = 0;
		 
		 gbc.weightx= 0.0;
		 gbc.weighty=0.0;
		 gbc.gridwidth=2;
		 
		 add(labelUpdate,gbc);
		 
		 gbc.gridx = 9;
		 gbc.gridy = 0;
		 
		 gbc.weightx= 0.;
		 gbc.weighty=0.0;
		  
		 add(menuAggiornamenti,gbc);
		 
		 gbc.gridx = 12;
		 gbc.gridy = 0;
		 
		 gbc.weightx= 0.0;
		 gbc.weighty=0.0;
		 
		 add(labelInsert,gbc);
		 
		 

		 gbc.gridx = 20;
		 gbc.gridy = 0;
		 
		 gbc.weightx= 0.8;
		 
		 add(menuInserimento,gbc);
		 
		 
		 gbc.gridx = 12;
		 gbc.gridy = 0;
		 
		 gbc.weightx= 0.0;
		 
		 button1.setBackground(Color.WHITE);
		 add(button1,gbc);
		 
		 button1.setActionCommand("Help");
		 button1.addActionListener(new ButtonClickListener());
		 
		 /* Implementa le azioni associate alla JCOMBOBOX , ma è sbagliato perchè ovunque clicco fa sempre la stessa cosa
		  * devi usare il metodo getSelecetITem e fare un metodo*/
		 menuInserimento.setActionCommand("Insert");
	     menuInserimento.addActionListener(new ButtonClickListener());
		 
	
	
		 menuAggiornamenti.setActionCommand("Operazione 5");
	     menuAggiornamenti.addActionListener(new ButtonClickListener());

	}}
