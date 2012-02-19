node 'git.troutwine.us' {
  include base

  # Install the gitolite daemon and provide the admin key.
  class { 'gitolite':
    gituser => 'git',
    admin_key => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC8/3r2cdr8mQBubErMCeUe61pj6/+pSStX842K/DBuw78bOAw5HuKCBLTRSGh8Mjz38hFWcmds5GvgqyOxukZmGJzdBPzahi62ED4kdVyHscjSLl2VVHvE++/JNeehl8FsRiVn96joCRYAe1aTpI+7nD8W9g1VuWfcKO1ycZAVp6xKlKurW7Hl5SKk5Eio8s09fDukj6ZTPfPQjgtGJPYBwlcKmvmzJuwTSu2YfqwpZk5ftKMUpY22XSqRd2hVmJMVL3d+ISff7lVWvqihskMJV5x1BmSW2N60jdzKd19hgTlLNmtvjzvdcy9NYh0V6V9HjNuLaZGKU1mzRzmlHXPb blt@doritos',
    path => '/var/lib/git',
  }

  # Ensure that on pushes into the 'puppet' git repository traut notifications
  # are sent out via the post-hook.
  gitolite::resource::posthook { 'puppet':
    mqpass => "${base::gitolite_posthook_password}",
  }

  class { 'slugbuild':
    ensure => present,
    githosts => 'git.troutwine.us,github.com',
    gitcentral => 'git.troutwine.us',
    mqpass => "${base::gitolite_posthook_password}",
  }
  slugbuild::resource::traut { 'puppet':
    ensure => present,
  }
  slugbuild::resource::authorized_key {
    'puppet root':
      ensure => present,
      key => 'AAAAB3NzaC1yc2EAAAADAQABAAACAQCrK88YYMEcswI0tcVDRNwAf8KbICFyiKP59k8poGHXGAn+yOlUeZfCtDFqf9pSNotISZL44Bh+TgWGcG11utphXnAjNO5EmFvi30PJRV8X3/gdrBR8GZHsPt9BzXu7JxSS/z4jmczzTsqTXRhe6HzfS0s+GNPhnPC9Iq/gHh2gwg1SBgl/a4s1mBVAzNyc0CZJcGEhAVrDCrQSjp3JFiNod8hhggr7QJeu4cJMbhBhX7S8Dbg9Qu2+/FSxHMcERQbtzI2S7zBp/W2cVho/kEE75I/YgkBbG1IG09wRQxNNmY6hSiwK+n1B8fKfS05HBfC9vTPC80arqZS52TF8rJWWp4voezE1wLQLJ6OQA3sPlhvzTQLDeJ/W+J92111R8MpzBgssk9p6hfuLzqNr//YCWjQzFFcAMev+bPUj76IwVArGNVNkDpx462XMRFZe5h6oTaMOtzr+AX3zzOar8mj1439B0fto8PQ+jb0U2d83sKTqsega/RiR7cv2cPFjWcGFL1xksSBDnVIv0R09Rk2d9h6JDI/U5QW2jcVFP01XbqXpGI/0ijMVgliwWMAxir4FPTrL8E8JsED4PEUBpVpCArZksQAX53HKCjAGQX+pzC2H6vYG3JHfRt8Gks7yFjXc8XrOP/+7Bf5Mmf3DErgTsTYX+MXNlldHQCO/SsEGPQ==';
  }

}
