# modify the prompt to contain git branch name if applicable
git_prompt_info() {
  current_branch=$(git current-branch 2> /dev/null)
  if [[ -n $current_branch ]]; then
    echo " \u$CODEPOINT_OF_AWESOME_GITHUB %{$fg_bold[blue]%}$current_branch%{$reset_color%}"
  fi
}

nodenv_prompt_info() {
  current_node=$(nodenv local 2> /dev/null)
  if [[ -n $current_node ]]; then
    echo "\u$CODEPOINT_OF_DEVICONS_NODEJS_SMALL \
%{$fg_bold[green]%}$current_node%{$reset_color%}"
  fi
}

setopt promptsubst

# Allow exported PS1 variable to override default prompt.
if ! env | grep -q '^PS1='; then
  PS1='${SSH_CONNECTION+"%{$fg_bold[green]%}%n@%m:"}%{$fg_bold[blue]%}%c%{$reset_color%}$(git_prompt_info)\
 $(nodenv_prompt_info)
%{$fg_bold[red]%}$(echo "\u$CODEPOINT_OF_AWESOME_REBEL") %{$reset_color%} '
fi
