#
# ip_reverse
#

module Puppet::Parser::Functions
  newfunction(:ip_reverse, :type => :rvalue, :doc => <<-EOS
Transform an IP address into a reverse address
Example:
    ip_reverse($ipaddress6)
    ### djdns with ipv6 patch requires ipv6.int - http://www.fefe.de/dns/ ###
    # "1.0.0.0.0.0.0.0.0.0.0.0.1.0.0.0.b.4.0.0.1.0.2.0.8.f.4.0.1.0.a.2.ip6.arpa"
    ip_reverse($ipaddress)
    # "50.100.16.172.in-addr.arpa"
    EOS
  ) do |args|

    raise(Puppet::ParseError, "ip_reverse(): Wrong number of arguments " +
        "given (#{args.size} for 1)" ) if args.size != 1

    require 'ipaddr'
    ipaddr = IPAddr.new args[0]
    ipaddr_reverse = ipaddr.reverse()
    return ipaddr_reverse.to_s

  end
end
