package GUI;

import javax.swing.*;
import javax.swing.border.Border;

import java.awt.*;

public class TextAreaPanel extends JPanel{
	
	private JTextArea textArea;
	
	public TextAreaPanel() {
		
		textArea= new JTextArea();
		setLayout( new BorderLayout());
		Border bordoText= BorderFactory.createLineBorder(Color.BLACK, 3);
		textArea.setBorder(bordoText);
		add(textArea, BorderLayout.CENTER);
	}
	
	
	
	
	public JTextArea getPs() {
		return textArea;
	}
}
