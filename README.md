# ABOUT

AdServerBeans is a web application with MySQL backend, Java middle tier and Flex (Flash) frontend.

Its purpose was to serve banner ads based on different targeting settings. 

The project was written when Adobe Flash player was popular. Right now this project can be used for educational purposes.
Feel free to pull the source code, build the project and run it. 

Personally 10 years later I can't find Flex SDK 3.5 anywhere on the Internet.

# INSTALLATION

Required:

JDK 1.6+

ant (any, really)

Flex 3.5

cp sample.build.properties build.properties
vim build.properties

Set path to FLEX_HOME to the location of your Flex SDK.

Run ant:
ant

Created myads.war can be renamed to any.war and deployed on Tomcat (any?).
Installation manager will be displayed on first run to help you connect to the database and create tables.

You also need to set up MySQL. See scripts in db.