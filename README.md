# rakuna-session-redis

Redis-backed sessions for Rakuna and Webmachine!

# Description

Adds expiring session support to your Webmachine project, using Redis as a datastore. Provides basic get/set operations.

# Installation
`gem install rakuna-session-redis`

# Usage
`require 'rakuna/session/redis'`

```
class ExampleResource < Rakuna::Resource::Basic
  include Rakuna::Data::Redis
  include Rakuna::Session::Redis

  def session_id
    @session_id ||= request.cookies['OSESSIONID']
  end

  def output
    session.get 'foo'
  end
end
```

# Methods
  * `session.get(key)` returns the value of `key` for the current session.
  * `session.set(key, value)` sets the value of `key` for the current session to `value`.
  * `session.active?` returns true if the session is active (has not expired), false otherwise.
  * `session.renew(duration)` sets the session expiry to `duration` seconds from now, default `300`.



# Contributing
  * Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
  * Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
  * Fork the project.
  * Start a feature/bugfix branch.
  * Commit and push until you are happy with your contribution.
  * Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
  * Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

# License
[MIT](https://tldrlegal.com/license/mit-license)

# Contributors
  * [Chris Olstrom](https://colstrom.github.io/) | [e-mail](mailto:chris@olstrom.com) | [Twitter](https://twitter.com/ChrisOlstrom)
