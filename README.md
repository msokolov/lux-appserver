Application server for Lux; (see also main Lux project at 
https://github.com/msokolov/lux for documentation)

Build (after building and installing lux):

mvn package
mvn dependency:copy-dependencies
mvn assembly:single

Run with ./lux or ./lux.bat.

Configure by editing lux.properties; documentation is inline in the file.


