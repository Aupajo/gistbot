GistBot
=======

Setup
-----

Just alter the config block:

    config do |c|
      c.nick    = "GistBot"
      c.server  = "irc.freenode.net"
      c.port    = 6667
    end

and run:

  ruby gistbot.rb

Usage
-----

### Private messages

Any private messages sent to GistBot will be created as private gists.

    /msg GistBot turn me into a private gist please!

While in a private messaging session, if you want to invite GistBot to a room, you can use `!invite` like this:

    !invite #gist

If you want GistBot to leave at any time, you can use `!leave` (also needs to be in a private message)

    !leave #gist

### Channel

To add a gist when GistBot is in your channel, you can use `!gist`:

    !gist Hey this is going to be turned into a gist

