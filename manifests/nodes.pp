import 'nodes/*.pp'

# The base class acts as a repository for configuration common to all the more
# specific node definintions imported above.
class base {
  package { ntp: ensure => present, }
  package { 'libssl-dev': ensure => present, }

  include supervisor, puppet, openssl

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
    private_key => $traut_key,
    cert_chain => $traut_chain,
    require => File[$traut_key, $traut_chain],
    subscribe => File[$traut_key, $traut_chain],
  }
  include traut::hare

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

  traut::resource::event { 'puppet-agent':
    route => 'puppet.agent.invoke',
    command => '/usr/bin/puppet agent --test',
  }
}
