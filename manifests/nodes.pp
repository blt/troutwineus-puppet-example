import 'nodes/*.pp'

# The base class acts as a repository for configuration common to all the more
# specific node definintions imported above.
class base {
  include supervisor, puppet
}
