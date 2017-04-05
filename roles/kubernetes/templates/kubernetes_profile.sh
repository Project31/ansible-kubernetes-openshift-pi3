# Shortcut
alias k=kubectl


source <(kubectl completion bash)
source <(kubectl completion bash | sed s/kubectl/k/g)
# complete -o default -F __start_kubectl k
