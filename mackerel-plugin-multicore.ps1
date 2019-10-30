function GraphDefinition() {
    $metrics = @(
        @{
            name = "processor"
            label = "processor"
            stacked = $TRUE
        }
    )
    $meta = @{
        graphs = @{
            "cpu.multicore.#" = @{
                label = "MultiCore CPU"
                unit = "percentage"
                metrics = $metrics
            }
        }
    }
    Write-Output "# mackerel-agent-plugin"
    Write-Output $($meta | ConvertTo-Json -Depth 4 -Compress)
}

function GetEpoch($date) {
    return [Math]::Truncate(($date - (Get-Date("1970/01/01 00:00:00 GMT"))).TotalSeconds)
}
function FetchMetrics() {
    $epoch = $(GetEpoch(Get-Date))

    $cpus = Get-CimInstance -ClassName Win32_PerfFormattedData_PerfOS_Processor
    foreach ($cpu in $cpus) {
        $name = $cpu.Name
        if($name -ne "_Total") {
            $cpuName = $name.PadLeft(2, '0')
            Write-Output("cpu.multicore.cpu{0}.processor`t{1}`t{2}" -f $cpuName, $cpu.PercentProcessorTime, $epoch)
        }
    }
}

if($env:MACKEREL_AGENT_PLUGIN_META -eq "1") {
    GraphDefinition
} else {
    FetchMetrics
}
