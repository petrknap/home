##################################################
#   Macros injection                             #
##################################################

MACROS_FILE=~/.bash_macros

if [ -f $MACROS_FILE ]
then
    . $MACROS_FILE
else
    echo "WARNING! $MACROS_FILE not found"
fi



##################################################
#   Your aliases                                 #
##################################################

alias ll='ls -alF'