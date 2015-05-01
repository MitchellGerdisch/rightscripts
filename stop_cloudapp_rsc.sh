#!/bin/bash -e

# RightScript: Stops a Self-Service Cloud Application using the RSC command line tool.
#
# Dependencies: RSC is installed and path added to $PATH. See install_rsc.sh script.
#
# Description: Stops the Self-Service Cloud Application in which this server exists.
# Uses the RSC command line API tool to stop the Cloud Application in which this server exits.
# The use-case is I have an alert set up to stop a server if some metric is triggered (e.g. low cpu utilization).
# This way I don't spend money running a VM when the developer has decided to stop using the server for a while.
#
# RIGHTSCRIPT SETUP NOTES:
# When creating a rightscript with the contents of this file, set up the INPUTs as follows:
#   $RS_SERVER - uncheck the enabled box since it's not modifiable by user
#   $RSDEPLOYMENT - default to RS_DEPLOYMENT_NAME
#   $API_CREDENTIAL - default to a credential called API_CREDENTIAL that contains an OAUTH token. 
#
# Author: Mitch Gerdisch <mitchell.gerdisch@rightscale.com>

# Copyright (c) 2007-2008 by RightScale Inc., all rights reserved worldwide

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Gather up information from the RightScale environment variables
rsHostShard=`echo $RS_SERVER | cut -d"." -f1`
rsHost=$RS_SERVER
deploymentName=$RSDEPLOYMENT 
rsAccount=$RS_ACCOUNT
# CAN'T USE INSTANCE TOKEN SINCE IT DOESN'T HAVE NECESSARY PERMS: 
# apiKey=`echo ${RS_API_TOKEN} | cut -d":" -f2` 
# apiCmd="rsc --apiToken=${apiKey} -h ${rsHost} -a ${rsAccount}"
# So, use a credential set up a priori containing a useful OAUTH token
apiKey=$API_CREDENTIAL 
apiCmd="rsc --key=${apiKey} -h ${rsHost} -a ${rsAccount}"

#echo "apiCmd: ${apiCmd}"

# Find the deployment href so that we can then find the tag that contains the cloud application template execution ID
deploymentHref=`${apiCmd} --x1 'object:has(.rel:val("self")).href' cm15 index /api/deployments "filter[]=name==${deploymentName}"`

# Get the Self Service execution ID - which is tucked into one of the tags of the deployment
ssExecHref=`${apiCmd} --xm '.tags .name' cm15 by_resource /api/tags/by_resource "resource_hrefs[]=${deploymentHref}" | 
sed 's/"//g' |
grep 'selfservice:href' | 
cut -d"=" -f2`

#echo "deploymentHref: $deploymentHref"
#echo "ssExecHref: $ssExecHref"

# Stop my cloud app
${apiCmd} ss stop ${ssExecHref}