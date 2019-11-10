function showMessageBox {
    param (
        [String] $message = "",
        [String] $title = "Message Box",
        [Int] $time = 1,
        [Int] $type = 1
    )

    $messageBox = New-Object -comobject wscript.shell
    $result = $messageBox.popup($message, $time, $title, $type)
    return $result
}
