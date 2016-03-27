## Compiling OpenShift for ARM

* Check out OpenShift Origin

    ```
    git clone https://github.com/openshift/origin
    ```

* Select the version tag you want

    ```
    git co v1.1.4
    ```

  However, please note that the cross compile build only works on current master (because of [this](https://github.com/openshift/origin/commit/659ba8dadfeb25506a56da2f8a6bdc194ec4acc7) introduced lately).
  (So the step above is probably best used when on v1.1.5 or later)

* Startup Vagrant Developer VM

    ```
    cd origin
    vagrant up
    ```

* Enter VM

    ```
    vagrant ssh
    ```

* Temporily change the cross compile target platforms in `hack/commons.sh`. Change

    ```
    readonly OS_CROSS_COMPILE_PLATFORMS=(
      linux/amd64
      darwin/amd64
      windows/amd64
      linux/386
    )
    ```

  to

    ```
    readonly OS_CROSS_COMPILE_PLATFORMS=(
      linux/arm
    )
    ```

* Cross-compile run (for me currently `make build-cross` doesnt work)

    ```
    sudo bash -x hack/build-cross.sh
    ```

  The build will exit with an error because of some directories not setup correctly.
  The binaries has been successfully built, though.

* You then will find the cross compiled binaries in

    ```
    ls -l _output/local/bin/linux/arm/
    total 307744
    -rwxr-xr-x  1 roland  staff   51576136 Mar 27 11:33 oc
    -rwxr-xr-x  1 roland  staff  105987904 Mar 27 11:33 openshift
    ```

  These binaries are also available outside of the VM since the build dir was mounted by Vagrant.
