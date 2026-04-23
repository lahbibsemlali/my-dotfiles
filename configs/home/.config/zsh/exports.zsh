export EDITOR="nvim"

export ANDROID_HOME=$HOME/Android/sdk
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$ANDROID_HOME/emulator

# pipx and other user-local CLIs (~/.local/bin)
typeset -U path PATH
path=("$HOME/.local/bin" $path)
