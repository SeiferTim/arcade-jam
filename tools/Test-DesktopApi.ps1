$ErrorActionPreference = 'Stop'
Push-Location (Split-Path -Parent $PSScriptRoot)
try {
    foreach ($test in @('DesktopOnlineSessionTest','DesktopOnlineBudgetTest','DesktopOnlineDispatcherTest','DesktopOnlineConcurrencyTest')) {
        haxe -cp source -cp tests/desktop-api -main $test -D desktop --interp
        if ($LASTEXITCODE -ne 0) { throw "$test failed" }
    }
    haxe -cp source -cp tests/desktop-api -cp tests/desktop-api/stubs -main DesktopOnlineFacadeTest -D desktop --interp
    if ($LASTEXITCODE -ne 0) { throw 'Telemetry facade tests failed' }
    haxe -cp source -cp tests/desktop-api -cp tests/desktop-api/stubs -cp tests/desktop-api/http-stubs -main DesktopOnlineHttpTest -D desktop --interp
    if ($LASTEXITCODE -ne 0) { throw 'Telemetry HTTP boundary tests failed' }
    foreach ($mode in @('', 'arcade_smoke', 'arcade_regression', 'native_regression')) {
        $args = @('-cp','source','-cp','tests/desktop-api','-cp','tests/desktop-api/stubs','-main','FossilApiTest','-D','desktop','--interp')
        if ($mode) { $args += @('-D', $mode) }
        haxe @args
        if ($LASTEXITCODE -ne 0) { throw "Fossil API isolation failed: $mode" }
    }
} finally { Pop-Location }
