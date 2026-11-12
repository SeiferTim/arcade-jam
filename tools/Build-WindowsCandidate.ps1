$ErrorActionPreference = 'Stop'
Push-Location (Split-Path -Parent $PSScriptRoot)
try {
  # Compile only: production telemetry must never run in CI.
  haxelib run lime build windows -nolaunch
  if ($LASTEXITCODE -ne 0) { throw 'Windows candidate compilation failed' }
  $hxml = Get-Content export/windows/haxe/release.hxml -Raw
  if ($hxml -match '(arcade_smoke|arcade_regression|native_regression|tests[/\\]native)') { throw 'Release build contains test-only settings' }
  $bin = Join-Path (Get-Location) 'export/windows/bin'
  if (!(Test-Path (Join-Path $bin 'fossil.exe'))) { throw 'Missing Windows executable' }
  New-Item -ItemType Directory -Force candidate | Out-Null
  Copy-Item export/windows/haxe/release.hxml candidate/release.hxml
  $sha = (git rev-parse HEAD).Trim()
  $manifest = @{ game='Fossil Finders'; sourceCommit=$sha; configuration='windows'; startup='fullscreen'; deployment='none'; caveats=@('Physical controller/hotplug and cabinet acceptance pending','API disabled pending verified Fossil Finders game registration ID','Physical two-controller test pending'); files=@(Get-ChildItem $bin -File -Recurse | ForEach-Object { @{path=[IO.Path]::GetRelativePath($bin,$_.FullName);sha256=(Get-FileHash $_.FullName -Algorithm SHA256).Hash} }) }
  $manifest | ConvertTo-Json -Depth 6 | Set-Content candidate/manifest.json
  Compress-Archive -Path "$bin/*" -DestinationPath candidate/FossilFinders-Windows.zip -Force
  Get-FileHash candidate/FossilFinders-Windows.zip -Algorithm SHA256 | Format-List | Out-File candidate/SHA256.txt
} finally { Pop-Location }
