$ErrorActionPreference='Stop'
haxelib run lime build windows -D arcade_smoke -debug -nolaunch
if($LASTEXITCODE -ne 0){throw 'Native smoke compilation failed'}
./tools/Run-ArcadeTests.ps1 -Executable export/windows/bin/fossil.exe -Diagnostics diagnostics
