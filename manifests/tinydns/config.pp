class djbdns::tinydns::config inherits djbdns::tinydns::init {

    exec {
        "${tinydns_service_name}-setup":
            command => "${installpath}/bin/tinydns-conf ${tinydns_user} ${tinydns_group} ${supervise_dir}/${tinydns_service_name} ${tinydns_listen_address}",
            creates => "${supervise_dir}/${tinydns_service_name}/env/IP";
    }

    file {
        "${supervise_dir}/${tinydns_service_name}/env/IP":
            ensure  => file,
            content => "${tinydns_listen_address}\n",
            require => Exec["${tinydns_service_name}-setup"];        
    }
    file {
        "${supervise_dir}/${tinydns_service_name}/root/Makefile":
            ensure  => present,
            owner   => root,
            group   => root,
            mode    => '0644',
            content => template('djbdns/Makefile.tinydns.erb'),
            require => Exec["${tinydns_service_name}-setup"];
    }
    exec {
        "rebuild-tinydns-data":
            cwd         => "${supervise_dir}/${tinydns_service_name}/root",
            command     => "/usr/bin/make data.cdb",
            refreshonly => true,
            require     => [
                Exec["${tinydns_service_name}-setup"],
                File["${supervise_dir}/${tinydns_service_name}/root/data"]
            ];
    }
    file {
       "${supervise_dir}/${tinydns_service_name}/root/data":
           ensure  => "present",
           replace => "no",
    }
}
