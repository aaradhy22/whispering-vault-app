FROM tomcat:9.0-jdk11

# Remove the default ROOT webapp from Tomcat
RUN rm -rf /usr/local/tomcat/webapps/ROOT

# Copy your .war file as ROOT.war into Tomcat webapps folder
COPY WhisperingVault.war /usr/local/tomcat/webapps/ROOT.war

# Expose the port Tomcat runs on
EXPOSE 8080

# Start Tomcat server
CMD ["catalina.sh", "run"]
