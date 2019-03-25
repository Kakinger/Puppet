class check_mk::download (
  $version      = undef,
  $workspace    = '/root/check_mk',
  $file1        = undef,
  $file2        = undef,
  $destination  = undef,    

) {
  if ! $version { fail('version must be specified.') }
  if ! defined(File[$workspace]) {
    file { $workspace:
      ensure => directory,
    }
  }
  
  # Suche nach Distribution
  case $::operatingsystem {
    'ubuntu', 'debian': {
      # Download von Agent File
      wget::fetch { "${file1}":
        destination        => "${destination}",
        timeout            => 10,
        verbose            => false,
        nocheckcertificate => true,
      }
    }
  'centos', 'redhat', 'scientific': {
    # Download von Agent File
    wget::fetch { "${file2}":
      destination        => "${destination}",
      timeout            => 10,
      verbose            => false,
      nocheckcertificate => true,
    }
  }
  default: { fail('Unrecognized operating system') }
  }

  case $::operatingsystem {
    'ubuntu', 'debian': {
      # Setzen von Dateirechten
      file { "${workspace}/check-mk-agent_${version}_all.deb":
        owner  => 'root',
        group  => 'root',
        mode   => '0764',
      }
    }
    'centos', 'redhat', 'scientific': {
      # Setzen von Dateirechten
      file { "${workspace}/check-mk-agent-${version}.noarch.rpm":
        owner  => 'root',
        group  => 'root',
        mode   => '0764',
      }
    }
    default: { fail('Unrecognized operating system') }
  }
}
