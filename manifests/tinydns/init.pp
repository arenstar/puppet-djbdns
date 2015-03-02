class djbdns::tinydns::init (
    $ensure                     = $djbdns::params::ensure,
    $status                     = $djbdns::params::status,
    $tinydns_user               = $djbdns::params::tinydns_user,
    $tinydns_group              = $djbdns::params::tinydns_group,
    $supervise_dir              = $djbdns::params::supervise_dir,
    $service_dir                = $djbdns::params::service_dir,
    $installpath                = $djbdns::params::installpath,
    $package_name               = $djbdns::params::package_name,
    $tinydns_service_name       = $djbdns::params::tinydns_service_name,
    $tinydns_service_hasrestart = $djbdns::params::tinydns_service_hasrestart,
    $tinydns_service_hasstatus  = $djbdns::params::tinydns_service_hasstatus,
    $tinydns_listen_address     = $djbdns::params::tinydns_listen_address,
    $service_providers          = $djbdns::params::service_providers,

) inherits djbdns::params {

    # ensure
    if ! ($ensure in [ 'present', 'absent' ]) {
        fail("\"${ensure}\" is not a valid ensure parameter value")
    }
    # service status
    if ! ($status in [ 'enabled', 'disabled', 'running', 'unmanaged' ]) {
        fail("\"${status}\" is not a valid status parameter value")
    }

    if $_package_ensure == 'absent' or $_package_ensure == 'purged' {
        anchor { 'djbdns::tinydns::begin': }
        -> class { 'djbdns::tinydns::service': }
        -> class { 'djbdns::tinydns::config': }
        -> anchor { 'djbdns::tinydns::end': }
    } else {
    anchor { 'djbdns::tinydns::begin': }
        -> class { 'djbdns::tinydns::config': }
        -> class { 'djbdns::tinydns::service': }
        -> anchor { 'djbdns::tinydns::end': }
    }

    if ! defined(Package["$package_name"]) {
        package {
           $package_name:
                ensure => installed,
        }
    }

}
