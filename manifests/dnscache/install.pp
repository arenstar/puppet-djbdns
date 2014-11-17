class djbdns::dnscache::install inherits djbdns::dnscache::init {

    include djbdns::core

    Package <| title == $package_name |>

}
