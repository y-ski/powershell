function less {
    param()

    begin {
        # with BOM when use `[System.Text.Encoding]::GetEncoding('utf-8')`
        $OutputEncoding = [System.Text.UTF8Encoding]::new()
    }
    process {
        if ($args) {
            # from parameters
            foreach ($path in $args) {
                Get-Content $path | & wsl less
            }
        } elseif ($input) {
            # from input stream(pipeline)
            $input | & wsl less
        }
    }
    end {
    }
}
