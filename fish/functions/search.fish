function search --wraps=fzf\ --preview\ \'bat\ --color=always\ \{\}\' --description alias\ search=fzf\ --preview\ \'bat\ --color=always\ \{\}\'
  fzf --preview 'bat --color=always {}' $argv
        
end
