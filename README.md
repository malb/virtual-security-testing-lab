# Virtual Security Testing Lab

Simple &amp; boring virtual machines for security testing. These are offered as an optional, run-it-at-home environment for students in course [IY5610](https://www.royalholloway.ac.uk/isg/documents/pdf/coursespecs(msc)/modules201415/iy5610securitytestingspec1415.pdf) of the [Information Security MSc](https://www.royalholloway.ac.uk/isg/prospectivestudents/prospectivestudents-msc/home.aspx) at Royal Holloway, University of London.

## Building this lab

Check out this repository to a disk with a lot of space:

    git clone https://github.com/malb/virtual-security-testing-lab.git
    cd virtual-security-testing-lab

Download [Metasploitable 2](http://sourceforge.net/projects/metasploitable/files/Metasploitable2/metasploitable-linux-2.0.0.zip/download) from Sourceforge. Unpack the file `Metasploiable2.vmdk` into the directory `packer/metasploitable/`.

Build using [packer](https://packer.io):

    $(cd packer/kali; packer build kali-2-amd64.json)
    $(cd packer/metasploitable; packer build metasploitable2.json)
    $(cd packer/debian-lenny; packer build debian-lenny-5.0.10-amd64-netinst.json)
    $(cd packer/damn-vulnerable-node-application; packer build dvna-ubuntu-15.10-amd64.json)

This will produce four files

- `kali-2-amd64_virtualbox.box` our tester
- `metasploitable2-virtualbox.box` a really weak target
- `debian-lenny-5.0.10-amd64.box` a host target
- `dvna-ubuntu-15.10-amd64.box` a web target

We then have to import those into [Vagrant](https://www.vagrantup.com). Note that we’re using those names in our `Vagrantfile`:

    $(cd packer/kali; vagrant box add --name kali      kali-2-amd64-virtualbox.box)
    $(cd packer/metasploitable; vagrant box add --name metasploitable2 metasploitable2-virtualbox.box)
    $(cd packer/debian-lenny; vagrant box add --name debian-lenny debian-lenny-5.0.10-amd64-virtualbox.box)
    $(cd packer/damn-vulnerable-node-application; vagrant box add --name dvna ubuntu-15.10-amd64.box)

## Running this lab

To start the lab, issue:

    cd vagrant
    vagrant up

You can now login to the tester instance:

    vagrant ssh tester-kali

## Credit

## Kali 2 `packer/kali`

This is [Kali 2.0](https://www.kali.org/) (`kali-linux-full`) with all X11, GUI and LaTeX stuff stripped to save space. Kali would not accept my `preseed.cfg` so we start from [Debian 8](https://www.debian.org/News/2015/20150426) on which Kali is built and upgrade to Kali from there. Debian 8 installer based on [pjkundert/cpppo](https://github.com/pjkundert/cpppo/tree/master/packer/debian-8-amd64).

## Metasploitable  `packer/metasploitable`

This is [Metasploitable 2](http://r-7.co/Metasploitable2) based on [waratek/vagrant-boxes](https://github.com/waratek/vagrant-boxes.git).

## Debian Lenny `packer/debian-lenny` ##

Debian 5.0.10 based on [lxhunter/packer-templates](https://github.com/lxhunter/packer-templates/tree/master/templates/debian).

## DVNA `packer/damn-vulnerable-node-application` ##

[DVNA](https://github.com/quantumfoam/DVNA) based on [kaorimatz/packer-templates](https://github.com/kaorimatz/packer-templates/).

## Contributing

Yes, please! I’m lazy and loads of stuff isn’t as polished as it should be. Also, feel free to open issues.
