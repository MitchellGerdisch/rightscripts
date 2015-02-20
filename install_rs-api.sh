#!/bin/bash -e

# RightScript: Install rs-api tool.
#
# Description: Installs rs-api tool.
# This is an all-in-one api tool that makes for a good api tool in RL10-enabled servers.
# Run rs-api --help to learn more.
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

installdir=$HOME/bin
mkdir -p ${installdir}

cd /tmp

curl https://rightscale-binaries.s3.amazonaws.com/rsbin/rs-api/master/rs-api-linux-amd64.tgz | tar zxf -

cp /tmp/rs-api/rs-api ${installdir}

PATH+=":$installdir"

