# escape=`

FROM microsoft/dotnet-framework
LABEL maintainer="edgar0103sanchez@yahoo.com"

WORKDIR C:\
ADD *.ps1 C:\
ADD *.nupkg C:\packages\

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

ENV chocolateyUseWindowsCompression false
RUN .\install.ps1


RUN choco install -f .\packages\yarn.1.16.0.nupkg -y
RUN choco install -f .\packages\nodejs.install.12.2.0.nupkg -y
RUN choco install -f .\packages\visualstudio2017buildtools.15.9.11.0.nupkg -y
