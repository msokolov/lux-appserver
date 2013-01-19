If lux.solr.url is local, add a solr context in AppServer() with that as its path

For now, still use proxying to access that?  Maybe later figure out how to shortcut that internally in jetty

How to bring in the solr war for the context?  We need a lux war, in fact.  So lux needs to build both war and jar.

