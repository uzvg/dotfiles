function _show_correct { print -u1 -R "➡  CORRECT: $1" }
function _show_warning { print -u1 -R "➡  WARNING: $1" }
function _show_error { print -u2 -R "➡  ERROR: $1" }
# Edit config file with `chezmoi edit`
function _chezmoi_edit() {
  chezmoi edit --apply $1
	if [ -N $1 ]; then
	  exec zsh
		_show_correct "$1 reloaded successfully!"
	fi
}

