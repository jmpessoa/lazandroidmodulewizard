{Hint: save all files to location: C:\adt32\eclipse\workspace\AppTCPClientDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls, 
    Laz_And_Controls_Events, AndroidWidget, tcpsocketclient;

type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jButton1: jButton;
    jButton2: jButton;
    jButton3: jButton;
    jEditText1: jEditText;
    jEditText2: jEditText;
    jTCPSocketClient1: jTCPSocketClient;
    jTextView1: jTextView;
    jTextView2: jTextView;
    jTextView3: jTextView;
    procedure AndroidModule1JNIPrompt(Sender: TObject);
    procedure jButton1Click(Sender: TObject);
    procedure jButton2Click(Sender: TObject);
    procedure jButton3Click(Sender: TObject);
    procedure jTCPSocketClient1Connected(Sender: TObject);
    procedure jTCPSocketClient1MessagesReceived(Sender: TObject; messagesReceived: array of string);

  private
    {private declarations}
      FConnected: boolean;
  public
    {public declarations}
  end;

var
  AndroidModule1: TAndroidModule1;

implementation

{$R *.lfm}

{ TAndroidModule1 }

procedure TAndroidModule1.jButton1Click(Sender: TObject);
begin
  jEditText2.Clear;

  //how to get IP? [windows] go to console cmd: >ipconfig
  //how to get Port? Look in your app socker server [test code below]!

  jTCPSocketClient1.ConnectAsync('192.168.0.105', 54321); //IP Server/Port

end;

procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
begin
  FConnected:= False;
  jEditText1.Clear;
  jEditText2.Clear;
  jEditText1.SetFocus;
  if not Self.IsWifiEnabled() then Self.SetWifiEnabled(True);
end;

procedure TAndroidModule1.jButton2Click(Sender: TObject);
begin
   if  FConnected then
      jTCPSocketClient1.SendMessage(jEditText1.Text);

end;

procedure TAndroidModule1.jButton3Click(Sender: TObject);
begin
   if  FConnected then
     jTCPSocketClient1.CloseConnection('goodbye');
end;

procedure TAndroidModule1.jTCPSocketClient1Connected(Sender: TObject);
begin
   ShowMessage('Connected ...');
   FConnected:= True;
end;

procedure TAndroidModule1.jTCPSocketClient1MessagesReceived(Sender: TObject; messagesReceived: array of string);
var
  len, i: integer;
begin
  len:= Length(messagesReceived);
  for i:= 0 to len-1 do
  begin
    jEditText2.AppendLn(messagesReceived[i]);
  end;
end;

end.

(*-----------------------------------------------------------

// JUST FOR TEST: SIMPLE JAVA SERVER SOCKET !!! Thanks to Sean R. Owens!

//*	save as SimpleServer.java		*
//*	compile: javac SimpleServer.java	*
//*	run: java SimpleServer			*

// Written by Sean R. Owens, sean at guild dot net, released to the
// public domain.  Share and enjoy.  Since some people argue that it is
// impossible to release software to the public domain, you are also free
// to use this code under any version of the GPL, LPGL, or BSD licenses,
// or contact me for use of another license.
// http://darksleep.com/player
//http://www.darksleep.com/player/SocketExample/

import java.net.Socket;
import java.net.ServerSocket;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.IOException;

public class SimpleServer {
    private int serverPort = 0;
    private ServerSocket serverSock = null;
    private Socket sock = null;

    public SimpleServer(int serverPort) throws IOException {
        this.serverPort = serverPort;

        serverSock = new ServerSocket(serverPort);
    }

    public void waitForConnections() {
        while (true) {
            try {
                sock = serverSock.accept();
                System.err.println("SimpleServer:Accepted new socket, creating new handler for it.");
                SimpleHandler handler = new SimpleHandler(sock);
                handler.start();
                //System.err.println("SimpleServer:Finished with socket, waiting for next connection.");
            }
            catch (IOException e){
                e.printStackTrace(System.err);
            }
        }
    }

    public static void main(String argv[]) {
        int port = 54321;
        SimpleServer server = null;
        try {
            server = new SimpleServer(port);
        }
        catch (IOException e){
            e.printStackTrace(System.err);
        }

        System.out.println("SimpleServer running ....");
        server.waitForConnections();
    }
}

class SimpleHandler implements Runnable {
    private Socket sock = null;
    private InputStream sockInput = null;
    private OutputStream sockOutput = null;
    private Thread myThread = null;

    public SimpleHandler(Socket sock) throws IOException {
        this.sock = sock;
        sockInput = sock.getInputStream();
        sockOutput = sock.getOutputStream();
        this.myThread = new Thread(this);
        // Note that if we call myThread.start() now, we run the risk
        // of this new thread calling run before we're finished
        // constructing.  We can't count on the fact that we call
        // .start() last - javac or the jvm might have reordered the
        // above lines.  The class constructing us must wait for the
        // constructor to return and then call start() on us.
        System.out.println("SimpleHandler: New handler created.");
    }

    public void start() {
        myThread.start();
    }

    // All this method does is wait for some bytes from the
    // connection, read them, then write them back again, until the
    // socket is closed from the other side.
    public void run() {
        System.out.println("SimpleHandler: Handler run() starting.");
        while(true) {
            byte[] buf=new byte[1024];
            int bytes_read = 0;
            try {
                // This call to read() will wait forever, until the
                // program on the other side either sends some data,
                // or closes the socket.
                bytes_read = sockInput.read(buf, 0, buf.length);
                if(bytes_read < 0) {
                    System.err.println("SimpleHandler: Tried to read from socket, read() returned < 0,  Closing socket.");
                    break;
                }
                System.err.println("SimpleHandler: Received "+bytes_read
                                   +" bytes, sending them back to client, data="
                                   +(new String(buf, 0, bytes_read)));
                sockOutput.write(buf, 0, bytes_read);
                // This call to flush() is optional - we're saying go
                // ahead and send the data now instead of buffering
                // it.
                sockOutput.flush();
            }
            catch (Exception e){
                e.printStackTrace(System.err);
                break;
            }
        }

        try {
            System.err.println("SimpleHandler:Closing socket.");
            sock.close();
        }
        catch (Exception e){
            System.err.println("SimpleHandler: Exception while closing socket, e="+e);
            e.printStackTrace(System.err);
        }

    }
}
---------------------------------*)
