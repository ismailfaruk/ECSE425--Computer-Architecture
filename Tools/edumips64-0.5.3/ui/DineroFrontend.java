/* DineroFrontend.java
 *
 * Graphical frontend for DineroIV
 * (c) 2006 Andrea Spadaccini
 *
 * This file is part of the EduMIPS64 project, and is released under the GNU
 * General Public License.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */

package edumips64.ui;

import edumips64.utils.Config;
import javax.swing.*;
import javax.swing.border.*;
import java.awt.*;
import javax.swing.*;
import java.awt.event.*;
import java.io.*;

/** Graphical frontend for DineroIV
 *  @author Andrea Spadaccini
 */

public class DineroFrontend extends JDialog {
	// Attributes are static in order to make them accessible from
	// the nested anonymous classes. They can be static, because at most
	// one instance of DineroFrame will be created in EduMIPS64
	private static JLabel pathLabel, paramsLabel, cacheLeveLabel, cacheTypeLabel;	//labels for cache level and cache type added
	private static JTextField path, params;
	private static JButton browse, execute, configure, create;	//configure and create buttons added to create panels and cache parameters
	private static JTextArea result;
	public static JPanel panelL1, panelL2, panelL3, panelL4, panelL5;	//static panels to add configuration components
	private static JComboBox cacheLevel, cacheType;		//static delcaration of cache combo boxes
	private static Container cp;
	private static int argLevel;	//static declaration of array Level argument
	private static char argType;	//static declaration of array type argument
	private static Box cachePanel;	//static container globally declared for flexibility
	private static JScrollPane scrollPane;	//static delclaration of scrollbar

	private class ReadStdOut extends Thread
	{
	    public boolean finish = false;
	    private BufferedReader stdOut; 
	    private BufferedReader stdErr;
	    public ReadStdOut (	BufferedReader stdOut, BufferedReader stdErr, JTextArea result) 
	    {
		this.stdOut = stdOut;
		this.stdErr = stdErr;
	    }
	    public void run()
		{
			boolean found = false;
			String s;

			try
			{
				while (!finish)
				{
					if(stdOut.ready())
						while ((s = stdOut.readLine()) != null) {
							if(s.equals("---Simulation complete."))
								found = true;
							if(found)
								result.append(s + "\n");
						} 
					if(stdErr.ready())
						while ((s = stdErr.readLine()) != null) 
						{
							result.append(">> Dinero error: " + s + "\n");
						}
				}
			}
			catch (java.io.IOException ioe) 
			{
				result.append(">> ERROR: " + ioe);
			}
    	}
	}

	public DineroFrontend(Frame owner) {
		super(owner);
		setTitle("Dinero frontend");
		cp = rootPane.getContentPane();
		cp.setLayout(new BoxLayout(cp, BoxLayout.PAGE_AXIS));

		final Dimension hSpace = new Dimension(5, 0);
		final Dimension vSpace = new Dimension(0, 5);
		
		pathLabel = new JLabel("DineroIV executable path:");
		paramsLabel = new JLabel("Command line parameters:");

		path = new JTextField((String)Config.get("dineroIV"));
		params = new JTextField("-l1-usize 512 -l1-ubsize 64");

		path.setPreferredSize(new Dimension(400, 26));
		path.setMaximumSize(new Dimension(1000, 26));
		path.setMinimumSize(new Dimension(50, 25));

		params.setPreferredSize(new Dimension(400, 26));
		params.setMaximumSize(new Dimension(1000, 26));
		params.setMinimumSize(new Dimension(50, 26));

		params.addKeyListener(new KeyAdapter() {
			public void keyReleased(KeyEvent e) {
				if(e.getKeyCode() == KeyEvent.VK_ENTER) {
					execute.doClick();
				}
			}
		});

		String[] level = {"1", "2", "3", "4", "5"};
		String[] type = {"data", "instruction", "unified/mixed"};

		cacheLeveLabel	= new JLabel("Set Cache Level (N)");	//Label for cacheLevel
		cacheTypeLabel  = new JLabel("Set Cache Type (T)");	//Label for cacheType

		cacheLeveLabel.setPreferredSize(new Dimension(110, 26));
		cacheLeveLabel.setMaximumSize(new Dimension(120, 26));
		cacheLeveLabel.setMinimumSize(new Dimension(90, 26));

		cacheTypeLabel.setPreferredSize(new Dimension(110, 26));
		cacheTypeLabel.setMaximumSize(new Dimension(120, 26));
		cacheTypeLabel.setMinimumSize(new Dimension(80, 26));

		//combo box defined for cache level
		cacheLevel = new JComboBox(level);
		cacheLevel.setPreferredSize(new Dimension(80, 26));
		cacheLevel.setMaximumSize(new Dimension(100, 26));
		cacheLevel.setMinimumSize(new Dimension(60, 26));
		
		//combo box defined for cache type
		cacheType = new JComboBox(type);
		cacheType.setPreferredSize(new Dimension(110, 26));
		cacheType.setMaximumSize(new Dimension(130, 26));
		cacheType.setMinimumSize(new Dimension(100, 26));

		//combo box action of cache level - passing combo option to argument for cache panel
		cacheLevel.addActionListener(new ActionListener(){
			public void actionPerformed(ActionEvent e){
				String levelMsg = String.valueOf(cacheLevel.getSelectedItem());
				argLevel = Integer.parseInt(levelMsg);
			}
		});
		cacheLevel.setSelectedIndex(0);

		//combo box action of cache type - passing combo option to argument for cache panel
		cacheType.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e){
				argType = (String.valueOf(cacheType.getSelectedItem())).charAt(0);
			}
		});
		cacheType.setSelectedIndex(2);

		//button for creating cache defined
		create = new JButton("Create Cache");
		create.setAlignmentX(Component.RIGHT_ALIGNMENT);
		
		//button for configuring cache defined
		configure = new JButton("Configure Cache");
		configure.setAlignmentX(Component.CENTER_ALIGNMENT);

		browse = new JButton("Browse...");
		browse.setAlignmentX(Component.RIGHT_ALIGNMENT);
		execute = new JButton("Execute");
		execute.setAlignmentX(Component.CENTER_ALIGNMENT);

		//action for cache create button - creates panel to add cache parameters, based on cache level and type
		create.addActionListener(new ActionListener(){
			public void actionPerformed(ActionEvent e){

				cachePanel.removeAll();

				//Panels for different cache type and their configuration options
				cachePanel.add(panelL1 = new DineroSingleCachePanel(argType, 1));

				if (argLevel > 1){
					cachePanel.add(Box.createRigidArea(vSpace));
					cachePanel.add(panelL2 = new DineroSingleCachePanel(argType, 2));
				}
				
				if (argLevel > 2){
					cachePanel.add(Box.createRigidArea(vSpace));
					cachePanel.add(panelL3 = new DineroSingleCachePanel(argType, 3));
				}

				if (argLevel > 3){
					cachePanel.add(Box.createRigidArea(vSpace));
					cachePanel.add(panelL4 = new DineroSingleCachePanel(argType, 4));
				}

				if (argLevel > 4){
					cachePanel.add(Box.createRigidArea(vSpace));
					cachePanel.add(panelL5 = new DineroSingleCachePanel(argType, 5));
				}

				//For cache panel container refresh
				cachePanel.revalidate();
				cachePanel.repaint();
			}
		});

		//Action for cache configure button - to accumulate cache parameters
		configure.addActionListener(new ActionListener(){
			public void actionPerformed(ActionEvent e){
				String parameter;
				//cache parameter only taken for defined cache levels
				parameter = panelL1.toString();
				if (argLevel > 1){parameter += panelL2.toString();}
				if (argLevel > 2){parameter += panelL3.toString();}
				if (argLevel > 3){parameter += panelL4.toString();}
				if (argLevel > 4){parameter += panelL5.toString();}	
				params.setText(parameter);
			}
		});
		
		browse.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e){
			JFileChooser jfc = new JFileChooser();
				int val = jfc.showOpenDialog(null);
				if(val == JFileChooser.APPROVE_OPTION){
					Config.set("dineroIV",jfc.getSelectedFile().getPath());
					path.setText(jfc.getSelectedFile().getPath());
				}
			}
		});
		
		execute.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				try {
					// Process representing Dinero
					String dineroPath = path.getText();
					String paramString = params.getText();

					// Cleaning the JTextArea
					result.setText("");
					result.append(">> Dinero path: " + dineroPath + "\n");
					result.append(">> Dinero parameters: " + paramString + "\n");

					Process dinero = Runtime.getRuntime().exec(dineroPath + " " + paramString);
					result.append(">> Simulation results:\n");
					// Readers associated with Dinero output streams
					BufferedReader stdErr = new BufferedReader(new InputStreamReader(dinero.getErrorStream()));
					BufferedReader stdOut = new BufferedReader(new InputStreamReader(dinero.getInputStream()));
				        ReadStdOut th = null;
					if(edumips64.Main.isWindows())
					{
					    th = new ReadStdOut(stdOut,stdErr,result);
					    th.start();
					}

					// Writer associated with Dinero input streams
					PrintWriter dineroIn = new PrintWriter(dinero.getOutputStream());

					String s = new String();

					// Let's send the tracefile to Dinero
					edumips64.core.Dinero.getInstance().writeTraceData(dineroIn);
					dineroIn.flush();
					dineroIn.close();

					try {
						// Well, wait for Dinero to terminate
						dinero.waitFor();
					}
					catch (InterruptedException ie) {
						ie.printStackTrace();
					}
					if(edumips64.Main.isWindows())
					    th.finish = true;	
					else
					{
					    boolean found = false;

					    // Let's get the results
					    if(stdOut.ready())
						while ((s = stdOut.readLine()) != null) {
						    if(s.equals("---Simulation complete."))
							found = true;
						    if(found)
							result.append(s + "\n");
						}
					    if(stdErr.ready())
						while ((s = stdErr.readLine()) != null) {
						    result.append(">> Dinero error: " + s + "\n");
						}
					}

				}
				catch (java.io.IOException ioe) {
					result.append(">> ERROR: " + ioe);
				}
			}
		});

		Box dineroEx = Box.createHorizontalBox();
		dineroEx.add(Box.createHorizontalGlue());
		dineroEx.add(pathLabel);
		dineroEx.add(Box.createRigidArea(hSpace));
		dineroEx.add(path);
		dineroEx.add(Box.createRigidArea(hSpace));
		dineroEx.add(browse);
		cp.add(dineroEx);
		cp.add(Box.createRigidArea(vSpace));

		Box cmdLine = Box.createHorizontalBox();
		cmdLine.add(Box.createHorizontalGlue());
		cmdLine.add(paramsLabel);
		cmdLine.add(Box.createRigidArea(hSpace));
		cmdLine.add(params);
		cmdLine.add(Box.createRigidArea(hSpace));
		cp.add(cmdLine);
		cp.add(Box.createRigidArea(vSpace));
		
		Box cacheCreate = Box.createHorizontalBox();
		cacheCreate.add(Box.createHorizontalGlue());
		cacheCreate.add(cacheLeveLabel);
		cacheCreate.add(Box.createRigidArea(hSpace));
		cacheCreate.add(cacheLevel);
		cacheCreate.add(Box.createRigidArea(hSpace));
		cacheCreate.add(cacheTypeLabel);
		cacheCreate.add(Box.createRigidArea(hSpace));
		cacheCreate.add(cacheType);
		cacheCreate.add(Box.createRigidArea(hSpace));
		cacheCreate.add(create);
		cp.add(cacheCreate);
		cp.add(Box.createRigidArea(vSpace));

		//Box created for adding Cache Panel components
		cachePanel = Box.createVerticalBox();
		cachePanel.add(panelL1 = new DineroSingleCachePanel(argType, 1));
		cp.add(cachePanel);
		cp.add(Box.createRigidArea(vSpace));
		
		result = new JTextArea();
		result.setBorder(BorderFactory.createTitledBorder("Messages"));
		result.setEditable(false);
		result.setFont(new Font("Monospaced", Font.PLAIN, 12));

		cp.add(configure);
		cp.add(Box.createRigidArea(vSpace));
		cp.add(execute);
		cp.add(Box.createRigidArea(vSpace));
		cp.add(new JScrollPane(result));
		
		//Vertical and horizontal scroll added to the Frame container
		scrollPane = new JScrollPane(cp, JScrollPane.VERTICAL_SCROLLBAR_AS_NEEDED, JScrollPane.HORIZONTAL_SCROLLBAR_AS_NEEDED);
		setContentPane(scrollPane);

		//Resized the frame container to have better UX with the new panels
		setSize(900, 800);
	}

	public static void main(String[] args) {
		JDialog f = new DineroFrontend(null);
		f.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		f.setVisible(true);
	}
}


/** Panel with all the necessary controls to modify the options of a Cache.
 */
class DineroSingleCachePanel extends JPanel {
	private DineroCacheOptions dco;
	private JComboBox size, sizeUnit, bsize, bsizeUnit, level, type;
	private JTextField assoc;
	private JCheckBox ccc;
	private JLabel cacheSizeLabel, cacheSizeUnitLabel, blockSizeLabel, bsizeUnitLabel, assocLabel, cccLabel;

	public DineroSingleCachePanel(char type, int level) {
		dco = new DineroCacheOptions(type, level);

		String[] sizes = {"1", "2", "4", "8", "16", "32", "64", "128", "256", "512"};
		String[] units = {" ", "k", "M", "G"};

		size = new JComboBox(sizes);
		bsize = new JComboBox(sizes);

		sizeUnit = new JComboBox(units);
		bsizeUnit = new JComboBox(units);

		assoc = new JTextField();
		ccc = new JCheckBox();

		cacheSizeLabel = new JLabel("Cache size");
		cacheSizeUnitLabel = new JLabel("Unit (Byte)");
		blockSizeLabel = new JLabel("Block size");
		bsizeUnitLabel = new JLabel("Unit (Byte)");
		assocLabel = new JLabel("N way set associative");
		cccLabel = new JLabel("CCC Enable");

		size.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e){
				//dco.size = String.valueOf(sizeUnit.getSelectedItem());
				sizeUnit.setSelectedIndex(0);
			}
		});
		size.setSelectedIndex(0);

		bsize.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e){
				//dco.bsize = String.valueOf(bsize.getSelectedItem());
				bsizeUnit.setSelectedItem(0);
			}
		});
		bsize.setSelectedIndex(0);
		
		sizeUnit.addActionListener(new ActionListener(){
			public void actionPerformed(ActionEvent e) {
				String sizeMsg = String.valueOf(size.getSelectedItem());
				dco.size = sizeMsg + String.valueOf(sizeUnit.getSelectedItem());
			}
		});
		sizeUnit.setSelectedIndex(0);

		bsizeUnit.addActionListener(new ActionListener(){
			public void actionPerformed(ActionEvent e){
				String bsizeMsg = String.valueOf(bsize.getSelectedItem());
				dco.bsize = bsizeMsg + String.valueOf(bsizeUnit.getSelectedItem());
			}
		});
		bsizeUnit.setSelectedIndex(0);

		//adding components to panel layout
		setBorder(BorderFactory.createTitledBorder("Level " + level + " cache (" + type + ")"));
		setLayout(new GridLayout(2, 6, 1, 1));
		add(cacheSizeLabel);
		add(cacheSizeUnitLabel);
		add(blockSizeLabel);
		add(bsizeUnitLabel);
		add(assocLabel);
		add(cccLabel);
		add(size);
		add(sizeUnit);
		add(bsize);
		add(bsizeUnit);
		add(assoc);
		add(ccc);

		//Default dimension set for panel
		setPreferredSize(new Dimension(850, 80));
		setMaximumSize(new Dimension(850, 90));
		setMinimumSize(new Dimension(850, 50));
	}

	//Passes Dinero command parameters with proper syntax
	public String toString(){
		ccc.addItemListener(new ItemListener(){
			public void itemStateChanged(ItemEvent e) {
				Boolean cccFlag =  ccc.isSelected();
				dco.ccc = cccFlag;
			}
		});

		//Implements try and catch method to only allow numerical value only
		try{
			dco.assoc = Integer.parseInt(assoc.getText());
		}
		catch(NumberFormatException exception){
			dco.assoc = 0;
		}

		return dco.toString();
	}
}

/** Class holding the config options for a Cache.
 *  Its attributes are public because this class has package visibility, and so 
 *  it's used only by the DineroFrontend and the DineroCachePanel classes.
 */
class DineroCacheOptions {
	public String size, bsize;
	public int assoc = 0;
	public boolean ccc = false;
	
	private char type;
	private int level;
	
	public DineroCacheOptions(char type, int level) {
		this.type = type;
		this.level = level;
	}
	
	public String toString() {
		String prefix = "-l" + level + "-" + type;
		String cmdline = prefix + "size" + " " + size + " ";
		cmdline += prefix + "bsize" + " " + bsize + " ";

		if(assoc > 0)
			cmdline += prefix + "assoc" + " " + assoc + " ";
		if(ccc)
			cmdline += prefix + "ccc" + " ";

		return cmdline;
	}
}
