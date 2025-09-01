function gl --description "Pretty git log with graph and colors"
    set format '%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'

    if test (count $argv) -gt 0
        # If you pass args (like a branch or commit range), just use those
        git log --color --graph --pretty=format:$format --abbrev-commit $argv
    else
        # No args: default to showing all branches
        git log --color --graph --pretty=format:$format --abbrev-commit --branches
    end
end


# function gl --wraps=git\ log\ --color\ --graph\ --pretty=format:\'\%Cred\%h\%Creset\ -\%C\(yellow\)\%d\%Creset\ \%s\ \%Cgreen\(\%cr\)\ \%C\(bold\ blue\)\<\%an\>\%Creset\'\ --abbrev-commit\ --branches --description alias\ gl=git\ log\ --color\ --graph\ --pretty=format:\'\%Cred\%h\%Creset\ -\%C\(yellow\)\%d\%Creset\ \%s\ \%Cgreen\(\%cr\)\ \%C\(bold\ blue\)\<\%an\>\%Creset\'\ --abbrev-commit\ --branches
#   git log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --branches $argv
#         
# end
