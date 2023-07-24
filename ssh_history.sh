#!/bin/bash

if ! command -v ssh >/dev/null; then
    echo "Ошибка: ssh не установлен"
    exit 1
fi

SSH_HISTORY="$HOME/.ssh_history"

if [ ! -f "$SSH_HISTORY" ]; then
    touch "$SSH_HISTORY"
fi

UNIQUE_HOSTS=$(awk '{print $2}' "$SSH_HISTORY" | sort -u | sort -r | head -n 10)


if [ $# -eq 0 ]; then
    PS3="Выберите хост: "
    select HOST in $UNIQUE_HOSTS "Выход"; do
        case $HOST in
            Выход)
                exit 0
                ;;
            *)
                ssh "$HOST"
                exit 0
                ;;
        esac
    done
fi

if [ $# -ge 1 ]; then
    SSH_COMMAND="$*"
    HOSTNAME="${SSH_COMMAND#*@}"
    USERNAME="${SSH_COMMAND%@*}"

    if grep -q "^.* $SSH_COMMAND" "$SSH_HISTORY"; then
        sed -i "/^.* $SSH_COMMAND/d" "$SSH_HISTORY"
    fi
    echo "$(date +%s) $SSH_COMMAND" >> "$SSH_HISTORY"

    if ! grep -q " $HOSTNAME" ~/.ssh/config; then
        read -p "Хост $HOSTNAME не найден в конфигурации SSH. Хотите добавить его? (y/n) " -n 1 -r
        echo    # (optional) move to a new line
        if [[ $REPLY =~ ^[Yy]$ ]]
        then
            read -p "Введите название для этого хоста: " HOST_ALIAS
            echo "Host $HOST_ALIAS" >> ~/.ssh/config
            echo "  HostName $HOSTNAME" >> ~/.ssh/config
            echo "  User $USERNAME" >> ~/.ssh/config
            echo "Добавлен новый хост $HOST_ALIAS ($HOSTNAME) в файл конфигурации SSH."
        fi
    fi
    ssh "$SSH_COMMAND"
    exit 0
fi

case $SHELL in
*/zsh)
    # assume Zsh
    shell_profile="$HOME/.zshrc"
    ;;
*/bash)
    # assume Bash
    shell_profile="$HOME/.bashrc"
    ;;
*)
    # default to Bash
    shell_profile="$HOME/.bashrc"
    ;;
esac

if ! grep -q "_ssh_completion" "$shell_profile"; then
    echo "

_ssh_completion()
{
    local cur=\${COMP_WORDS[COMP_CWORD]}
    local hosts_from_history=\$(awk '{print \$2}' \"$SSH_HISTORY\" | sort -u | sort -r)
    local hosts_from_config=\$(awk '/^Host / {print \$2}' ~/.ssh/config)
    COMPREPLY=( \$(compgen -W \"\$hosts_from_history \$hosts_from_config\" -- \$cur) )
}
complete -F _ssh_completion ssh
" >> "$shell_profile"
    source "$shell_profile"
fi