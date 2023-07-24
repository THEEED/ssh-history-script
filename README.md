# SSH History Script

SSH History Script is a utility tool for maintaining a history of your SSH connections. It automatically logs all new connections, offers a list of recent unique connections when run without arguments, and facilitates quick connections to recently used hosts.

## Installation

1. Download the `ssh_history.sh` from this repository.

2. Give the file execution permissions. You can do this by running `chmod +x ssh_history.sh` in the terminal.

3. Run the script without arguments. This will prompt the script to add the necessary code to your shell's configuration file (.bashrc, .bash_profile, .zshrc, etc.):

    ```bash
    ./ssh_history.sh
    ```
4. Save the changes and restart the shell or open a new terminal window.

## How It Works

The script works in the following way:

1. When you attempt to connect to a host using SSH, the script first checks if the host details are unique. If they are, it logs the connection details along with a timestamp to a history file stored at `~/.ssh_history`.

2. If you run the script without any arguments, it reads the history file, extracts the last ten unique hosts, and presents them as a list for you to choose from. You can then select any host from the list to establish a SSH connection.

3. If you're trying to connect to a host that is not already added to your SSH config file, the script will prompt you to add it. You can choose to assign a friendly name to the host for future connections. If you choose not to assign a name, the script will still establish the SSH connection and log the details to the history file.

## Usage

To connect to a host and automatically log the connection to history, use the SSH command as usual:

```bash
ssh user@hostname
```

If you want to connect to a recently used host, simply type `ssh` without any arguments. You'll be presented with a list of recent connections to choose from.

License
-------

This project is available under the MIT License. Details can be found in the [LICENSE](LICENSE) file.