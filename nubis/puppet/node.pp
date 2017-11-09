# Install dependencies

class { 'nodejs':
  repo_url_suffix => '6.x',
}

package { 'forever':
  ensure   => '0.15.3',
  provider => 'npm',
}

# Needed for binary compilation (i.e. bcrypt)s
package { 'hypercored':
  ensure   => '1.4.1',
  provider => 'npm',
}

# Create the service with upstart
include 'upstart'

upstart::job { $project_name:
    description    => 'DAT Hypercored',

    service_ensure => 'stopped',
    service_enable => true,

    # Never give up
    respawn        => true,
    respawn_limit  => 'unlimited',
    start_on       => '(local-filesystems and net-device-up IFACE!=lo)',
    chdir          => "/var/www/${project_name}",
    env            => {
      'HOME' => "/var/www/${project_name}",
    },
    user           => "${project_name}-data",
    group          => "${project_name}-data",
    exec           => "/usr/bin/forever --workingDir /var/www/${project_name} --minUptime 1000 --spinSleepTime 1000 /usr/bin/hypercored",
}