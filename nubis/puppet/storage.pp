# Create a user and a group for this
group { "${project_name}-data":
  ensure => 'present',
  gid    => '400',
}

user { "${project_name}-data":
  ensure  => 'present',
  uid     => '400',
  gid     => '400',
  home    => "/var/www/${project_name}",
  shell   => '/usr/sbin/nologin',
  require => [
    Group["${project_name}-data"],
  ],
}

file { '/var/www':
  ensure => 'directory',
  owner  => 'root',
  group  => 'root',
  mode   => '0775',
}

file { "/var/www/${project_name}":
  ensure  => 'directory',
  owner   => "${project_name}-data",
  group   => "${project_name}-data",
  mode    => '0770',
  require => [
    Group["${project_name}-data"],
    User["${project_name}-data"],
    File['/var/www'],
  ],
}

file { "/var/www/${project_name}/feeds":
  ensure  => 'file',
  owner   => 'root',
  group   => 'root',
  mode    => '0664',
  require => [
    Group["${project_name}-data"],
    User["${project_name}-data"],
    File["/var/www/${project_name}"],
  ],
}
