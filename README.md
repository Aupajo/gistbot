GistBot
=======

Setup
-----

Just alter `config.yml`:
  
    nick: GistBot
    server: irc.freenode.net
    port: 6667

make sure you have the [isaac gem](http://github.com/ichverstehe/isaac):

    sudo gem install isaac --source http://gemcutter.org

and run:

    ruby gistbot.rb

Usage
-----

### Private messages

Any private messages sent to GistBot will be created as private gists.

    /msg GistBot turn me into a private gist please!

While in a private messaging session, if you want to invite GistBot to a channel, you can use `!invite` like this:

    !invite #gist

If you want GistBot to leave at any time, you can use `!leave` (also needs to be in a private message)

    !leave #gist

### Channel

To add a gist when GistBot is in your channel, you can use `!gist`:

    !gist Hey this is going to be turned into a gist

To log the last few lines of chat into a gist:

    !gist log 10 # This logs the last 10 lines of the chat into a gist

Licence
-------

If you use it, and you like it, and you feel inclined, and you know me in person, buy me a beer sometime.