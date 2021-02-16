  if tmux list-windows -t "$(tmux display-message -p '#S')" | grep -q ": server";
  then
    tmux send-keys -t server C-c;
  fi
