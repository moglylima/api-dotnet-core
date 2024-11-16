# Build stage
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 8080

# Copy and restore dependencies
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY MySimpleApi.csproj ./
RUN dotnet restore "./MySimpleApi.csproj"

# Copy project files and publish
COPY . .
RUN dotnet publish "./MySimpleApi.csproj" -c Release -o /app/publish

# hello
# Final stage - run application
FROM base AS final
WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "MySimpleApi.dll"]
