package lux.appserver;

import org.mortbay.jetty.Server;
import org.mortbay.jetty.servlet.Context;
import org.mortbay.jetty.servlet.DefaultServlet;
import org.mortbay.jetty.servlet.ServletHolder;

public class AppServer {
    
    public static final String DEFAULT = "default";
    public static final String LUX_APP_FORWARDER = "lux.app-forwarder";

    public static void main (String ... argv) throws Exception {
        // TODO: [-p {port}] [-c {context}] [-s http://{solr-host}:{solr-port}/{forward-path}] [-r {resource-base}]
        Server server = new Server(8080);
        
        AppHandler handler = new AppHandler();
        
        AppForwarder xqueryForward = new AppForwarder();
        ServletHolder appForwarderHolder = new ServletHolder(xqueryForward);
        appForwarderHolder.setName(LUX_APP_FORWARDER);
        handler.addServlet(appForwarderHolder);
        
        DefaultServlet resources = new DefaultServlet();
        ServletHolder resourcesHolder = new ServletHolder(resources);
        resourcesHolder.setInitParameter("resourceBase", "src/main/webapp");
        resourcesHolder.setName(DEFAULT);
        handler.addServlet(resourcesHolder);
        
        Context root = new Context (server, "/", Context.NO_SESSIONS & Context.NO_SECURITY);
        root.setServletHandler(handler);
        
        server.start();
    }
    
}
