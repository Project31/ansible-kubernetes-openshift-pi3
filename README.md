## Ansible Playbook for Docker / Kubernetes / OpenShift on RaspberryPis 3

*This is work-in-progress, it might not work for you and things will change. Expect a Blog with more details soon.*

Here's a playground for setting up a Raspberry 3 cluster connected with WLAN and with Docker preinstalled.

[Ansible](https://www.ansible.com/) is used to install Kubernetes / OpenShift. So as single prerequisite (beside the Pi hardware of course ;-) is to have a working Ansible 2 installation on your Desktop. *Ansible is not required on the Pis*. The given Ansible playbooks are applied via SSH to the Pis. Ansbible can be easily installed, e.g. for OS X users its best done via `brew install ansible`.

### Basic Setup

To start use a plain Raspbian OS with WLAN support and connect it for the initial setup via Ethernet:

* Install [Raspbian Jessie Lite](https://www.raspberrypi.org/downloads/raspbian/) on a Micro SD card (Hypriot's [flash script](https://github.com/hypriot/flash) comes handy here)

* Connect via ethernet to your LAN and detect the IP (either via nmap or by checking your DHCP logs)
* SSH to the Pi and resize the disk

        ssh pi@1.2.3.4    # Use 'raspberry' as password
        $ sudo raspi-config
        # Select first menu item, then reboot

* Copy `config.yml.example` to `config.yml` and enter your WLAN SID and preshared key in the file. Add a hashed user password which is replacing 'raspberry' (use `mkpasswd` on a Linux system). But you can leave this out to keep the original password.
* Copy `setup-host.example` to `setup-host` and add the single IP
* Run

        ansible -i setup-host setup.yml -k

* Remove LAN cable and reboot. Your Pi should connect now to your WLAN router.
* Repeat steps for each Pi.


Copy over `hosts.example` to `hosts` and add all the WLAN IPs to this `hosts` file. Ideally your WLAN router has fixed IPs for your PIs configured when called via DHCP. Add these IPs to your hosts file later on in the Ansible group `pis`. Select a single IP as `master` and the rest for `nodes`. Don't forget to given everyone a `name`, the master node should carry also an `host_extra=master` attribute. See `hosts.example` for a full setup.

Now run

    ansible -i hosts setup.yml

to configure the initial cluster.

The hard stuff is done now.

### Install Kubernetes

* Then simply run

        ansible -i hosts kubernetes.xml

#### Features

* [Hypriot Docker packages](http://blog.hypriot.com/downloads/)
* `iperf` and `hdparm` for benchmarks installed ( + `mtr`)
* APT update
* Copy of `~/.ssh/id_dsa.pub` to `/home/pi/.ssh/authorized_keys`
* Setup of `/etc/hosts` with the IPs of all nodes (named `n0`, `n1`, `n2`, `n3`)
* Look into `tools/` for additional goodies.

#### To come

* Setting up OpenShift
* fabric8

#### Final words

Bear with me, that my first Ansible playbook ;-)

-------
