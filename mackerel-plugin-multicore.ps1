function GraphDefinition() {
    $meta = @{
        graphs = @{
            "cpu.multicore" = @{
                label = "CPU each Cores"
                unit = "percentage"
                metrics = @(
                    @{
                        name = "*.idle"
                        label = "PercentIdleTime"
                        stacked = "true"
                    },
                    @{
                        name = "*.processor"
                        label = "PercentProcessorTime"
                        stacked = "true"
                    }
                )
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

    $cpus = Get-WmiObject Win32_PerfFormattedData_PerfOS_Processor
    foreach ($cpu in $cpus) {
        $name = $cpu.Name
        Write-Output("cpu.multicore.{0}.idle`t{1}`t{2}" -f $name, $cpu.PercentIdleTime, $epoch)
        Write-Output("cpu.multicore.{0}.processor`t{1}`t{2}" -f $name, $cpu.PercentProcessorTime, $epoch)
    }
}

if($env:MACKEREL_AGENT_PLUGIN_META -eq "1") {
    GraphDefinition
} else {
    FetchMetrics
}
