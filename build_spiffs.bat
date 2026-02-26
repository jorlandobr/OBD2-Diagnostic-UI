@echo off
setlocal
:: Set window size and buffer for scrollability
powershell -NoProfile -Command "$h=Get-Host;$w=$h.UI.RawUI;$b=$w.BufferSize;$b.Height=1000;$b.Width=120;$w.BufferSize=$b;$s=$w.WindowSize;$s.Height=30;$s.Width=120;$w.WindowSize=$s" 2>nul

:: Start Professional Hybrid PowerShell Block
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "$projectRoot = '%~dp0';" ^
    "$dataDir = Join-Path $projectRoot 'data';" ^
    "$excludeDirs = @('.git', 'data', '.agents', '.agent', '_agents', '_agent', 'node_modules', '.vscode');" ^
    "$excludeFiles = @('build_spiffs.ps1', 'build_spiffs.bat', '*.ino', '*.md', '*.txt', '*.json', 'LICENSE', '.gitignore');" ^
    "$alreadyCompressed = @('.gz', '.zip', '.woff2', '.woff', '.ttf', '.png', '.jpg', '.jpeg', '.gif', '.ico', '.webp', '.mp3', '.mp4');" ^
    "Clear-Host; Write-Host '';" ^
    "Write-Host '  +----------------------------------------------------------+' -ForegroundColor Cyan;" ^
    "Write-Host '  |                                                          |' -ForegroundColor Cyan;" ^
    "Write-Host '  |    OBD2 UI -> ESP32 SPIFFS BUILD TOOL (PRO)              |' -ForegroundColor Cyan;" ^
    "Write-Host '  |                                                          |' -ForegroundColor Cyan;" ^
    "Write-Host '  +----------------------------------------------------------+' -ForegroundColor Cyan;" ^
    "Write-Host '';" ^
    "if (Test-Path $dataDir) { Write-Host '  [*] Cleaning old data directory...' -ForegroundColor Gray; Remove-Item $dataDir -Recurse -Force };" ^
    "New-Item -ItemType Directory -Path $dataDir | Out-Null;" ^
    "Write-Host '  [+] Data directory is ready.' -ForegroundColor Green; Write-Host '';" ^
    "$allFiles = Get-ChildItem -Path $projectRoot -Recurse -File | Where-Object { " ^
    "  $file = $_; " ^
    "  foreach ($exDir in $excludeDirs) { if ($file.FullName -like '*\$exDir\*') { return $false } }; " ^
    "  foreach ($pattern in $excludeFiles) { if ($file.Name -like $pattern) { return $false } }; " ^
    "  return $true;" ^
    "};" ^
    "Write-Host '  [i] ' -NoNewline -ForegroundColor Cyan; Write-Host ($allFiles.Count.ToString() + ' files found, processing...') -ForegroundColor White;" ^
    "Write-Host ('  ' + ('-' * 85)) -ForegroundColor DarkGray;" ^
    "$totalOrig = 0; $totalComp = 0; $gzCount = 0; $cpCount = 0;" ^
    "foreach ($file in $allFiles) {" ^
    "  $relPath = $file.FullName.Substring($projectRoot.Length).TrimStart('\', '/');" ^
    "  $shouldGzip = $alreadyCompressed -notcontains $file.Extension.ToLower();" ^
    "  $dstPath = if ($shouldGzip) { Join-Path $dataDir ($relPath + '.gz') } else { Join-Path $dataDir $relPath };" ^
    "  $dstDir = Split-Path $dstPath -Parent;" ^
    "  if (-not (Test-Path $dstDir)) { New-Item -ItemType Directory -Path $dstDir | Out-Null };" ^
    "  $srcBytes = [System.IO.File]::ReadAllBytes($file.FullName);" ^
    "  $origSize = $srcBytes.Length; $totalOrig += $origSize;" ^
    "  if ($shouldGzip) {" ^
    "    $ms = New-Object System.IO.MemoryStream;" ^
    "    $gs = New-Object System.IO.Compression.GZipStream($ms, [System.IO.Compression.CompressionMode]::Compress);" ^
    "    $gs.Write($srcBytes, 0, $srcBytes.Length); $gs.Close();" ^
    "    [System.IO.File]::WriteAllBytes($dstPath, $ms.ToArray());" ^
    "    $compSize = $ms.ToArray().Length; $totalComp += $compSize; $gzCount++;" ^
    "    $ratio = [Math]::Round((1 - $compSize / $origSize) * 100, 1);" ^
    "    Write-Host '  [gz] ' -NoNewline -ForegroundColor Green;" ^
    "    Write-Host ('{0,-50}' -f $relPath) -NoNewline -ForegroundColor White;" ^
    "    Write-Host (' {0,7} KB -> {1,6} KB ' -f [Math]::Round($origSize/1024,1), [Math]::Round($compSize/1024,1)) -NoNewline -ForegroundColor Gray;" ^
    "    Write-Host (' (-' + $ratio + '%%)') -ForegroundColor Green;" ^
    "  } else {" ^
    "    Copy-Item $file.FullName $dstPath;" ^
    "    $totalComp += $origSize; $cpCount++;" ^
    "    Write-Host '  [cp] ' -NoNewline -ForegroundColor DarkGray;" ^
    "    Write-Host ('{0,-50}' -f $relPath) -NoNewline -ForegroundColor White;" ^
    "    Write-Host (' {0,7} KB ' -f [Math]::Round($origSize/1024, 1)) -NoNewline -ForegroundColor Gray;" ^
    "    Write-Host ' (SkipGzip)' -ForegroundColor DarkGray;" ^
    "  }" ^
    "};" ^
    "Write-Host ('  ' + ('-' * 85)) -ForegroundColor DarkGray;" ^
    "$totalRatio = if ($totalOrig -gt 0) { [Math]::Round((1 - $totalComp / $totalOrig) * 100, 1) } else { 0 };" ^
    "Write-Host ''; Write-Host '  FINAL SUMMARY REPORT:' -ForegroundColor White;" ^
    "Write-Host '  +-------------------------------------------+' -ForegroundColor Cyan;" ^
    "Write-Host ('  | {0,-41} |' -f ('Gzipped Files   : ' + $gzCount)) -ForegroundColor Cyan;" ^
    "Write-Host ('  | {0,-41} |' -f ('Copied Files    : ' + $cpCount)) -ForegroundColor Cyan;" ^
    "Write-Host ('  | {0,-41} |' -f ('Original Size   : ' + [Math]::Round($totalOrig/1024,1) + ' KB')) -ForegroundColor Cyan;" ^
    "Write-Host ('  | {0,-41} |' -f ('Compressed Size : ' + [Math]::Round($totalComp/1024,1) + ' KB')) -ForegroundColor Cyan;" ^
    "Write-Host ('  | {0,-41} |' -f ('Total Savings   : ' + $totalRatio + ' %%')) -ForegroundColor Cyan;" ^
    "Write-Host '  +-------------------------------------------+' -ForegroundColor Cyan;" ^
    "Write-Host ''; Write-Host '  [SUCCESS] Build process completed!' -ForegroundColor Green;" ^
    "Write-Host '  [INFO] You can now upload the data folder via Arduino IDE.' -ForegroundColor Yellow; Write-Host '';"
pause
