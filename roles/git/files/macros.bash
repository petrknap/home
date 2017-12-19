git() {
    if [ "$1" == "help" ] && [ "$2" == "" ]
    then
        command git "$@"
        command echo ""
        command echo "Macros:"
        command echo "   git branch --clear <branch>"
        command echo "      Locally deletes branches which are merged to <branch>."
    elif [ "$1" == "branch" ] && [ "$2" == "--clear" ]
    then
        if [ "$3" == "" ]
        then
            command echo "ERROR!"
            command echo "    You must specify branch as 3rd parameter."
        else
            MERGED_TO="$3"
            for MERGED_BRANCH in `command git branch --merged "$MERGED_TO" | grep -v "$MERGED_TO" | grep -v "master" | grep -v "*"`
            do
                read -p "Are you sure you would like to delete $MERGED_BRANCH merged to $MERGED_TO? [Y/n] " CHOICE
                if [ "$CHOICE" == "Y" ] || [ "$CHOICE" == "y" ] || [ "$CHOICE" == "" ]
                then
                    command git branch --delete "$MERGED_BRANCH"
                fi
            done
        fi
    else
        command git "$@"
    fi
}
