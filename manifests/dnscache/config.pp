class djbdns::dnscache::config inherits djbdns::dnscache::init {

    if $caller_module_name != $module_name {
        fail("Use of private class ${name} by ${caller_module_name}")
    }

    exec {
        "${dnscache_service_name}-setup":
            command => "${installpath}/bin/dnscache-conf ${dnscache_user} ${dnscache_group} ${supervise_dir}/${dnscache_service_name} ${dnscache_listen_address}",
            creates => "${supervise_dir}/${dnscache_service_name}/env/IP",
            require => File['/etc/dnsroots.global'];
    }

    file {
        "${supervise_dir}/${dnscache_service_name}/env/IP":
            ensure  => file,
            content => "${dnscache_listen_address}\n",
            require => Exec["${dnscache_service_name}-setup"];
        "${supervise_dir}/${dnscache_service_name}/root/servers/@":
            owner   => root,
            group   => root,
            mode    => '0644',
            content => template('djbdns/dnscache_all.conf.erb'),
            require => Exec["${dnscache_service_name}-setup"];

        "${supervise_dir}/${dnscache_service_name}/root/servers/in-addr.arpa":
            owner   => root,
            group   => root,
            mode    => '0644',
            content => template('djbdns/dnscache_all.conf.erb'),
            require => Exec["${dnscache_service_name}-setup"];

        "${supervise_dir}/${dnscache_service_name}/env/FORWARDONLY":
            owner   => root,
            group   => root,
            mode    => '0644',
            content => "1 \n",
            require => Exec["${dnscache_service_name}-setup"];

        ### Allow Private Networks ###
        "${supervise_dir}/${dnscache_service_name}/root/ip/10":
            ensure  => present,
            owner   => root,
            group   => root,
            mode    => '0600',
            require => Exec["${dnscache_service_name}-setup"];

        "${supervise_dir}/${dnscache_service_name}/root/ip/172.16.53":
            ensure  => present,
            owner   => root,
            group   => root,
            mode    => '0600',
            require => Exec["${dnscache_service_name}-setup"];

        "${supervise_dir}/${dnscache_service_name}/root/ip/127.0.0.1":
            ensure  => present,
            owner   => root,
            group   => root,
            mode    => '0600',
            require => Exec["${dnscache_service_name}-setup"];

        '/etc/dnsroots.global':
            ensure  => present,
            owner   => root,
            group   => root,
            mode    => '0644';
    }

}
