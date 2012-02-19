import 'nodes/*.pp'

# The base class acts as a repository for configuration common to all the more
# specific node definintions imported above.
class base {
  include supervisor, puppet, openssl

  # All machines _must_ have sshd running.
  class { 'ssh::resource::sshd':
    ensure => present,
  }

  # Ensure machine time is always synced to external reference. All system
  # defaults are acceptable.
  package { ntp: ensure => present, }
  # Include for libssl-dev for native rubygems that need SSL (EventMachine).
  package { 'libssl-dev': ensure => present, }
  # Require all machines to have rsync installed for various purposes.
  package { rsync: ensure => present, }

  # Without an internal DNS system, nor a pressing need for one until the
  # cluster grows substantially, set hostnames manually through /etc/hosts.
  host {
    'puppet.troutwine.us':
      ensure => present,
      ip => '192.168.56.11',
      host_aliases => 'puppet';
    'git.troutwine.us':
      ensure => present,
      ip => '192.168.56.12',
      host_aliases => 'git';
    'mq0.troutwine.us':
      ensure => present,
      ip => '192.168.56.13',
      host_aliases => 'mq0';
  }

  # Until there's a pressing need to construct a more traditional CA for
  # internal services, the puppet-openssl module can construct a primitive
  # one. The master will be placed on puppet, making that box _extremely_
  # sensitive to tampering. It was, of course, already _extremely_ sensitive to
  # tampering.
  if $hostname == 'puppet' {
    class { 'openssl::certmaster':
      ca_name => 'rabbitmq',
      ensure => present,
    }
  }
  Openssl::Server {
    ca_name => 'rabbitmq',
  }
  openssl::server {
    'mq0' : ensure => present;
  }
  Openssl::Client {
    ca_name => 'rabbitmq',
  }
  openssl::client {
    'puppet': ensure => present;
    'git'   : ensure => present;
    'mq0'   : ensure => present;
  }

  # The traut daemon which allows cron-like action in response to AMQP
  # messages. Here we install cron on all systems and enable a 'puppet agent
  # --test' event.
  $traut_vhost = '/traut'
  $traut_user  = 'traut'
  $traut_pass  = '264l8uSlCeZSGZiCQHns'
  $traut_key   = '/etc/rabbitmq/ssl/client/key.pem'
  $traut_chain = '/etc/rabbitmq/ssl/client/cert.pem'

  class { 'traut':
    ensure => present,
    vhost => $traut_vhost,
    host => 'mq0',
    username => $traut_user,
    password => $traut_pass,
    exchange => 'traut',
    debugging => true,
    version => '1.0.1',
    private_key => $traut_key,
    cert_chain => $traut_chain,
    require => File[$traut_key, $traut_chain],
    subscribe => File[$traut_key, $traut_chain],
  }
  include traut::hare
  traut::resource::event { 'puppet-agent':
    route => 'puppet.agent.invoke',
    command => '/usr/bin/puppet agent --test',
  }

  # All deployed source slugs will be distributed through read-only squashfs
  # filesystems. This package is required to give systems required user-land
  # tools. (Default kernels _must_ have squashfs modules available, which is
  # common since late 2009, early 2010.)
  package { 'squashfs-tools': ensure => present, }
  $gitolite_posthook_password = 'rM9sCVtS0qDJNz0p9XZf'
}
