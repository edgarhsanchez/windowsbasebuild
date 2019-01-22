# escape=`

FROM containerize_vsbuild_winbase

RUN powershell Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
RUN choco install netfx-4.6.1-devpack -y

ADD ["Reference Assemblies.tar", "/c/Program Files (x86)/Reference Assemblies"]
ADD ["packages.tar", "C:/Program Files (x86)/Microsoft Visual Studio/Shared/Packages"]