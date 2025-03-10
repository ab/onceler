![Onceler House](http://i.imgur.com/5TAkSCI.jpg)

# Onceler

The Onceler listens to your secrets and shares them exactly once.

    You won't see the Once-ler.
    Don't knock at his door.
    He stays in his Lerkim on top of his store.
    He lurks in his Lerkim, cold under the roof,
    where he makes his own clothes
    out of miff-muffered moof.
    And on special dank midnights in August,
    he peeks
    out of the shutters
    and sometimes he speaks
    and tells how the Lorax was lifted away.

            He'll tell you, perhaps....
            if you're willing to pay.

# Installing and Running

## Dependencies

Since Onceler stores secrets in volatile memory, it has no external
dependencies and no database. This extreme simplicity makes it very portable
and easy to deploy anywhere, but it also means that you can run only one app
process at a time. So Onceler is not appropriate for high traffic use.

Onceler is written in Ruby. It requires Ruby >= 3.0.
All Ruby library dependencies are listed in the [Gemfile](./Gemfile).

[Rbenv](https://github.com/rbenv/rbenv) provides a convenient way to manage
installations of multiple Ruby versions.

## Running the app

Install ruby, either via rbenv or a system package manager.

Then install gem dependencies:

```sh
bundle install
```

Start the application:

```sh
# Usage: serve [BIND_ADDR] [BIND_PORT]

# Listen only on localhost
bin/serve

# Listen on all network interfaces
bin/serve 0.0.0.0
```
