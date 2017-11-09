class { '::fluentd':
  service_ensure => stopped
}

fluentd::configfile { $project_name: }

fluentd::source { 'node-output':
  configfile  => $project_name,
  type        => 'tail',
  format      => 'none',
  tag         => "forward.${project_name}.node.stdout",
  config      => {
    'read_from_head' => true,
    'path'           => "/var/log/upstart/${project_name}.log",
    'pos_file'       => "/var/log/upstart/${project_name}.pos",
  },
}
