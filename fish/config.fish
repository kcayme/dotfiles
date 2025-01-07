if status is-interactive
    # Commands to run in interactive sessions can go here
end

oh-my-posh init fish --config $(brew --prefix oh-my-posh)/themes/hul10.omp.json | source
zoxide init fish | source
fzf --fish | source

# environment variables
set -x XDG_CONFIG_HOME "$HOME/.config"

# start ssh-agent
fish_ssh_agent
ssh-add ~/.ssh/id_amihan
#ssh-add ~/.ssh/id_personal_2
