# Start Express API + Angular dashboard (separate windows)

$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent $PSScriptRoot

if (-not (Test-Path (Join-Path $Root "backend-express\.env"))) {
    Write-Host "Run .\scripts\setup-db.ps1 first." -ForegroundColor Yellow
    exit 1
}

Write-Host "Starting Express API on http://localhost:3000"
Start-Process powershell -ArgumentList @(
    "-NoExit", "-Command",
    "Set-Location '$Root\backend-express'; npm run dev"
)

Start-Sleep -Seconds 2

Write-Host "Starting Angular on http://localhost:4200"
Start-Process powershell -ArgumentList @(
    "-NoExit", "-Command",
    "Set-Location '$Root\frontend-office\web-angular'; npm start"
)

Write-Host "`nDev servers launching in new terminals." -ForegroundColor Green
Write-Host "  API:       http://localhost:3000/api/health"
Write-Host "  Dashboard: http://localhost:4200"
