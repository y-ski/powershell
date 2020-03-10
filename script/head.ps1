function head {
    param (
        [Parameter(Mandatory = $true, Position = 1)]
        [string] $path,
        [Parameter()]
        [int] $n = 10
    )
    begin { }
    process {
        if (Test-Path $path) {
            Get-Content $path -Head $n
        } else {
            Write-Host "not found: $path"
        }
    }
    end { }
}
