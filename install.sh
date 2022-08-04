#!/bin/sh

function modules_chk()
{
    if [ -z "`opkg info iptables-mod-quota2 | grep installed`" ]; then
        echo "installing iptables-mod-quota2"
        opkg update > /dev/null 2>&1

        nft --version > /dev/null 2>&1
        if [ $? -eq 0 ]; then
             local extra_module="xtables-nft iptables-nft ip6tables-nft kmod-ipt-quota2"
             export nft=1;
        fi

        opkg install $extra_module iptables-mod-quota2 > /dev/null 2>&1      
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
        cp ./etc/quota.d/* /etc/quota.d/
        chmod 755 /etc/quota.d/*
    fi

    if [ ! -e /etc/vars ]; then
        cp ./etc/vars /etc/vars
    fi 

    echo '*/10 * * * * /etc/quota.d/save_bytescounter' >> /etc/crontabs/root
    echo '1 0 * * * /etc/quota.d/reset_bytescounter' >> /etc/crontabs/root
    echo >> /etc/crontabs/root

    if [ -z $nft ]; then
        echo '/etc/quota.d/restore_bytescounter' > /etc/firewall.quota

        uci -q delete firewall.quota
        uci set firewall.quota="include"
        uci set firewall.quota.path="/etc/firewall.quota"
        uci set firewall.quota.reload="1"
        uci commit firewall
    fi

    /etc/init.d/firewall restart > /dev/null 2>&1
    /etc/init.d/cron restart > /dev/null 2>&1

    echo 'done.'
}

function uninstall() 
{
    rm -r /etc/quota.d
    rm /etc/vars

    nft --version > /dev/null 2>&1
    if [ $? -eq 1 ]; then 
        rm /etc/firewall.quota

        uci -q delete firewall.quota
        uci commit firewall
    fi

    /etc/init.d/firewall restart > /dev/null 2>&1
    /etc/init.d/cron restart > /dev/null 2>&1

    echo 'done.'
}

case $1 in
    install)
        install
    ;;
    uninstall)
        uninstall
    ;;
    *)
        echo "$0 install | uninstall"
    ;;
esac