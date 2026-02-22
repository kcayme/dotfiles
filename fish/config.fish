if status is-interactive
    # Commands to run in interactive sessions can go here
    # enable vim binding
    fish_vi_key_bindings --no-erase insert
    if command -q fastfetch
        fastfetch --config examples/7.jsonc
    end
end

set fish_greeting
set -x XDG_CONFIG_HOME "$HOME/.config"
set -x EDITOR nvim
switch (uname)
    case Linux
        # Check if it's specifically Ubuntu
        if test -f /etc/os-release
            if grep -q '^ID=ubuntu' /etc/os-release
                # set -gx PATH /home/linuxbrew/.linuxbrew/bin /home/linuxbrew/.linuxbrew/sbin $PATH
                # # environment variables
                # set -gx PATH $PATH:/usr/local/go/bin

                fish_add_path /home/linuxbrew/.linuxbrew/bin
                fish_add_path /home/linuxbrew/.linuxbrew/sbin
                # environment variables
                # fish_add_path /local/go/bin
                # fish_add_path /usr/local/go/bin
                # Set GOPATH (run once)
                # set -gx GOPATH $HOME/go
                # fish_add_path $GOPATH/bin
            end
        end
end

# remove welcome message
# oh-my-posh init fish --config $(brew --prefix oh-my-posh)/themes/hul10.omp.json | source
# source "$HOME/.cargo/env.fish" # For fish
set -Ux CARAPACE_BRIDGES 'zsh,fish,bash,inshellisense' # optional
# carapace _carapace | source
oh-my-posh init fish --config "~/.config/oh-my-posh/.custom.omp.json" | source
zoxide init fish | source
fzf --fish | source

rerender_on_bind_mode_change
# start ssh-agent
fish_ssh_agent
# ssh-add ~/.ssh/id_amihan
#ssh-add ~/.ssh/id_personal_2

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
# if test -f /Users/karlcayme/miniconda3/bin/conda
#     eval /Users/karlcayme/miniconda3/bin/conda "shell.fish" "hook" $argv | source
# else
#     if test -f "/Users/karlcayme/miniconda3/etc/fish/conf.d/conda.fish"
#         . "/Users/karlcayme/miniconda3/etc/fish/conf.d/conda.fish"
#     else
#         set -x PATH "/Users/karlcayme/miniconda3/bin" $PATH
#     end
# end
# <<< conda initialize <<<

# if not set -q __conda_initialized
#     set -g __conda_initialized yes
#
#     if test -f ~/miniconda3/etc/fish/conf.d/conda.fish
#         source ~/miniconda3/etc/fish/conf.d/conda.fish
#     else
#         set -x PATH ~/miniconda3/bin $PATH
#     end
# end
