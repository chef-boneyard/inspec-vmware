# InSpec VMware

This repository contains a collection of InSpec resources used to interact with the VMware platform.

## Using the VMware Target

### Via Arguments
```
inspec exec inspec-powercli -t vmware://USERNAME@VISERVER --password MY_PASSWORD
```

### Via Environment Variables
```
export VISERVER=10.0.0.10
export VISERVER_USERNAME=demouser
export VISERVER_PASSWORD=s0m3t1ngs3cuRe
inspec exec inspec-powercli -t vmware://
```

### Via the InSpec Shell

```
inspec shell -t vmware://USERNAME@VISERVER --password MY_PASSWORD --depends ./inspec-powercli
```

## Pre-Requisites

### Windows 2012R2

#### Install PowerCLI
```
Invoke-WebRequest -Uri "https://download.microsoft.com/download/C/4/1/C41378D4-7F41-4BBE-9D0D-0E4F98585C61/PackageManagement_x64.msi" -OutFile PackageManagement.msi
msiexec.exe /i C:\Users\vagrant\PackageManagement.msi /quiet
Set-PSRepository -Name "PSGallery" -InstallationPolicy "Trusted"
Install-Module -Name VMware.PowerCLI
```

### Linux

#### Install PowerCLI

See: http://jjasghar.github.io/blog/2018/03/22/powercli-10+-on-linux/

## License

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
