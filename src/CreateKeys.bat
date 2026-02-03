set sshFileName=%1
set sshPassword=%2

if not exist terraform.tfstate (
    @REM tofu init
    echo hi
)

ssh-keygen -f "../keys/%sshFileName%" -P %sshPassword%

(
    echo variable "pubKeyName" {
    echo    type = string
    echo    default = "../keys/%sshFileName%.pub"
    echo }

    echo variable "keyName" {
    echo    type = string
    echo    default = "../keys/%sshFileName%"
    echo }
) > "keyName.tofu"