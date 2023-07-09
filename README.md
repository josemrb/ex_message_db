# ExMessageDB

[![Build Status](https://josemrb.semaphoreci.com/badges/ex_message_db.svg)](https://josemrb.semaphoreci.com/projects/ex_message_db) [![Hex Version](https://img.shields.io/hexpm/v/ex_message_db.svg?style=flat)](https://hex.pm/packages/ex_message_db)

An Elixir client for [Message DB](https://github.com/message-db/message-db).

## Installation

The package can be installed by adding `ex_message_db` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ex_message_db, "~> 0.1.0"}
  ]
end
```

## Configuration

ExMessageDB is an OTP Application and have to be configured by setting the parameters of the
`ExMessageDB.Repo` repo, so that it can connect to the database at start.

```elixir
# config/config.exs
config :ex_message_db, ExMessageDB.Repo,
  database: "message_store",
  username: "message_store",
  hostname: "localhost"
```

## Usage

The `ExMessageDB` module provides the methods to access the currently supported server functions.

### Supported Server Functions

- [x] write_message
- [x] get_stream_messages (partially)
- [x] get_category_messages (partially)
- [x] get_last_stream_message
- [ ] stream_version
- [ ] id
- [ ] cardinal_id
- [ ] category
- [ ] is_category
- [ ] acquire_lock
- [ ] hash_64
- [x] message_store_version

### Examples

```elixir
# write messages to stream "account-1"
iex> message1 = %{
  id: "5e731bdc-07aa-430a-8aae-543b45dd7235",
  stream_name: "account-1",
  type: "Created",
  data: %{name: "New Account"}
}
iex> ExMessageDB.write_message(message1)
{:ok, 0}

iex> message2 = %{
  id: "904ae0d1-8239-4ded-8c34-7bb7f7caefe3",
  stream_name: "account-1",
  type: "EmailAdded",
  data: %{email: "account@company.com"},
}
iex> ExMessageDB.write_message(message1)
{:ok, 1}

# get last message from stream "account-1"
iex> ExMessageDB.get_last_stream_message("account-1")
%{
  message: %ExMessageDB.Message{
    data: %{"email" => "account@company.com"},
    global_position: 2,
    id: "904ae0d1-8239-4ded-8c34-7bb7f7caefe3",
    metadata: nil,
    position: 1,
    stream_name: "account-1",
    time: ~N[2020-06-14 22:39:59.979582],
    type: "EmailAdded"
  }
}

# get messages from stream "account-1"
iex> ExMessageDB.get_stream_messages("account-1")
[
  %{
    message: %ExMessageDB.Message{
      data: %{"name" => "New Account"},
      global_position: 1,
      id: "5e731bdc-07aa-430a-8aae-543b45dd7235",
      metadata: nil,
      position: 0,
      stream_name: "account-1",
      time: ~N[2020-06-14 22:29:47.186470],
      type: "Created"
    }
  },
  %{
    message: %ExMessageDB.Message{
      data: %{"email" => "account@company.com"},
      global_position: 2,
      id: "904ae0d1-8239-4ded-8c34-7bb7f7caefe3",
      metadata: nil,
      position: 1,
      stream_name: "account-1",
      time: ~N[2020-06-14 22:39:59.979582],
      type: "EmailAdded"
    }
  }
]
```

The documentation can be found at [hexdocs](https://hexdocs.pm/ex_message_db/).

## Copyright and License

Copyright (c) 2020 Jose Miguel Rivero Bruno

The source code is licensed under [The MIT License (MIT)][license]

[license]: https://github.com/josemrb/ex_message_db/tree/master/LICENSE.md
