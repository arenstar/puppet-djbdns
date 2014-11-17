class djbdns::tinydns::install inherits djbdns::tinydns::init {

    include djbdns::core

    Package <| title == $package_name |>

}
