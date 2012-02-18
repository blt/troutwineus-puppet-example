# Imports all node definitions. In puppet, a 'node' is a machine type. Exact
# demarcation is left up to the user but determined by machine hostname. We'll
# use a mixture of 'type' and 'typeNumber', for instance, 'puppet' and 'db0'
# being exemplars of both methods, respectively.
import 'nodes.pp'

# Sets the shell path for all subsequent invocations requiring such a thing;
# it's not _strictly_ necessary to set this, but I prefer to be explicit when
# possible. It saves typing later as all subsequent Execs will pick up this path
# definition. Read more here:
# http://puppetcookbook.com/posts/set-global-exec-path.html
Exec {
  path => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
  logoutput => on_failure,
}
