chpwd() {
    ls_abbrev
}
ls_abbrev() {
    # -a : Do not ignore entries starting with ..
    # -C : Force multi-column output.
    # -F : Append indicator (one of */=>@|) to entries.
    local cmd_ls='ls'
    local -a opt_ls
    opt_ls=('-l' '--color=always')
    case "${OSTYPE}" in
        freebsd*|darwin*)
            if type gls > /dev/null 2>&1; then
                cmd_ls='gls'
            else
                # -G : Enable colorized output.
                opt_ls=('-lG')
            fi
            ;;
    esac

    local ls_result
    local ls_lines="$(ls -U1 | wc -l | tr -d ' ')"

    if [ $ls_lines -gt 100 ]; then
        echo "$ls_lines files exist"
    else 
        ls_result=$(CLICOLOR_FORCE=1 COLUMNS=$COLUMNS command $cmd_ls ${opt_ls[@]} | sed $'/^\e\[[0-9;]*m$/d')
        if [ $ls_lines -gt 10 ]; then
            echo "$ls_result" | head -n 5
            echo '...'
            echo "$ls_result" | tail -n 5
            echo "$ls_lines files exist"
        else
            echo "$ls_result"
        fi
    fi
}