ets-cache
=========

Convenient Erlang caching on top of ETS
## Features
* [Memcached](http://memcached.org/)-like API
* As thin as possible wrapper around ETS
* Support for arbitrary keys and values
* Set operation can specify expiration time after which value will be invalidated
* No external dependencies

## Public API

    cache:start().
    cache:set(Key, Value, Expiration).
    cache:get(Key).
    cache:incr(Key, Offset).
    cache:del(Key).

* **Key** and **Value** - arbitrary terms
* **Expiration** and **Offset** - integers, optional
## Internals
* Application consists of single supervised **gen_server**, which perioadically checks cached data for expiration
* Clients perform operations directly with data ETS table, which is public and with read/write concurrency

## Future Plans
* Expand the API to be a subset of [Redis API](http://redis.io/commands)
* Allow to use separate namespaces
* Cleanup when memory used exceeds some threshold