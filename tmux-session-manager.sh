# By mehdi0xc, 2024q3
muxm() {
    local sessions
    sessions=$(tmux ls -F "#{session_name}" 2>/dev/null) || true
    sessions="[new session]
[kill sessions]
${sessions}"

    export FZF_DEFAULT_OPTS='--color=fg:#ffffff,hl:#20A0F0,fg+:#ffffff,hl+:#20A0F0,info:#20A0F0,prompt:#ffffff,pointer:#20A0F0,marker:#20A0F0'

    local session
    session=$(echo "$sessions" | fzf --height 40% --reverse)

    if [[ "$session" == '[new session]' ]]; then
        if [[ -n "$ZSH_VERSION" ]]; then
            vared -p 'Enter new session name: ' -c new_session
        else
            read -p 'Enter new session name: ' new_session
        fi
        tmux new-session -d -s "$new_session" '$(basename $SHELL)'
        tmux attach-session -t "$new_session"
    elif [[ "$session" == '[kill sessions]' ]]; then
        local kill_sessions
        kill_sessions=$(tmux ls -F "#{session_name}" 2>/dev/null | fzf --height 40% --multi --reverse)
        if [[ -n "$kill_sessions" ]]; then
            echo "$kill_sessions" | while read -r kill_session; do
                tmux kill-session -t "$kill_session"
            done
        fi
    else
        if [ -n "$session" ]; then
            tmux attach-session -t "$session"
        fi
    fi
}
