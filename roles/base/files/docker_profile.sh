function docker_nuke() {
    docker stop $(docker ps -q) >/dev/null 2>&1
    docker rm $(docker ps -q -a) >/dev/null 2>&1
    docker rmi $(docker images -qaf 'dangling=true') >/dev/null 2>&1
    docker volume rm $(docker volume ls -qf dangling=true) >/dev/null 2>&1
}

function docker_rmi_none() {
    docker rmi $(docker images -qaf 'dangling=true')
}

function docker_rmi_all() {
   docker images | grep $1 | perl -n -e '@a = split; print "$a[0]:$a[1]\n"' | xargs docker rmi
}
