# windowsbasebuild
a windows container base that can be used as a foundation to allow .NET applications to be built inside of a container


Contents...

GetSessionToken.sh : can be used to setup an aws login when the account is configured for MFA.  This is needed only if AWS is used as the docker registry.

winbase.Dockerfile : builds a basic windows base with MsBuid and Nuget

winbase2.Dockerfile : builds upon the winbase.Dockerfile and adds visual studio files 


Prereqs:

You will need to have visual studio 2017 pre-installed on the system if you are building this image as no files for visual studio were included in this project
