Script iptables_quota2 untuk impelmentasi iptables quota2

Doc:
    on file /etc/vars
        1) (in, out, fwd)_chain : name chain has exist in filter table
        2) (in, out, fwd)_q_chain : chain quota rules
        3) nq_q_chain and mode : chain noquota rules and rules set on 'mode' var. defualt: drop
        4) extra_config : extra config for rules
        5) wan_device_name : device wan or wwan
        6) quota_bytes : bytes quota
        7) bytescounter : filepath to save counter 
        8) qouta_time_mgr : enable quota active counting
        9) time_active_config : config -m time paramater 
    scripts /etc/quota.d/*
        1) iptables_init : init chain
        2) iptables_quota2 : init rules
        3) iptables_flush : flush rules and del chain
        4) reset_bytescounter : reset counter to quota_bytes var
        5) restore_bytescounter : restore counter from $bytescounter files pervent loss counting and reinit iptables
        6) save_bytescounter  : save counter to $bytescounter files
        7) update_bytescounter : update or change counter 
    Using on openwrt:
        crontab:
            /etc/quota.d/save_bytescounter and /etc/quota.d/reset_bytescounter to System->Scheduled Tasks or /etc/crontabs
        iptables:
            /etc/quota.d/restore_bytescounter place to custom rules script on network->firewall->custom rules luci webadmin or /etc/firewall.user or /etc/init.d/firewall       
        