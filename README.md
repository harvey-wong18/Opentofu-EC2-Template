# Opentofu-EC2-Template
Provision G and P type EC2 instances on AWS to run Isaacsim and Isaaclab


## Create SSH Keys Script (Windows with OpenSSH enabled)
Run the .bat file in /src (command prompt or powershell) with the desired key name and password:
`CreateKeys.bat <key name> <password>`

This .bat script will automatically create a keyName.tofu file containing a variable for the ssh key path to provision with the EC2 instance.

All files in the keys directory are gitignored as well as the keyName.tofu file.

## Connecting to the EC2 instance once it has been provisioned
1) Connect to the EC2 instance via  the AWS console webpage (best way if the instance was not provisioned by you)
2) Enter the command `tofu output` in the terminal. This will return an ssh command like `ssh -i keys/<keyname> <username>@<ipaddress>` which can be copied and pasted into the terminal. Note the ipaddress for the instance may change after a while, but it can be found on the AWS console webpage.

## Using Rustdesk on the EC2 instance
1) If you are logging into the instance for the first time, set the password for the deafult ubuntu user with: `sudo passwd ubuntu`
2) Get the RustDesk id with: `rustdesk --get-id`
3) Set a permanent RustDesk password with: `sudo rustdesk --password <password>`
4) Login with Rust Desk Client