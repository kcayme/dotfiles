function search --wraps='nvim ' --wraps='nvim config.fish' --wraps='nvim fzf' --wraps=nvim\ \(fzf\ --preview=\'bat\ --color=always\ \{\}\'\) --description alias\ search=nvim\ \(fzf\ --preview=\'bat\ --color=always\ \{\}\'\)
  nvim (fzf --preview='bat --color=always {}') $argv
        
end
