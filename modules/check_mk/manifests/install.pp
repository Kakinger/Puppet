class check_mk::install (
  $version      = undef,
  $workspace    = '/usr/src',
  $package      = undef,
  $file1        = undef,
  $file2        = undef,

) {
  if ! defined(Package['xinetd']) {
    package { 'xinetd':
      ensure => present,
    }
  }
  if ! $version { fail('version must be specified.') }
  if ! defined(File[$workspace]) {
    file { $workspace:
      ensure => directory,
    }
  }
  # Suche nach Distribution
  case $::operatingsystem {
    'ubuntu', 'debian': {
      # Installation von Agenten
      exec {'download_install_checkmk_dpm' :
        path    => ['/usr/bin','/usr/sbin','/bin','/sbin',],
        command => "/usr/bin/wget --no-check-certificate ${file1} -P ${workspace}/;dpkg -i ${workspace}/check-mk-agent_${version}_all.deb",
        unless  => "dpkg-query -l check-mk-agent | grep ${version}",
      }
    }
    'centos', 'redhat', 'scientific': {
      # Installation von Agenten
      exec {'download_install_checkmk_rpm' :
        path    => ['/usr/bin','/usr/sbin','/bin','/sbin',],
        command => "/usr/bin/wget --no-check-certificate ${file2} -P ${workspace}/;yum localinstall -y ${workspace}/check-mk-agent-${version}.noarch.rpm",
        unless  => "yum list installed check-mk-agent | grep ${version}",
      }
    }
    default: { fail('Unrecognized operating system') }
  }
}
