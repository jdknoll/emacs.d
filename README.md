# A reasonable Emacs config

This is my emacs configuration tree, continually used and tweaked
since 2000, and it may be a good starting point for other Emacs
users, especially those who are web developers. These days it's
somewhat geared towards OS X, but it is known to also work on Linux
and Windows.

Emacs itself comes with support for many programming languages. This
config adds improved defaults and extended support for the following:

* Ruby / Ruby on Rails
* CSS / LESS / SASS / SCSS
* HAML / Markdown / Textile / ERB
* Clojure (via nrepl)
* Javascript / Coffeescript
* Python
* PHP
* Haskell
* Erlang
* Common Lisp (with Slime)

In particular, there's a nice config for *tab autocompletion*, and
flycheck is used to immediately highlight syntax errors in Ruby, HAML,
Python, Javascript, PHP and a number of other languages.

## Requirements

* Emacs 23 or greater (note that Emacs 24 is required for some
  functionality, and will likely become the minimum required version
  some time soon.)

## Installation

To install, clone this repo to `~/.emacs.d`, i.e. ensure that the
`init.el` contained in this repo ends up at `~/.emacs.d/init.el`:

```
git clone https://github.com/jdknoll/emacs.d.git
```

Upon starting up Emacs for the first time, further third-party
packages will be automatically downloaded and installed.

## Important note about `ido`

This config enables `ido-mode` completion in the minibuffer wherever
possible, which might confuse you when trying to open files using
<kbd>C-x C-f</kbd>, e.g. if you want to open a directory to use
`dired` -- if you get stuck, use <kbd>C-f</kbd> to drop into the
regular `find-file` prompt. (You might want to customize the
`ido-show-dot-for-dired` variable if this is an issue for you.)

## Updates

Update the config with `git pull`. You'll probably also want/need to update
the third-party packages regularly too:

<kbd>M-x package-list-packages</kbd>, then <kbd>U</kbd> followed by <kbd>x</kbd>.

## Adding your own customization

To add you own customization, use <kbd>M-x customize</kbd> and/or
create your own init files `~/.emacs.d/lisp/init-custom.el` which looks like this:

```el
... your code here ...

(provide 'init-custom)
```

Alternatively, fork the repo and hack away at the config to make it your own!

## Similar configs

You might also want to check out `emacs-starter-kit` `graphene`, and `emacs-prelude`.

## Important note

The process of making purcell's emacs.d is still in progress. The eventual goal is to
be able to remove any of the `(require init-file)` lines without breaking the startup
in order to allow emacs users to add functionality as they need it.

This may be a long process as purcell's init.el contained references to 59 files.

## Benchmarking
As you add modules, you may find that starting emacs can take a while. You can benchmark
your init with [Profile Dot Emacs](http://www.emacswiki.org/emacs/ProfileDotEmacs). In order
to profile the startup file, you will need to change `prfile-dotemacs-file` from `"~/.emacs"`
to `"~/.emacs.d/init.el"`.

## Support / issues

If you hit any problems, please first ensure that you are using the latest version
of this code, and that you have updated your packages to the most recent available
versions (see "Updates" above). If you still experience problems, go ahead and
[file an issue on the github project](https://github.com/purcell/emacs.d).

-Steve Purcell

<hr>

[![](http://api.coderwall.com/purcell/endorsecount.png)](http://coderwall.com/purcell)

[![](http://www.linkedin.com/img/webpromo/btn_liprofile_blue_80x15.png)](http://uk.linkedin.com/in/stevepurcell)
