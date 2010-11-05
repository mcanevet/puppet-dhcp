/*

= Class dhcp::server::base
Do NOT include this class - it won't work at all.
Set variables for package name and so on.
This class should be inherited in dhcp::server::$operatingsystem.

*/
class dhcp::server::base {
  include dhcp::params
  package {"dhcp-server":
    ensure => present,
    name   => $dhcp::variables::srv_dhcpd,
  }

  service {"dhcpd":
    name    => $dhcp::variables::srv_dhcpd,
    ensure  => running,
    enable  => true,
    require => Package["dhcp-server"],
  }

  common::concatfilepart {"00.dhcp.server.base":
    file    => "${dhcp::variables::config_dir}/dhcpd.conf",
    ensure  => present,
    require => Package["dhcp-server"],
    notify  => Service["dhcpd"],
  }

  file {"dhcp-subnet-config-dir":
    path   => "${dhcp::variables::config_dir}/subnets",
    ensure => directory,
    require => Package["dhcp-server"],
    notify  => Service["dhcpd"],
    recurse => true,
    purge   => true,
    force   => true,
    source  => "puppet:///dhcp/empty"
  }

  file {"dhcp-config-dir":
    path   => "${dhcp::variables::config_dir}/hosts.d",
    ensure => directory,
    require => Package["dhcp-server"],
    recurse => true,
    purge   => true,
    force   => true,
    source  => "puppet:///dhcp/empty"
  }

}
