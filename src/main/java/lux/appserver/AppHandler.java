package lux.appserver;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.mortbay.jetty.servlet.ServletHandler;

public class AppHandler extends ServletHandler {
    
    public void handle(String target, HttpServletRequest request, HttpServletResponse response, int dispatch) throws IOException, ServletException
    {
        if (request.getRequestURI().matches(".*\\.xq.*")) {
            getServlet (AppServer.LUX_APP_FORWARDER).handle(request, response);
        } else {
            getServlet (AppServer.DEFAULT).handle(request, response);
        }
    }
}
