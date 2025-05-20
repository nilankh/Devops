# Setup fzf
# ---------
if [[ ! "$PATH" == */home/laborant/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/home/laborant/.fzf/bin"
fi

eval "$(fzf --bash)"
