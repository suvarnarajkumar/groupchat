a=`kill -9 $(lsof -i tcp:5555 -t)`

require "socket"
class Server
  def initialize( port, ip )
   @server = TCPServer.open( ip, port )
    @connections = Hash.new
    @rooms = Hash.new
    @clients = Hash.new
    @connections[:server] = @server
    @connections[:rooms] = @rooms
    @connections[:clients] = @clients
    run
  end

 
  def run
    loop {
			
            Thread.start(@server.accept) do | client |
			 nick_name = client.gets.chomp.to_sym
			 @connections[:clients].each do |other_name, other_client|
               if nick_name == other_name || client == other_client
                 client.puts "un_exist"
                 Thread.kill self
               end
               end
               
            puts "#{nick_name} #{client}"
            @connections[:clients][nick_name] = client
            client.puts "connection successfull..........."
            listen_user_messages( nick_name, client )
            end
		 }.join
  end


  
 
  def listen_user_messages( username, client )
    loop {
		count=0
		msg = client.gets.chomp
        @connections[:clients].each do |other_name, other_client|
			if msg== "exit"
				unless other_name==username
					begin
					other_client.puts "#{username.to_s.upcase}: <LOGGED OUT>"
					rescue
					end
				end
				count=1
			else	
				begin
					if msg =~/^<LOGGED OUT> *$/					
					other_client.puts "#{username.to_s.upcase}: He is typing->#{msg}"
					elsif msg.length<1
					else
					other_client.puts "#{username.to_s.upcase}: #{msg}"
					end
				rescue
				end
			end	
      end
      if count==1
			puts "#{username} terminated"
			@connections[:clients].delete(username)
			Thread.kill self
	  end
    }
  end
end

Server.new( 5555, "10.90.90.146" )
