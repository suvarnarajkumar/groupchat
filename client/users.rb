require 'java'
include Java
require "socket"

import java.awt.FlowLayout
import java.awt.GridLayout
import java.awt.BorderLayout
import java.awt.Color
import java.awt.Frame
java_import 'java.awt.event.ActionListener'
java_import 'java.awt.event.WindowListener'
import javax.swing.JFrame
import javax.swing.JButton
import javax.swing.JPanel
import javax.swing.JToolBar
import javax.swing.JFileChooser
import javax.swing.JTextArea
import javax.swing.JTextPane
import javax.swing.JScrollPane
import javax.swing.BorderFactory
import javax.swing.JTextField
import javax.swing.JLabel

 class MainWindow < JFrame
   include WindowListener
   include ActionListener
 
   def initialize
   super 
     @server=nil
        @does=0
        @response = nil
        self.initUI
        system("exit")
        listen(self)
		add_window_listener self
		@response.join	
     add_window_listener self
     pack
   end
 
 
 def clients(server,frame)
    @server = server
    @name=""
    @count=1
    
    send
    
    end
    
    def listen(frame)
    @response = Thread.new do
      loop {
      if @does==1
	
	frame.toFront			
        msg = @server.gets.chomp
        if msg=="un_exist"
        frame.setContentPane(@panel_front)   
	    @panel_front.revalidate()
	    @wlabel.text="Exists re-enter username"
	    @name=@input.text
		@input.text=""
        @server.puts( @name )
        @does=0
		else
		frame.setAlwaysOnTop true
		frame.setContentPane(@panel_back)   
	    @panel_back.revalidate()
		s=msg.split(':')
        if s[0]==@name.upcase
			str=s[1]
			i=2
			while i<s.length
				str+=": #{s[i]}"
				i+=1
			end
			@area.text= @area.text+"#{'ME:'}#{str}\n"
		else
			@area.text= @area.text+"#{s[0]}:#{s[1]}\n"
		end
			frame.setState JFrame::NORMAL 
			frame.toFront
			frame.requestFocus
		end
		
	  end
      }
    end
  end
 
  def send
       
    if @count==1
        @name=@input.text
		@input.text=""
        @count=0
        @server.puts( @name )
        @does=1
    end
  end 
   	def initUI
      
        @panel_front = JPanel.new
        @panel_front.setBorder BorderFactory.createEmptyBorder 10, 10, 10, 10
        @panel_back = JPanel.new
        @panel_back.setLayout BorderLayout.new

        toolbar = JToolBar.new
        toolbar.setFloatable(false)
        toolbar_user = JToolBar.new
        toolbar_user.setFloatable(false)
        rgb=Color.new(238, 238, 238)
        toolbar_user.setBackground(rgb)
        toolbar_user.setBorder BorderFactory.createEmptyBorder 150, 100, 150, 100
        @sendb = JButton.new "send"
        exitb = JButton.new "exit"
        jlabel = JLabel.new 'Enter Username:'	
        @wlabel = JLabel.new ''
        @wlabel.setForeground(Color.red)
        @area = JTextArea.new
        @data = JTextArea.new
        @area.setEditable(false)
        @area.setBorder BorderFactory.createEmptyBorder 10, 10, 10, 10
		@data.setBorder BorderFactory.createEmptyBorder 10, 10, 10, 10	
		toolbar.add @data
		toolbar.add @sendb
		toolbar.add exitb
		
		@input = JTextField.new(10)
		button = JButton.new("Ok") 
		buttone = JButton.new "exit"
		toolbar_user.add jlabel 
		toolbar_user.add @input
		toolbar_user.add @wlabel
		toolbar_user.add button
		toolbar_user.add buttone
        pane = JScrollPane.new
        pane.getViewport.add @area
		@panel_front.setBorder BorderFactory.createEmptyBorder 10, 10, 10, 10
		@panel_front.add toolbar_user
        @panel_back.setBorder BorderFactory.createEmptyBorder 10, 10, 10, 10
        @panel_back.add pane
        @sendb.addActionListener do |e|
			@server.puts( @data.text )
            @data.text=""
        end
        
        exitb.addActionListener do |e|
		   @server.puts("exit")
           java.lang.System.exit(0)
         
        end
        buttone.addActionListener do |e|
           java.lang.System.exit(0)
         
        end
        @panel_back.add toolbar, BorderLayout::NORTH    
        self.setContentPane(@panel_front)   
	    @panel_front.revalidate()  
	    
	    
	    button.addActionListener do |e|    
	    if @input.text.length>0
	    check=0 
	    begin 
        server = TCPSocket.open( "10.90.90.146", 5555)
		rescue
		@wlabel.text="Server not connected"
		check=1
		end
		if check==0
		clients(server,self)
        end
        else
			@wlabel.text="Enter UserName"
		end
        end
        
       	
        self.setDefaultCloseOperation JFrame::DO_NOTHING_ON_CLOSE
	    self.setSize 450, 400
        self.setLocationRelativeTo nil
        self.setVisible true
    end
  
   
   
   
   
   def windowActivated(event)
	
    end
  def windowDeactivated(event)
		self.setAlwaysOnTop false
  end
  def windowDeiconified(event); end
   def windowIconified(event); end
   def windowOpened(event); end
 
   def windowClosing(event)
		   self.setState JFrame::ICONIFIED
   end
 end
 
 MainWindow.new.set_visible(true)
