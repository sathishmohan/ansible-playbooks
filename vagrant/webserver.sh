#!/bin/bash
# THIS SCRIPT IS USED TO INSTALL AND CONFIGURE APACHE2 


# START OF THE SCRIPT
echo "-- ------------------------------"
echo "-- BEGIN SETUP FOR ${HOSTNAME} --"
echo "-- ------------------------------"
 
# ASSIGNING VARIABLES FOR APACHE CONFIG
echo "-- Settingup global variables --"
APACHE_CONFIG=/etc/apache2/apache2.conf
LOCALHOST=localhost
 
# BEGIN OF APACHE SETUP
echo "-- Updating packages --"
apt-get update -y -qq

echo "-- Installing Apache web server --"
apt-get install -y apache2 > /dev/null 2>&1
 
echo "-- Adding ServerName to Apache config --"
echo "ServerName ${LOCALHOST}" >> "${APACHE_CONFIG}"

echo "-- Restarting Apache web server --"
service apache2 restart
 
# CREATING HTML FILE
echo "-- Creating a dummy index.html file --"
cat > /var/www/html/index.html <<EOD
<html>
<head>
<title>${HOSTNAME}</title>
</head>
<body>
<h1>${HOSTNAME}</h1>
<p>YAY! YOU ARE ABLE TO ACCESS ME! GOOD LUCK!</p>
</body>
</html>
EOD
 
echo "--------------------------------- "
echo "-- END OF SETUP FOR ${HOSTNAME} --"
echo "--------------------------------- "
