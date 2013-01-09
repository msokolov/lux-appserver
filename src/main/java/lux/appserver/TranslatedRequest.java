package lux.appserver;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletRequestWrapper;

/**
 * translates URLs into file paths
 */
class TranslatedRequest extends HttpServletRequestWrapper {
    
    /**
     * 
     */
    private final String pathTranslated;
    private final String pathInfo;
    private final String servletPath;
    
    public TranslatedRequest(HttpServletRequest request, final String servletPath, final String forwardPath, final String applicationRoot) {
        super(request);
        this.servletPath = servletPath;
        final int head = servletPath.length();
        String requestURI = request.getRequestURI();
        pathInfo = requestURI.substring(head);
        int tail = requestURI.indexOf(".xqy");
        if (tail > 0) {
            pathTranslated = addPaths (applicationRoot, requestURI.substring(head, tail + (".xqy".length())));
        } else {
            pathTranslated = addPaths (applicationRoot, requestURI.substring(head));
        }
    }
    
    @Override
    public String getServletPath() {
        return servletPath;
    }
    
    @Override
    public String getPathInfo () {
        return pathInfo;
    }
    
    @Override
    public String getPathTranslated () {
        return pathTranslated;
    }
    
    private String addPaths (String base, String path) {
        if (base.endsWith("/")) {
            if (path.startsWith("/")) {
                return new StringBuilder(base).append(path, 1, path.length()).toString();
            }
            return base + path;
        }
        if (path.startsWith("/")) {
            return base + path;
        }
        return base + '/' + path;
    }

}