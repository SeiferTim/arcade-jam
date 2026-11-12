$ErrorActionPreference='Stop'
./tools/Test-DesktopApi.ps1
haxe -cp source -cp tests/desktop-api -cp tests/desktop-api/stubs -main SavesScoreTest -D desktop --interp
if($LASTEXITCODE -ne 0){throw 'Two-player leaderboard retention failed'}
