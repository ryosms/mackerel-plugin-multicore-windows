function GraphDefinition() {
    Write-Output "# mackerel-agent-plugin"
}

function GetEpoch($date) {
    return [Math]::Truncate(($date - (Get-Date("1970/01/01 00:00:00 GMT"))).TotalSeconds)
}
function FetchMetrics() {
    $epoch = $(GetEpoch(Get-Date))
    Write-Output $epoch
}

if($env:MACKEREL_AGENT_PLUGIN_META -eq "1") {
    GraphDefinition
} else {
    FetchMetrics
}
