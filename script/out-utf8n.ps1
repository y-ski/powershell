function Out-UTF8 {
    param (
        [Parameter(Mandatory = $True, ValueFromPipeline = $True)]
        [Array] $line,
        [Parameter(Mandatory = $True)]
        [String] $File,
        [Switch] $CrLf,
        [Switch] $BOM
    )

    begin {
        $EOL = "`n"
        if ($CRLF) {
            $EOL = "`r`n"
        }
        $lines = @()
    }

    process {
        $lines += $line
    }

    end {
        Write-Host $File
        if ($BOM) {
            $lines -join $EOL | Out-File -Encoding UTF8 $File -NoNewline
        } else {
            $lines -join $EOL `
            | % { [Text.Encoding]::UTF8.GetBytes($_) } `
            | Set-Content -Path $File -Encoding Byte
        }
    }
}
