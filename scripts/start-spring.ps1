# Start Spring Boot admin panel

$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent $PSScriptRoot
$Maven = Join-Path $Root ".tools\apache-maven-3.9.6\bin\mvn.cmd"

if (-not (Test-Path $Maven)) {
    throw "Maven not found at $Maven"
}

Write-Host "Starting Spring Boot admin on http://localhost:8080"
Write-Host "Login: admin / admin123"

Start-Process powershell -ArgumentList @(
    "-NoExit", "-Command",
    "Set-Location '$Root\backend-admin-spring'; & '$Maven' spring-boot:run"
)
