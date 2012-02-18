node 'git' {
  include base

  class { 'gitolite':
    gituser => 'git',
    admin_key => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC8/3r2cdr8mQBubErMCeUe61pj6/+pSStX842K/DBuw78bOAw5HuKCBLTRSGh8Mjz38hFWcmds5GvgqyOxukZmGJzdBPzahi62ED4kdVyHscjSLl2VVHvE++/JNeehl8FsRiVn96joCRYAe1aTpI+7nD8W9g1VuWfcKO1ycZAVp6xKlKurW7Hl5SKk5Eio8s09fDukj6ZTPfPQjgtGJPYBwlcKmvmzJuwTSu2YfqwpZk5ftKMUpY22XSqRd2hVmJMVL3d+ISff7lVWvqihskMJV5x1BmSW2N60jdzKd19hgTlLNmtvjzvdcy9NYh0V6V9HjNuLaZGKU1mzRzmlHXPb blt@doritos',
    path => '/var/lib/git',
  }
}
