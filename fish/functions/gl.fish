function gl --wraps=git\ log\ --color\ --graph\ --pretty=format:\'\%Cred\%h\%Creset\ -\%C\(yellow\)\%d\%Creset\ \%s\ \%Cgreen\(\%cr\)\ \%C\(bold\ blue\)\<\%an\>\%Creset\'\ --abbrev-commit\ --branches --description alias\ gl=git\ log\ --color\ --graph\ --pretty=format:\'\%Cred\%h\%Creset\ -\%C\(yellow\)\%d\%Creset\ \%s\ \%Cgreen\(\%cr\)\ \%C\(bold\ blue\)\<\%an\>\%Creset\'\ --abbrev-commit\ --branches
  git log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --branches $argv
        
end
