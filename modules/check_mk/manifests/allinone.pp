class check_mk::allinone {
## Check_MK Settings and Options
#
  $version = '1.5.0p9-1'
  $workingdir = '/usr/src'
  $downloadsource = 'https://server/instanz/check_mk/agents'

  class { 'check_mk::install':
    # Debian/Ubuntu Agent (.deb)
    file1       => "${downloadsource}/check-mk-agent_${version}_all.deb",
    # CentOS/RedHat (.rpm)
    file2       => "${downloadsource}/check-mk-agent-${version}.noarch.rpm",
    workspace   => "${workingdir}",
    version     => "${version}",
  }
  
class { 'check_mk::config':
    port          => '6556',
    ip_whitelist  => '10.10.10.1 10.10.10.2',
    require       => Class['check_mk::install'],
  }
#
##
}
