class check_mk::allinone {
## Check_MK Settings and Options
#
  $version = '1.5.0p9-1'
  $workingdir = '/root/check_mk'
  $downloadsource = 'https://server/instanz/check_mk/agents'

  class { 'check_mk::download':
    # Debian/Ubuntu Agent (.deb)
    file1       => "${downloadsource}/check-mk-agent_${version}_all.deb",
    # CentOS/RedHat (.rpm)
    file2       => "${downloadsource}/check-mk-agent-${version}.noarch.rpm",
    destination => "${workingdir}/",
    workspace   => "${workingdir}",
    version     => "${version}",
  }

  class { 'check_mk::install':
    workspace   => "${workingdir}",
    version     => "${version}",
    require     => Class['check_mk::download'],
  }
  
  class { 'check_mk::config':
    port          => '6556',
    ip_whitelist  => '10.10.10.1 10.10.10.2',
    require       => Class['check_mk::install'],
  }
#
##
}
