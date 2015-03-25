#!/bin/sh
# Copyright (c) 2015 by RightScale Inc., all rights reserved worldwide

www_dir="/var/www/html"
html5site_pkg="html5website.zip"
tmp_index_file="/tmp/tmp_index.html"

# Install necessary packages based on OS
unzip_package="unzip"
os_check=`uname -a | grep -i ubuntu`
if [ $? -eq 0 ]
then
  # We're on an ubuntu server
  webservice="apache2"
  apt-get install -y ${webservice} ${unzip_package}
else
  # We'll assume we're on centos/redhat, etc
  webservice="httpd"
  yum install -y ${webservice} ${unzip_package}
fi

# Drop in the HTML5 application package (attached to the rightscript)
cp $ATTACH_DIR/${html5site_pkg} ${www_dir}
unzip -o -d ${www_dir} ${www_dir}/${html5site_pkg}

echo ">>> Installed apache and HTML5 website"

# Now modify the text in the website to use the user-provided text and the server's IP address
# The HTML5 website index.html has two keywords in it:
# - HELLO_WORLD_TEXT_GOES_HERE: which is replaced with the user's text
# - SERVER_IP_ADDRESS_GOES_HERE: which is replaced with the server's IP address.

sed "s/HELLO_WORLD_TEXT_GOES_HERE/$WEBTEXT/g" ${www_dir}/index.html > ${tmp_index_file}
sed "s/SERVER_IP_ADDRESS_GOES_HERE/$MYIPADDRESS/g" ${tmp_index_file} > ${www_dir}/index.html

echo ">>> Updated website with personal greeting and server IP address"

service ${webservice} start

echo ">>> Started ${webservice}"