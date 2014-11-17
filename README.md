puppet-djbdns
================

This module can be used to:
* install djbdns
* manage tinydns data files

### Automatic DNS population ###

Note: You need to enable PuppetDB or storeconfigs to allow host defs to create their own dnsrecords & have the dns master node pull them all in.

For storeconfigs, in your puppetmaster (v2.6+) config (mine's at /etc/puppet/puppet.conf):
```ini
[master]
  storeconfigs = true
  thin_storeconfigs = true
  dbadapter = postgresql
  dbuser = puppet
  dbpassword = password
  dbserver = localhost
  dbname = puppet
```

Set up a postgresql (or mysql) db backend to store configs.

See also: http://docs.puppetlabs.com/guides/exported_resources.html & http://projects.puppetlabs.com/projects/puppet/wiki/Using_Stored_Configuration

##  Usage ##

### tinydns Installation
```puppet
  class { 'djbdns::tinydns::init': }
```

### dnscache Installation
```puppet
  class { 'djbdns::dnscache::init': }
```

#### NS record
Per http://cr.yp.to/djbdns/tinydns-data.html

```puppet
    dnsrecord {
      "example.com NS & A":
        ensure => present,
        fqdn   => "example.com",
        ipaddr => "10.1.1.1",
        type   => ".",
        notify => Exec["rebuild-tinydns-data"]
    }
```

#### A/PTR pair for each host:
By virtue of the resources under lib/, adding the following per server definition creates an A/PTR pair:
```puppet
    @@dnsrecord {
      "dns for $fqdn":
        ensure => "present",
        fqdn   => "$fqdn",
        ipaddr => "$ipaddress",
        type   => "=",
        ttl    => 300,
        notify => Exec["rebuild-tinydns-data"];
    }
```

#### AAAA/PTR  record - ( only if package used has been patched for ipv6 support )
```puppet
    @@dnsrecord {
      "puppet.example.com AAAA":
        ensure => present,
        fqdn   => "puppet.example.com",
        ipaddr => "1234:5678:90ab::cdef",
        type   => "6",
        ttl    => 300,
        notify => Exec["rebuild-tinydns-data"]
    }
```

#### Manual A record
```puppet
    @@dnsrecord {
      "puppet.example.com A":
        ensure => present,
        fqdn   => "puppet.example.com",
        ipaddr => "10.1.1.5",
        type   => "+",
        notify => Exec["rebuild-tinydns-data"]
    }
```

#### Reverse lookups for your subnet
With this, the `type => '='/'6'` attribute will auto-create the forward (A/AAAA) and reverse (PTR)

```puppet
    dnsrecord {
      "10.1.1.0/24 PTRs":
        ensure => present,
        fqdn   => "1.1.10.in-addr.arpa",
        ipaddr => "10.1.1.1",
        host   => example.com
        type   => ".",
        notify => Exec["rebuild-tinydns-data"];
    }
```

#### alias (not CNAME!)
Define alternate names for a host like this.

Usually define these in a host's def

(Note: an Alias points to an IP, a CNAME points to another name.  Choose wisely.)
```puppet
    @@dnsrecord {
      "alias.example.com alias":
        ensure => present,
        fqdn   => "puppet.example.com",
        ipaddr => "10.1.1.8",
        type   => "+",
        notify => Exec["rebuild-tinydns-data"]
    }
```
#### Slurp in all the @@dnsrecord entries

On the master dns server's host def add this:
```puppet
Dnsrecord <<| |>>
```

### Take Note

function - ip_reverse()
https://github.com/arenstar/puppet-djbdns/blob/master/lib/puppet/parser/functions/ip_reverse.rb

function - ipv6_expand()
https://github.com/arenstar/puppet-djbdns/blob/master/lib/puppet/parser/functions/ipv6_expand.rb


### Original project
Some of this project (the resource defs, mostly) is based on https://github.com/boinger/puppet-djbdns.git
