#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-buster-slim AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/core/sdk:3.1-buster AS build
#copy csproj to restore dependencies and update nuget cache
WORKDIR /src
COPY ["api/CaseFile.Api/CaseFile.Api.csproj", "api/CaseFile.Api/"]
COPY ["api/CaseFile.Api.Auth/CaseFile.Api.Auth.csproj", "api/CaseFile.Api.Auth/"]
COPY ["api/CaseFile.Entities/CaseFile.Entities.csproj", "api/CaseFile.Entities/"]
COPY ["api/CaseFile.Api.Core/CaseFile.Api.Core.csproj", "api/CaseFile.Api.Core/"]
COPY ["api/CaseFile.Api.Business/CaseFile.Api.Business.csproj", "api/CaseFile.Api.Business/"]
COPY ["api/CaseFile.Api.Answer/CaseFile.Api.Answer.csproj", "api/CaseFile.Api.Answer/"]
COPY ["api/CaseFile.Api.Note/CaseFile.Api.Note.csproj", "api/CaseFile.Api.Note/"]
COPY ["api/CaseFile.Api.Form/CaseFile.Api.Form.csproj", "api/CaseFile.Api.Form/"]
COPY ["api/CaseFile.Api.County/CaseFile.Api.County.csproj", "api/CaseFile.Api.County/"]
COPY ["CaseFile.sln", "CaseFile.sln"]
RUN dotnet restore
COPY /api/. ./api

RUN dotnet build -c Release -o /app/build

FROM build AS publish
RUN dotnet publish -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "CaseFile.Api.dll"]