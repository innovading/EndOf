(Get-Process -Id $pid).PriorityClass = "Idle"

$starting = [System.DateTime]::UtcNow
$week = $starting.Date.AddDays(-$starting.DayOfWeek).ToString("yyyy-MM-dd")
$day = $starting.Date.ToString("yyyy-MM-dd")

$searches = @(
)

$instructions = New-Object System.Collections.Generic.List[string]

Set-Location $PSScriptRoot
[System.Environment]::CurrentDirectory = $PSScriptRoot

if (![System.IO.File]::Exists("EndOf.Week.txt") -or ($week -ne [System.IO.File]::ReadAllText("EndOf.Week.txt")))
{
    $weekChanged = $true
    foreach ($search in $searches)
    {
        if (Test-Path $search -PathType Container)
        {
            foreach ($config in Get-ChildItem -Filter "EndOfWeek.Instructions.config" -File -Recurse -Path $search)
            {
                $instructions.Add($config.FullName)
            }
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
        if (Test-Path $search -PathType Container)
        {
            foreach ($config in Get-ChildItem -Filter "EndOfDay.Instructions.config" -File -Recurse -Path $search)
            {
                $instructions.Add($config.FullName)
            }
        }
    }
}
else
{
    $dayChanged = $false;
}

if ($instructions.Count -gt 0)
{
    [System.IO.File]::WriteAllLines("EndOf.Instructions.txt", $instructions)
    & \Innovoft\ProcessPipeline\ProcessPipeline.exe -Pipeline "\Innovoft\ProcessPipeline\Pipeline.config" -Log "EndOf.log" -LogFlush true -InstructionsTXT "EndOf.Instructions.txt"
}

if ($weekChanged)
{
    [System.IO.File]::WriteAllText("EndOf.Week.txt", $week)
}

if ($dayChanged)
{
    [System.IO.File]::WriteAllText("EndOf.Day.txt", $day)
}
