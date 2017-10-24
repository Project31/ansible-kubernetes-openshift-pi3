# Shortcut
alias k='kubectl "--context=${KUBECTL_CONTEXT:-$(kubectl config current-context)}" ${KUBECTL_NAMESPACE/[[:alnum:]-]*/--namespace=${KUBECTL_NAMESPACE}}'

source <(kubectl completion bash)
source <(kubectl completion bash | sed s/kubectl/k/g)
# complete -o default -F __start_kubectl k
