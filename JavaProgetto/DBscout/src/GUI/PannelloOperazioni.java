package GUI;
import javax.swing.*;
import javax.swing.border.Border;

import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

public class PannelloOperazioni extends JPanel {
	private JButton button;
	private JButton button1;
	private JButton button2;
	private JButton button3;
	private JButton button4;
	private JButton button5;
	private JButton button6;
	private JButton button7;
	private JButton button8;
	private JButton button9;
	private JButton button10;
	private JButton button11;
	private JButton button12;
	private JButton button13;
	
	
	 public PannelloOperazioni () {
		 //Dimensioni pannello
		 Dimension dimensioni= getPreferredSize();
		 dimensioni.width =400;
		 setPreferredSize(dimensioni);
		 
		 //Bordo
		 Border bordo=BorderFactory.createLineBorder(Color.BLACK, 3);
		 Border bordoInterno= BorderFactory.createTitledBorder(bordo, "Operazioni", 2,0);
		 setBorder(bordoInterno); //setta il bordo
		
		 //LAYOUT PANNELLO
		 GridLayout gdv = new GridLayout();
		 setLayout(gdv);
		 gdv.setRows(4); // imposto 5 righe,di conseguenza per le colonne si regolerà in base allo spazio disponibile
		 
		 //JLabel, Jlist per aggiornamento e insert
		 
		 
		
		 
		 //Bottoni

		 Border bordoBottoni= BorderFactory.createEtchedBorder(Color.BLACK, Color.BLACK);
		 
		 button1= new JButton("Operazione 1");
		 button2= new JButton("Operazione 2");
		 button3= new JButton("Operazione 3");
		 button4= new JButton("Operazione 4");
		 //button5= new JButton("Operazione 5");
		 button6= new JButton("Operazione 5");
		 button7= new JButton("Operazione 6");
		 button8= new JButton("Operazione 7");
		 button9= new JButton("Operazione 8");
		 button10= new JButton("Operazione 9");
		 button11= new JButton("Operazione 10");
		 button12= new JButton("Operazione 11");
		 button13= new JButton("Operazione 12");
		 
		 //Aggiungo comando al bottone
		 button1.setActionCommand("Operazione 1");
		 button2.setActionCommand("Operazione 2");
		 button3.setActionCommand("Operazione 3");
		 button4.setActionCommand("Operazione 4");
		 //button5.setActionCommand("Operazione 5");
		 button6.setActionCommand("Operazione 6");
		 button7.setActionCommand("Operazione 7");
		 button8.setActionCommand("Operazione 8");
		 button9.setActionCommand("Operazione 9");
		 button10.setActionCommand("Operazione 10");
		 button11.setActionCommand("Operazione 11");
		 button12.setActionCommand("Operazione 12");
		 button13.setActionCommand("Operazione 13");
		 
		 //Creo oggetto della classe listener per attivare il bottone e creo il bottone stesso
		 button1.addActionListener(new ButtonClickListener());
		 button1.setBackground(Color.WHITE);button1.setBorder(bordoBottoni);
		 add(button1);
		 button2.addActionListener(new ButtonClickListener());
		 button2.setBackground(Color.WHITE);button2.setBorder(bordoBottoni);
		 add(button2);
		 button3.addActionListener(new ButtonClickListener());
		 button3.setBackground(Color.WHITE);button3.setBorder(bordoBottoni);
		 add(button3);
		 button4.addActionListener(new ButtonClickListener());
		 button4.setBackground(Color.WHITE);button4.setBorder(bordoBottoni);
		 add(button4);
		 /*
		 button5.addActionListener(new ButtonClickListener());
		 button5.setBackground(Color.WHITE);button5.setBorder(bordoBottoni);
		 add(button5);*/
		 button6.addActionListener(new ButtonClickListener());
		 button6.setBackground(Color.WHITE);button6.setBorder(bordoBottoni);
		 add(button6);
		 button7.addActionListener(new ButtonClickListener());
		 button7.setBackground(Color.WHITE);button7.setBorder(bordoBottoni);
		 add(button7);
		 button8.addActionListener(new ButtonClickListener());
		 button8.setBackground(Color.WHITE);button8.setBorder(bordoBottoni);
		 add(button8);
		 button9.addActionListener(new ButtonClickListener());
		 button9.setBackground(Color.WHITE);button9.setBorder(bordoBottoni);
		 add(button9);
		 button10.addActionListener(new ButtonClickListener());
		 button10.setBackground(Color.WHITE);button10.setBorder(bordoBottoni);
		 add(button10);
		 button11.addActionListener(new ButtonClickListener());
		 button11.setBackground(Color.WHITE);button11.setBorder(bordoBottoni);
		 add(button11);
		 button12.addActionListener(new ButtonClickListener());
		 button12.setBackground(Color.WHITE);button12.setBorder(bordoBottoni);
		 add(button12);
		 button13.addActionListener(new ButtonClickListener());
		 button13.setBackground(Color.WHITE);button13.setBorder(bordoBottoni);
		 add(button13);
		 
		
	}
}
