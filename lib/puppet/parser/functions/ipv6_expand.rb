#
# ipv6_expand
#

module Puppet::Parser::Functions
  newfunction(:ipv6_expand, :type => :rvalue, :doc => <<-EOS
Transform a ipv6 ip into its full representation.
Example:
    ipv6_expand($ipaddress)
    # "2a01:04f8:0201:004b:0001:0000:0000:0001"
    EOS
  ) do |args|

    raise(Puppet::ParseError, "ipv6_expand(): Wrong number of arguments " +
        "given (#{args.size} for 1)" ) if args.size != 1

    require 'ipaddr'
    ipaddr = IPAddr.new args[0]
    ipaddr_expand = ipaddr.to_string
    ipaddr_expand = ipaddr_expand.gsub(':','')
    return ipaddr_expand.to_s

  end
end

