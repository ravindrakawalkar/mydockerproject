FROM microsoft/dotnet:2.2-aspnetcore-runtime-nanoserver-sac2016 AS base
WORKDIR /app
EXPOSE 19239
EXPOSE 44323

FROM microsoft/dotnet:2.2-sdk-nanoserver-sac2016 AS build
WORKDIR /src
COPY mydockerproject/mydockerproject.csproj mydockerproject/
RUN dotnet restore mydockerproject/mydockerproject.csproj
COPY . .
WORKDIR /src/mydockerproject
RUN dotnet build mydockerproject.csproj -c Release -o /app

FROM build AS publish
RUN dotnet publish mydockerproject.csproj -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "mydockerproject.dll"]
