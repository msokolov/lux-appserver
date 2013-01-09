package lux.appserver;

import java.util.HashMap;
import java.util.Map;
import java.util.Map.Entry;

import javax.servlet.http.HttpServletRequest;

/**
 * Rewrites the url from ${servlet-path}/${path} to ${forward-path}; 
 * translates the url path to a resource path: ${application-root}/${path}
 * Adds parameters to the request:
 * lux.xquery = ${resource-path}
 * lux.httpinfo has the request encapsulated as an XML document
 */
class XQueryRequest extends TranslatedRequest {
    
    private final Map<String,String[]> parameterMap;
    private final String forwardPath;
    
    @SuppressWarnings("unchecked")
    public XQueryRequest(final HttpServletRequest request, final String servletPath, final String forwardPath, final String applicationRoot) {
        super(request, servletPath, forwardPath, applicationRoot);
        this.forwardPath = forwardPath;
        this.parameterMap = new HashMap<String,String[]> (request.getParameterMap());
        parameterMap.put(AppForwarder.LUX_XQUERY, new String[] {getPathTranslated()});
        parameterMap.put(AppForwarder.LUX_HTTPINFO, new String[] {buildHttpInfo(request)});
    }
    
    @Override
    public String getRequestURI() {
        return forwardPath;
    }
    
    /**
     * @return "" so SolrDispatchFilter won't include this as part of the "handler" name
     */
    @Override
    public String getPathInfo () {
        return "";
    }
    
    @Override 
    public String getParameter (String name) {
        return parameterMap.get(name)[0];
    }
    
    @Override 
    public String[] getParameterValues (String name) {
        return parameterMap.get(name);
    }
    
    @Override
    public Map<String,String[]> getParameterMap () {
        return parameterMap;
    }

    // This may be a bit fragile - I worry we'll have serialization bugs -
    // but the only alternative I can see is to provide a special xquery function
    // and pass the map into the Saxon Evaluator object - but we can't get that
    // from here, and it would be thread-unsafe anyway, which is bad for a server
    private String buildHttpInfo(HttpServletRequest req) {
        StringBuilder buf = new StringBuilder();
        buf.append (String.format("<http method=\"%s\" uri=\"%s\">", req.getMethod(), xmlEscape(req.getRequestURI())));
        buf.append ("<params>");
        for (Object o : req.getParameterMap().entrySet()) {
            @SuppressWarnings("unchecked")
            Map.Entry<String, String[]> p = (Entry<String, String[]>) o;
            buf.append(String.format("<param name=\"%s\">", p.getKey()));
            for (String value : p.getValue()) {
                buf.append(String.format ("<value>%s</value>", xmlEscape(value)));
            }
            buf.append("</param>");
        }
        buf.append ("</params>");
        int tail = req.getRequestURI().indexOf(".xqy");
        String pathExtra = req.getRequestURI().substring(tail + 4);
        buf.append("<path-extra>").append(xmlEscape(pathExtra)).append("</path-extra>");
        // TODO: headers, path, etc?
        buf.append ("</http>");
        return buf.toString();
    }
    
    private Object xmlEscape(String value) {
        return value.replaceAll("&", "&amp;").replaceAll("<", "&lt;").replaceAll("\"", "&quot;");
    }
}