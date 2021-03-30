FROM mcr.microsoft.com/dotnet/framework/aspnet:4.8

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
WORKDIR /inetpub
RUN Invoke-WebRequest https://download.microsoft.com/download/1/2/8/128E2E22-C1B9-44A4-BE2A-5859ED1D4592/rewrite_amd64_en-US.msi -OutFile rewrite_amd64_en-US.msi; \
 Start-Process rewrite_amd64_en-US.msi -ArgumentList "/qn" -Wait; \
 Remove-Item rewrite_amd64_en-US.msi; \
 Invoke-WebRequest https://go.microsoft.com/fwlink/?LinkID=615136 -OutFile requestRouter_amd64.msi; \
 Start-Process requestRouter_amd64.msi -ArgumentList "/qn" -Wait; \
 Remove-Item requestRouter_amd64.msi

RUN C:\Windows\System32\inetsrv\appcmd.exe set CONFIG -section:system.webServer/proxy /enabled:"True" /commit:apphost

WORKDIR /inetpub/wwwroot
COPY web.config ./

