# escape=`


FROM mcr.microsoft.com/dotnet/framework/sdk:4.8
LABEL maintainer="edgar0103sanchez@yahoo.com"

ADD .\msis\*.msi C:\msis\
ADD .\exes\*.exe C:\exes\
WORKDIR C:\

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

RUN Write-Host 'Installing node.js v12.2.0-x64' ; `
    Start-Process msiexec.exe -ArgumentList '/i', C:\msis\node-v12.2.0-x64.msi, '/quiet', '/norestart' -NoNewWindow -Wait

RUN Write-Host 'Installing yarn v1.16.0' ; `
    Start-Process msiexec.exe -ArgumentList '/i', C:\msis\yarn-1.16.0.msi, '/quiet', '/norestart' -NoNewWindow -Wait

RUN Write-Host 'Installing python v3.7.3' ; `
    Start-Process  C:\exes\python-3.7.3.exe -ArgumentList '/quiet', InstallAllUsers=1, PrependPath=1, Include_test=0, -NoNewWindow -Wait