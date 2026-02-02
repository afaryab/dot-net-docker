# Development base image for .NET applications
# Mount your application source code to /app to use this container
FROM mcr.microsoft.com/dotnet/sdk:8.0
WORKDIR /app
RUN dotnet tool install --global dotnet-ef --version 8.0.10
ENV PATH="$PATH:/root/.dotnet/tools"
EXPOSE 8080
ENV ASPNETCORE_URLS=http://+:8080
ENTRYPOINT ["dotnet", "watch", "run"]
