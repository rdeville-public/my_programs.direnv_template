  if tmux list-windows -t $(tmux display-message -p '#S') | grep -q ": server";
  then
    clear;
    tmux send-keys -t server "mkdocs serve" C-m;
  fi;
