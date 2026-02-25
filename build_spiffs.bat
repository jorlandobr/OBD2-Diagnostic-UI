@echo off
setlocal enabledelayedexpansion

:: ============================================================
:: OBD2 Diagnostic UI - ESP32 SPIFFS Build Script (CMD/BAT)
:: ============================================================

set "PROJECT_ROOT=%~dp0"
set "DATA_DIR=%PROJECT_ROOT%data"

echo.
echo ========================================
echo   OBD2 UI - ESP32 SPIFFS Build (CMD)
echo ========================================
echo.

:: PowerShell kodunu CMD içinde tek satırda veya blok halinde çalıştırıyoruz
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
"$projectRoot = '%PROJECT_ROOT%'.TrimEnd('\'); ^
$dataDir = '%DATA_DIR%'; ^
$excludeDirs = @('.git', 'data', '.agents', '.agent', '_agents', '_agent', 'node_modules', '.vscode'); ^
$excludeFiles = @('build_spiffs.ps1', 'build_spiffs.bat', '*.ino', '*.md', '*.txt', '*.json', 'LICENSE', '.gitignore'); ^
$alreadyCompressed = @('.gz', '.zip', '.woff2', '.woff', '.ttf', '.png', '.jpg', '.jpeg', '.gif', '.ico', '.webp', '.mp3', '.mp4'); ^
^
if (Test-Path $dataDir) { ^
    Write-Host '[*] Eski data/ klasoru siliniyor...' -ForegroundColor Yellow; ^
    Remove-Item $dataDir -Recurse -Force ^
} ^
New-Item -ItemType Directory -Path $dataDir | Out-Null; ^
Write-Host '[+] data/ klasoru olusturuldu.' -ForegroundColor Green; ^
^
$allFiles = Get-ChildItem -Path $projectRoot -Recurse -File | Where-Object { ^
    $file = $_; ^
    $inExcludedDir = $false; ^
    foreach ($exDir in $excludeDirs) { if ($file.FullName -like '*\' + $exDir + '\*') { $inExcludedDir = $true; break } } ^
    if ($inExcludedDir) { return $false } ^
    $isExcluded = $false; ^
    foreach ($pattern in $excludeFiles) { if ($file.Name -like $pattern) { $isExcluded = $true; break } } ^
    if ($isExcluded) { return $false } ^
    return $true ^
}; ^
^
$totalOriginal = 0; $totalCompressed = 0; ^
foreach ($file in $allFiles) { ^
    $relativePath = $file.FullName.Substring($projectRoot.Length).TrimStart('\', '/'); ^
    $ext = $file.Extension.ToLower(); ^
    $shouldGzip = $alreadyCompressed -notcontains $ext; ^
    $dstRelative = if ($shouldGzip) { $relativePath + '.gz' } else { $relativePath }; ^
    $dstPath = Join-Path $dataDir $dstRelative; ^
    $dstDirPath = Split-Path $dstPath -Parent; ^
    if (-not (Test-Path $dstDirPath)) { New-Item -ItemType Directory -Path $dstDirPath | Out-Null } ^
    $srcBytes = [System.IO.File]::ReadAllBytes($file.FullName); ^
    $totalOriginal += $srcBytes.Length; ^
    if ($shouldGzip) { ^
        $memStream = New-Object System.IO.MemoryStream; ^
        $gzStream = New-Object System.IO.Compression.GZipStream($memStream, [System.IO.Compression.CompressionMode]::Compress, $true); ^
        $gzStream.Write($srcBytes, 0, $srcBytes.Length); $gzStream.Close(); ^
        $compBytes = $memStream.ToArray(); ^
        [System.IO.File]::WriteAllBytes($dstPath, $compBytes); ^
        $totalCompressed += $compBytes.Length; ^
        Write-Host ('  [gz] ' + $relativePath) -ForegroundColor Green ^
    } else { ^
        [System.IO.File]::WriteAllBytes($dstPath, $srcBytes); ^
        $totalCompressed += $srcBytes.Length; ^
        Write-Host ('  [cp] ' + $relativePath) -ForegroundColor Gray ^
    } ^
}; ^
Write-Host ''; ^
Write-Host '========================================' -ForegroundColor Cyan; ^
Write-Host ('  Toplam Boyut: ' + [Math]::Round($totalOriginal/1024, 1) + ' KB -> ' + [Math]::Round($totalCompressed/1024, 1) + ' KB') -ForegroundColor Cyan; ^
Write-Host '[OK] data/ klasoru SPIFFS yuklemesi icin hazir!' -ForegroundColor Green; ^
Write-Host '========================================' -ForegroundColor Cyan"

echo.
pause
