(Get-Process -Id $pid).PriorityClass = "Idle"

$starting = [System.DateTime]::UtcNow
$week = $starting.Date.AddDays(-$starting.DayOfWeek).ToString("yyyy-MM-dd")
$day = $starting.Date.ToString("yyyy-MM-dd")

$searches = @(
)

$args = New-Object System.Collections.Generic.List[string]

Set-Location $PSScriptRoot

[System.IO.File]::WriteAllText("EndOf.Starting.txt", $starting.ToString("yyyy-MM-dd HH:mm:ss.fff"))

if (![System.IO.File]::Exists("EndOf.Week.txt") -or ($week -ne [System.IO.File]::ReadAllText("EndOf.Week.txt")))
{
    $weekChanged = $true
    foreach ($search in $searches)
    {
        foreach ($config in Get-ChildItem -Filter "EndOfWeek.Instructions.config" -File -Recurse -Path $search)
        {
            $args.Add("-Instructions")
            $args.Add('"' + $config.FullName + '"')
        }
    }
}
else
{
    $weekChanged = $false;
}

if (![System.IO.File]::Exists("EndOf.Day.txt") -or ($day -ne [System.IO.File]::ReadAllText("EndOf.Day.txt")))
{
    $dayChanged = $true;
    foreach ($search in $searches)
    {
        foreach ($config in Get-ChildItem -Filter "EndOfDay.Instructions.config" -File -Recurse -Path $search)
        {
            $args.Add("-Instructions")
            $args.Add('"' + $config.FullName + '"')
        }
    }
}
else
{
    $dayChanged = $false;
}

if ($args.Count -gt 0)
{
    & \Innovoft\ProcessPipeline\ProcessPipeline.exe -Pipeline "C:\Innovoft\ProcessPipeline\Pipeline.config" $args
}

Set-Location $PSScriptRoot

if ($weekChanged)
{
    [System.IO.File]::WriteAllText("EndOf.Week.txt", $week)
}

if ($dayChanged)
{
    [System.IO.File]::WriteAllText("EndOf.Day.txt", $day)
}

$finished = [System.DateTime]::UtcNow
[System.IO.File]::WriteAllText("EndOf.Finished.txt", $finished.ToString("yyyy-MM-dd HH:mm:ss.fff"))

$elapsed = $finished - $starting
[System.IO.File]::WriteAllText("EndOf.Elapsed.txt", $elapsed)
