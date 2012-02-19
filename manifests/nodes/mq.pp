node /^mq\d+\.troutwine\.us/ {
  include base, rabbitmq

  # The traut vhost RabbitMQ user and /traut vhost are are used by the traut
  # system daemon. /traut should be shared among multiple RabbitMQ users, where
  # the traut user _must_ be exclusive to the similarly named daemon.
  rabbitmq::resource::vhost { "${base::traut_vhost}":
    ensure => present,
  }
  rabbitmq::resource::user { "${base::traut_user}":
    require => Rabbitmq::Resource::Vhost["${base::traut_vhost}"],
    password => "${base::traut_pass}",
    ensure => present,
  }
  rabbitmq::resource::user::permissions { "${base::traut_user}":
    require => Rabbitmq::Resource::User["${base::traut_user}"],
    vhost => "${base::traut_vhost}",
    ensure => present,
  }

  # The git RabbitMQ user is used by the gitolite::resource::posthook to send
  # new code notifications over the /traut vhost.
  rabbitmq::resource::user { 'git':
    require => Rabbitmq::Resource::Vhost["${base::traut_vhost}"],
    password => "${base::gitolite_posthook_password}",
    ensure => present,
  }
  rabbitmq::resource::user::permissions { 'git':
    require => Rabbitmq::Resource::User['git'],
    vhost => "${base::traut_vhost}",
    ensure => present,
  }

}
