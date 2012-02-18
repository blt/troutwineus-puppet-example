node /^mq\d+\.troutwine\.us/ {
  include base, rabbitmq

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

}
