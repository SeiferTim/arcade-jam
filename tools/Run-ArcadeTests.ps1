param(
    [Parameter(Mandatory=$true)][string]$Executable,
    [string]$Diagnostics = "diagnostics"
)
$ErrorActionPreference = 'Stop'
$exe = (Resolve-Path -LiteralPath $Executable).Path
New-Item -ItemType Directory -Force $Diagnostics | Out-Null
$diag = (Resolve-Path -LiteralPath $Diagnostics).Path
foreach ($device in @('keyboard','gamepad')) {
    $result = Join-Path $diag "$device.json"
    if (Test-Path -LiteralPath $result) { throw "Refusing stale result path: $result" }
    $env:FOSSIL_TEST_DEVICE = $device
    $env:FOSSIL_TEST_RESULT = $result
    $p = Start-Process -FilePath $exe -WorkingDirectory (Split-Path $exe) -WindowStyle Hidden -PassThru -RedirectStandardOutput (Join-Path $diag "$device.stdout.log") -RedirectStandardError (Join-Path $diag "$device.stderr.log")
    if (!$p.WaitForExit(240000)) {
        $p.Kill()
        throw "$device smoke process did not exit within 240 seconds"
    }
    $p.Refresh()
    if ($p.ExitCode -ne 0) { throw "$device smoke failed with process exit $($p.ExitCode); inspect $result" }
    if (!(Test-Path -LiteralPath $result)) { throw "$device smoke omitted result JSON" }
    $data = Get-Content -Raw -LiteralPath $result | ConvertFrom-Json
    if (!$data.passed -or !$data.exitRequested -or $data.device -ne $device -or $data.checks.Count -lt 15) { throw "$device smoke result incomplete or failed: $(Get-Content -Raw -LiteralPath $result)" }
    Write-Host "PASS: $device actual process exit, $($data.checks.Count) checks"
}
Remove-Item Env:FOSSIL_TEST_DEVICE -ErrorAction SilentlyContinue
Remove-Item Env:FOSSIL_TEST_RESULT -ErrorAction SilentlyContinue

