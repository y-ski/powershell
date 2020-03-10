function less {
    param(
        [Parameter()]
        [string[]] $paths
    )

    begin { }
    process {
        $OutputEncoding = [System.Text.Encoding]::GetEncoding('utf-8')
        if ($paths) {
            foreach ($file in $paths) {
                Get-Content $file | & wsl less
            }
        } else {
            $input | & wsl less
        }
    }
    end { }
}
