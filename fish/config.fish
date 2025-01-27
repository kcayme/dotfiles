if status is-interactive
    # Commands to run in interactive sessions can go here
end

set fish_greeting
set -x XDG_CONFIG_HOME "$HOME/.config"
switch (uname)
    case 'Linux'
        # Check if it's specifically Ubuntu
        if test -f /etc/os-release
            if string match -q "ID=ubuntu" (cat /etc/os-release)
                set -gx PATH /home/linuxbrew/.linuxbrew/bin /home/linuxbrew/.linuxbrew/sbin $PATH
                # environment variables
                set -gx PATH $PATH:/usr/local/go/bin
                # Set GOPATH
                set -gx GOPATH $HOME/go
                # Add GOPATH/bin to PATH
                set -gx PATH $PATH:$GOPATH/bin
                echo "Ubuntu detected"
            end
        end
end

# remove welcome message
oh-my-posh init fish --config $(brew --prefix oh-my-posh)/themes/hul10.omp.json | source
zoxide init fish | source
fzf --fish | source

# start ssh-agent
# fish_ssh_agent
# ssh-add ~/.ssh/id_amihan
#ssh-add ~/.ssh/id_personal_2
