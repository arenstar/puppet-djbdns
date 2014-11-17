class djbdns::params {

  #### Default values for the parameters of the main module class, init.pp

  # ensure
  $ensure = 'present'

  # service status
  $status = 'enabled'


  #### Internal module values

  # User and Group for the files and user to run the service as.
  case $::kernel {
    'Linux': {
      $tinydns_user   = 'tinydns'
      $tinydns_group  = 'dnslog'
      $dnscache_user  = 'dnscache'
      $dnscache_group = 'dnslog'
    }
    default: {
      fail("\"${module_name}\" provides no user/group default value
           for \"${::kernel}\"")
    }
  }

  # Different path definitions
  case $::kernel {
    'Linux': {
      $supervise_dir = '/var/lib/svscan'
      $service_dir   = '/service'
      $installpath   = '/bin'
    }
    default: {
      fail("\"${module_name}\" provides no config directory default value
           for \"${::kernel}\"")
    }
  }

  # packages
  case $::operatingsystem {
    'RedHat', 'CentOS', 'Fedora', 'Scientific', 'Amazon', 'OracleLinux', 'SLC': {
      # main application
      $package = [ 'djbdns' ]
    }
    default: {
      fail("\"${module_name}\" provides no package default value
            for \"${::operatingsystem}\"")
    }
  }

  # service parameters
  case $::operatingsystem {
    'RedHat', 'CentOS', 'Fedora', 'Scientific', 'Amazon', 'OracleLinux', 'SLC': {
      $tinydns_service_name = 'tinydns'
      $tinydns_service_hasrestart = true
      $tinydns_service_hasstatus  = true
      $tinydns_listen_address = $ipaddress_lo
      $dnscache_service_name = 'dnscache'
      $dnscache_service_hasrestart = true
      $dnscache_service_hasstatus  = true
      $dnscache_listen_address = $ipaddress_lo
      $service_providers  = [ 'daemontools' ]
    }
    default: {
      fail("\"${module_name}\" provides no service parameters
            for \"${::operatingsystem}\"")
    }
  }

}
