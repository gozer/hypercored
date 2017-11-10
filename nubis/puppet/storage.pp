include nubis_storage

nubis::storage { $project_name:
  type  => 'efs',
  owner => "${project_name}-data",
  group => "${project_name}-data",
}

# Create a user and a group for this
group { "${project_name}-data":
  ensure => 'present',
  gid    => '400',
}

user { "${project_name}-data":
  ensure  => 'present',
  uid     => '400',
  gid     => '400',
  home    => "/data/${project_name}",
  shell   => '/usr/sbin/nologin',
  require => [
    Group["${project_name}-data"],
  ],
}
