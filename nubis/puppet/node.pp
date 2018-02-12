# Install dependencies

class { 'nodejs':
  repo_url_suffix => '8.x',
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

# For EIP attach
package { 'awscli':
  ensure => 'latest'
}

file { "/etc/nubis.d/${project_name}":
    ensure => file,
    owner  => root,
    group  => root,
    mode   => '0755',
    source => 'puppet:///nubis/files/startup',
}

systemd::unit_file { "${project_name}.service":
  content => @("EOT")
[Unit]
Description=DAT Hypercored
Wants=basic.target
After=basic.target network.target

[Service]
Restart=on-failure
RestartSec=10s
User=${project_name}-data
Group=${project_name}-data
WorkingDirectory=/data/${project_name}

Environment=HOME=/data/${project_name}

ExecStart=/usr/bin/hypercored \
  --websockets \
  --port 3283 \


# Above line empty on purpose
[Install]
WantedBy=multi-user.target

EOT
} ~> service { $project_name:
  ensure => 'stopped',
  enable => true,
}

include nubis_discovery

nubis::discovery::service { $project_name:
  http      => 'http://localhost:3283',
}
