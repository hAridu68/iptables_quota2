#!/bin/sh

function modules_chk()
{
    if [ -z "`opkg info iptables-mod-quota2 | grep installed`" ]; then
        echo "installing iptables-mod-quota2"
        opkg update > /dev/null 2>&1
        opkg install iptables-mod-quota2 > /dev/null 2>&1
    fi
    if [ -z "`lsmod | grep xt_quota2`" ]; then
        modprobe xt_quota2
    fi
}

function install()
{
    modules_chk

    if [ ! -d /etc/quota.d ]; then
        mkdir -p /etc/quota.d
        cp ./quota.d/* /etc/quota.d/
        chmod 755 /etc/quota.d/*
    fi

    if [ ! -e /etc/quota.d ]; then
        cp ./var /etc/vars
        chmod 755 /etc/vars
    fi 

    echo '*/10 * * * * /etc/quota.d/save_bytescounter' > /etc/crontabs/quota
    echo '1 0 * * * /etc/quota.d/reset_bytescounter' >> /etc/crontabs/quota
    echo >> /etc/crontabs/quota
}

function uninstall() 
{
    rm -r /etc/quota.d
    rm /etc/vars
    rm /etc/crontabs/quota
}

case $1 in
    install)
        install
    ;;
    uninstall)
        uninstall
    ;;
esac