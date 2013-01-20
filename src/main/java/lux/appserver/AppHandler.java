package lux.appserver;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.eclipse.jetty.server.Request;
import org.eclipse.jetty.servlet.ServletHandler;
import org.eclipse.jetty.webapp.WebAppContext;

public class AppHandler extends ServletHandler {
    
    private WebAppContext solrWebapp;
    
    @Override
    public void doHandle(String target, Request baseRequest, HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException
    {
        String requestURI = request.getRequestURI();
        if (requestURI.startsWith("/solr")) {
            solrWebapp.doHandle(target, baseRequest, request, response);
        }
        else if (requestURI.matches(".*\\.xq.*")) {
            getServlet (AppServer.LUX_APP_FORWARDER).handle(baseRequest, request, response);
        } else {
            getServlet (AppServer.DEFAULT).handle(baseRequest, request, response);
        }
        baseRequest.setHandled(true);
    }
    
    @Override
    public void doScope(String target, Request baseRequest, HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException
    {
        String requestURI = request.getRequestURI();
        if (requestURI.startsWith ("/solr")) {
            super.doScope(target, baseRequest, request, response);
        } else {
            // bypass the normal processing of filter and servlet matches
            doHandle (target, baseRequest, request, response);
        }
    }

    public WebAppContext getSolrWebapp() {
        return solrWebapp;
    }

    public void setSolrWebapp(WebAppContext solrWebapp) {
        this.solrWebapp = solrWebapp;
    }

}
