class djbdns::dnscache::init (
    $ensure                       = $djbdns::params::ensure,
    $status                       = $djbdns::params::status,
    $dnscache_user                = $djbdns::params::dnscache_user,
    $dnscache_group               = $djbdns::params::dnscache_group,
    $supervise_dir                = $djbdns::params::supervise_dir,
    $service_dir                  = $djbdns::params::service_dir,
    $installpath                  = $djbdns::params::installpath,
    $package_name                 = $djbdns::params::package,
    $dnscache_service_name        = $djbdns::params::dnscache_service_name,
    $dnscache_service_hasrestart  = $djbdns::params::dnscache_service_hasrestart,
    $dnscache_service_hasstatus   = $djbdns::params::dnscache_service_hasstatus,
    $dnscache_listen_address      = $djbdns::params::dnscache_listen_address,
    $service_providers            = $djbdns::params::service_providers,
    $dnscache_servers             = $ipaddress_lo,

) inherits djbdns::params {

    # ensure
    if ! ($ensure in [ 'present', 'absent' ]) {
        fail("\"${ensure}\" is not a valid ensure parameter value")
    }
    # service status
    if ! ($status in [ 'enabled', 'disabled', 'running', 'unmanaged' ]) {
        fail("\"${status}\" is not a valid status parameter value")
    }

    Package <| title == $package_name |>

    if $_package_ensure == 'absent' or $_package_ensure == 'purged' {
        anchor { 'djbdns::dnscache::begin': }
        ~> class { 'djbdns::dnscache::service': }
        -> class { 'djbdns::dnscache::config': }
        -> class { 'djbdns::core': }
        -> anchor { 'djbdns::dnscache::end': }
    } else {
        anchor { 'djbdns::dnscache::begin': }
        -> class { 'djbdns::core': }
        -> class { 'djbdns::dnscache::config': }
        ~> class { 'djbdns::dnscache::service': }
        -> anchor { 'djbdns::dnscache::end': }
    }

}
