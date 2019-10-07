# mackerel-plugin-multicore-windows

Get multicore CPU metrics for Windows

* CPU processor time by cores
* CPU idle time by cores

this plugin **doesn't** work on powershell core.

## Synopsis

```shell
mackerel-plugin-multicore.bat
```

## Example of mackerel-agent.conf

```
[plugin.metrics.multicore]
command = 'C:\path\to\mackerel-plugin-multicore.bat'
```
