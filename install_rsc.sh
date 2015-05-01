#!/bin/bash -e

# RightScript: Install rsc command line API tool.
#
# Description: Installs rsc tool.
# This is an all-in-one api tool that makes for a good api tool in RL10-enabled servers.
# See https://github.com/rightscale/rsc for more information.
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

installDir="/usr/bin"
# ONLY SUPPORTS LINUX AT THIS TIME. See https://github.com/rightscale/rsc for other binaries
rscBinariesLocation="https://binaries.rightscale.com/rsbin/rsc/v1/rsc-linux-amd64.tgz"

if [ ! -d $installDir ] ; then
  mkdir -p ${installDir}
else
  echo "rsc install directory $installDir already exists. Skipping directory creation..."
fi

cd ${installDir}

if [ ! -f $installDir/rsc ]; then
  curl --silent ${rscBinariesLocation} |
  tar -zxf - -O rsc/rsc > rsc
  chmod +x ./rsc
else
  echo "rsc already installed at $installDir. Skipping installation..."
fi

if [ ! -z `echo PATH|grep $installDir` ]; then
  PATH+=":${installDir}"
else
  echo "rsc install directory is already in PATH. Skipping PATH update..."
fi

