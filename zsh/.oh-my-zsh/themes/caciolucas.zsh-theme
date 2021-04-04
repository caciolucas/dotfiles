# user, host, full path, and time/date
# on two lines for easier vgrepping
# entry in a nice long thread on the Arch Linux forums: https://bbs.archlinux.org/viewtopic.php?pid=521888#p521888
PROMPT=$'%{\e[0;34m%}%B┌─[%b%{\e[0m%}%{\e[1;32m%}%n%{\e[1;34m%}@%{\e[0m%}%{\e[0;36m%}%m%{\e[0;34m%}%B]%b%{\e[0m%} - %b%{\e[0;34m%}%B[%b%{\e[1;37m%}%~%{\e[0;34m%}%B]%b%{\e[0m%} 
%{\e[0;34m%}%B└─%B[%{\e[1;35m%}$%{\e[0;34m%}%B]%{\e[0m%}%b '
parse_git_state() {
	# Show different symbols as appropriate for various Git repository states
	# Compose this value via multiple conditional appends.
	local GIT_STATE=""
	local NUM_AHEAD="$(git log --oneline @{u}.. 2> /dev/null | wc -l | tr -d ' ')"
	if [ "$NUM_AHEAD" -gt 0 ]; then
		# GIT_STATE=$GIT_STATE${GIT_PROMPT_AHEAD//NUM/$NUM_AHEAD}
		GIT_STATE=$GIT_STATE${GIT_PROMPT_AHEAD}${NUM_AHEAD}
	fi
	local NUM_BEHIND="$(git log --oneline ..@{u} 2> /dev/null | wc -l | tr -d ' ')"
	if [ "$NUM_BEHIND" -gt 0 ]; then
		GIT_STATE=$GIT_STATE${GIT_PROMPT_BEHIND}${NUM_BEHIND}
	fi
	local GIT_DIR="$(git rev-parse --git-dir 2> /dev/null)"
	if [ -n $GIT_DIR ] && test -r $GIT_DIR/MERGE_HEAD; then
		GIT_STATE=$GIT_STATE$GIT_PROMPT_MERGING
	fi
	if [[ -n $(git ls-files --other --exclude-standard 2> /dev/null) ]]; then
		GIT_STATE=$GIT_STATE$GIT_PROMPT_UNTRACKED
	fi
	if ! git diff --quiet 2> /dev/null; then
		GIT_STATE=$GIT_STATE$GIT_PROMPT_MODIFIED
	fi
	if ! git diff --cached --quiet 2> /dev/null; then
		GIT_STATE=$GIT_STATE$GIT_PROMPT_STAGED
	fi
	if [[ -n $GIT_STATE ]]; then
		echo "$GIT_PROMPT_PREFIX$GIT_STATE$GIT_PROMPT_SUFFIX"
	fi
}

git_prompt_string() {
	local git_where="$(parse_git_branch)"

	# If inside a Git repository, print its branch and state
	[ -n "$git_where" ] && [ "$git" ] && \
		echo "$(parse_git_state)$GIT_PROMPT_PREFIX%{$fg[yellow]%}${git_where#(refs/heads/|tags/)}$GIT_PROMPT_SUFFIX" || \
		echo " %(?..%{$fg[red]%}[%{$fg[magenta]%}%?%{$fg[red]%}])"
}


git="true"
PS2=$' \e[0;34m%}%B>%{\e[0m%}%b '
local RPROMPT='$(git_prompt_string) ${ret_status}%{$reset_color%} [%*] '

RPROMPT='[%*]'
