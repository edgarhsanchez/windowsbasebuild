# escape=`

# Use the latest Windows Server Core image with .NET Framework 4.8.
FROM mcr.microsoft.com/dotnet/framework/runtime:4.6.2-windowsservercore-ltsc2016
FROM mcr.microsoft.com/dotnet/framework/runtime:4.7.1-windowsservercore-ltsc2016
FROM mcr.microsoft.com/dotnet/framework/runtime:4.7.2-windowsservercore-ltsc2016
FROM mcr.microsoft.com/dotnet/framework/runtime:4.8-windowsservercore-ltsc2016

# Restore the default Windows shell for correct batch processing.

CMD ["powershell.exe", "-NoLogo", "-ExecutionPolicy", "Bypass"]

RUN powershell Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
RUN powershell choco install visualstudio2017buildtools --package-parameters "--allWorkloads --includeRecommended --includeOptional --passive" -y --wait `
    || EXIT 0
RUN powershell choco install nodejs.install -y
RUN powershell choco install yarn -y

# Add older visual studio solution files.
ADD ["Microsoft Visual Studio 11.0", "C:/Program Files (x86)/Microsoft Visual Studio 11.0"]
ADD ["Microsoft Visual Studio 12.0", "C:/Program Files (x86)/Microsoft Visual Studio 12.0"]
ADD ["Microsoft Visual Studio 14.0", "C:/Program Files (x86)/Microsoft Visual Studio 14.0"]

