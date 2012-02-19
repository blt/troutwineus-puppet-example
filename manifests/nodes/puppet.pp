node 'puppet' {
  include base, puppet::master

  # This key is generated so that the root user can pull source slugs from the
  # slugbuilder. Note, however, that the public key is _not_ automatically
  # placed into the slugbuilder's authorized_keys and must be done so manually
  # with slugbuild::resource::authorized_key on the slugbuild node.
  user { 'root':
    ensure => present,
  }
  ssh::resource::key { 'id_rsa':
    root => '/root/.ssh/',
    ensure => present,
    user => 'root',
  }
  ssh::resource::known_hosts { 'root':
    root => '/root/.ssh/',
    hosts => 'git.troutwine.us',
    user => 'root',
  }

  # The slugbuild sync will, post-build, sync all available slugs to the local
  # machine using the credentials generated above.
  class { 'slugbuild::slugclient':
    ensure => present,
    mqpass => "${base::gitolite_posthook_password}",
    slughost => 'git.troutwine.us',
  }
  slugbuild::resource::sync { 'puppet-sync':
    project => 'puppet',
    ensure => present,
  }

  # Ensure that newly available puppet configuration slugs are mounted and
  # linked as /etc/puppet
  class { 'puppet::resource::redeploy':
    ensure => present,
  }
}
