**Installing from Git Repo**

```
git clone git@github.com:louismullie/treat.git
cd treat
rake treat:install
```

The ``rake treat:install`` command will open an installer that lets you customize the dependencies you want to include in your installation. You can specify a language to install dependencies for by putting it in brackets after the install command (English is default). For example, you can use ``rake treat:install[french]``.

**Installing as a Gem**

Run `gem install treat`.

Then, open an `irb` session and type:

```ruby
require "treat"
Treat.install(:english)
```