(Get-Process -Id $pid).PriorityClass = "Idle"

$now = [System.DateTime]::UtcNow
$week = $now.Date.AddDays(-$now.DayOfWeek).ToString("yyyy-MM-dd")
$day = $now.Date.ToString("yyyy-MM-dd")

Set-Location $PSScriptRoot
[System.Environment]::CurrentDirectory = $PSScriptRoot

$args = New-Object System.Collections.Generic.List[string]

if (![System.IO.File]::Exists("EndOf.Week.txt") -or ($week -ne [System.IO.File]::ReadAllText("EndOf.Week.txt")))
{
    $weekChanged = $true
    $args.Add("-InstructionsSearchs")
    $args.Add("EndOf.Paths.txt")
    $args.Add("EndOfWeek.Instructions.config")
    $args.Add("AllDirectories")
}
else
{
    $weekChanged = $false;
}

if (![System.IO.File]::Exists("EndOf.Day.txt") -or ($day -ne [System.IO.File]::ReadAllText("EndOf.Day.txt")))
{
    $dayChanged = $true;
    $args.Add("-InstructionsSearchs")
    $args.Add("EndOf.Paths.txt")
    $args.Add("EndOfDay.Instructions.config")
    $args.Add("AllDirectories")
}
else
{
    $dayChanged = $false;
}

if ($instructions.Count -gt 0)
{
    & \Innovoft\ProcessPipeline\ProcessPipeline.exe -Pipeline "\Innovoft\ProcessPipeline\Pipeline.config" -Log "EndOf.{LCL:yyyyMMdd}.log" -LogFlush true -args
}

if ($weekChanged)
{
    [System.IO.File]::WriteAllText("EndOf.Week.txt", $week)
}

if ($dayChanged)
{
    [System.IO.File]::WriteAllText("EndOf.Day.txt", $day)
}
