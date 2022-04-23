Script for iptables with module xt_quota2
====

Documentation

on file /etc/vars:

        1) (in, out, fwd)_chain : name chain has exist in filter table
        2) nq_q_chain and mode : chain if no quota and rules set by 'mode' var. defualt: drop
        3) extra_config : extra config for rules
        4) wan_device_name : device wan or wwan
        5) quota_bytes : bytes quota
        6) bytescounter : filepath to save counter 
        7) quota_time_mgr : enable quota active counting
        8) time_active_config : config -m time paramater 
        9) device_chain : device rule name (ex, wan ) (openwrt only)

scripts /etc/quota.d/*:

        1) iptables_init : init chain
        2) iptables_quota2 : init rules
        3) iptables_flush : flush rules and del chain
        4) reset_bytescounter : reset counter to quota_bytes var
        5) restore_bytescounter : restore counter from $bytescounter files pervent loss counting and reinit iptables
        6) save_bytescounter  : save counter to $bytescounter files
        7) update_bytescounter : update or change counter 
Using:

        crontab:
            config crontab schadule for /etc/quota.d/save_bytescounter and /etc/quota.d/reset_bytescounter, put to System->Scheduled Tasks or /etc/crontabs/quota
        iptables:
            /etc/quota.d/restore_bytescounter place to custom rules script on network->firewall->custom rules luci webadmin or /etc/firewall.user or /etc/init.d/firewall or make script for start it 

installing for OpenWRT:

    run install.sh install or uninstall 

note: if cannot use install.sh see above
