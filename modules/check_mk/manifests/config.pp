class check_mk::config (
  $ip_whitelist = undef,
  $port         = '6556',
) {
  if ! $ip_whitelist { fail('Bitte Whitelist eintragen!') }
  
  $xinetd_file = $::osfamily ? {
    # Alter Pfad, aktuell nur ein Pfad vorhanden (default)
    # 'RedHat' => '/etc/xinetd.d/check-mk-agent',
    default  => '/etc/xinetd.d/check_mk',
  }

  file { $xinetd_file:
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0444',
    content => template('check_mk/check_mk.erb'),
    notify  => Exec['xinetd_restart'],
  }
  
    exec { 'xinetd_restart':
      command         => '/bin/systemctl restart xinetd',
      refreshonly     => true,
    }
}
