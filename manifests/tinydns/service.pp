class djbdns::tinydns::service inherits djbdns::tinydns::init {

  #### Service management

  # set params: in operation
  if $ensure == 'present' {

    case $status {
      # make sure service is currently running, start it on boot
      'enabled': {
        $service_ensure = 'running'
        $service_enable = true
      }
      # make sure service is currently stopped, do not start it on boot
      'disabled': {
        $service_ensure = 'stopped'
        $service_enable = false
      }
      # make sure service is currently running, do not start it on boot
      'running': {
        $service_ensure = 'running'
        $service_enable = false
      }
      # do not start service on boot, do not care whether currently running
      # or not
      'unmanaged': {
        $service_ensure = undef
        $service_enable = false
      }
      # unknown status
      # note: don't forget to update the parameter check in init.pp if you
      #       add a new or change an existing status.
      default: {
        fail("\"${status}\" is an unknown service status value")
      }
    }

  # set params: removal
  } else {

    # make sure the service is stopped and disabled (the removal itself will be
    # done by package.pp)
    $service_ensure = 'stopped'
    $service_enable = false

  }

  # action
  service {
        $tinydns_service_name:
            ensure      => $service_ensure,
            enable      => $service_enable,
            hasstatus   => $tinydns_service_hasstatus,
            hasrestart  => $tinydns_service_hasrestart,
            provider    => $service_providers,
  }
}
