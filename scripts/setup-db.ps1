# Smart Wind Power — local dev setup scripts (Windows PowerShell)

$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent $PSScriptRoot
$Psql = "C:\Program Files\PostgreSQL\17\bin\psql.exe"
$Createdb = "C:\Program Files\PostgreSQL\17\bin\createdb.exe"
$Maven = Join-Path $Root ".tools\apache-maven-3.9.6\bin\mvn.cmd"

function Write-Step($msg) { Write-Host "`n==> $msg" -ForegroundColor Cyan }

function Get-PostgresPassword {
    if ($env:POSTGRES_PASSWORD) { return $env:POSTGRES_PASSWORD }
    $secure = Read-Host "PostgreSQL password for user 'postgres'" -AsSecureString
    $ptr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($secure)
    try { return [Runtime.InteropServices.Marshal]::PtrToStringBSTR($ptr) }
    finally { [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($ptr) }
}

function Test-PostgresConnection([string]$password) {
    if (-not (Test-Path $Psql)) {
        throw "psql not found at $Psql. Install PostgreSQL 17 or update the path in scripts/setup-db.ps1"
    }
    $env:PGPASSWORD = $password
    & $Psql -U postgres -h localhost -tAc "SELECT 1" 2>$null | Out-Null
    return $LASTEXITCODE -eq 0
}

function Update-BackendConfig([string]$password) {
    $encoded = [uri]::EscapeDataString($password)
    $dbUrl = "postgresql://postgres:${encoded}@localhost:5432/smart_wind_power"

    $envFile = Join-Path $Root "backend-express\.env"
    @(
        "PORT=3000"
        "DATABASE_URL=$dbUrl"
        "CORS_ORIGIN=http://localhost:4200"
    ) | Set-Content -Path $envFile -Encoding utf8

    $props = Join-Path $Root "backend-admin-spring\src\main\resources\application.properties"
    (Get-Content $props) `
        -replace '^spring\.datasource\.password=.*', "spring.datasource.password=$password" |
        Set-Content -Path $props -Encoding utf8

    Write-Host "Updated backend-express/.env and Spring application.properties"
}

Write-Step "Smart Wind Power — database setup"
$password = Get-PostgresPassword

if (-not (Test-PostgresConnection $password)) {
    throw "Could not connect to PostgreSQL. Check that the service is running and the password is correct."
}

Write-Step "Creating database smart_wind_power (if missing)"
$env:PGPASSWORD = $password
& $Psql -U postgres -h localhost -tAc "SELECT 1 FROM pg_database WHERE datname='smart_wind_power'" | Out-Null
$exists = (& $Psql -U postgres -h localhost -tAc "SELECT 1 FROM pg_database WHERE datname='smart_wind_power'").Trim()
if ($exists -ne "1") {
    & $Createdb -U postgres -h localhost smart_wind_power
    if ($LASTEXITCODE -ne 0) { throw "createdb failed" }
    Write-Host "Database created."
} else {
    Write-Host "Database already exists."
}

Update-BackendConfig $password

Write-Step "Initializing schema via Express"
Push-Location (Join-Path $Root "backend-express")
node -e "require('dotenv').config(); require('./src/db').initDb().then(()=>console.log('Schema OK')).catch(e=>{console.error(e);process.exit(1)})"
Pop-Location

Write-Step "Seeding sample sensor reading"
Push-Location (Join-Path $Root "backend-express")
node -e @"
require('dotenv').config();
const { insertReading, pool } = require('./src/db');
insertReading({
  deviceId: 'wind-turbine-01',
  voltage: 12.4,
  temperature: 24.5,
  humidity: 58,
  relayOn: false
}).then(() => pool.end()).then(() => console.log('Sample data inserted'));
"@
Pop-Location

Write-Host "`nDatabase setup complete." -ForegroundColor Green
Write-Host "Next: .\scripts\start-dev.ps1"
