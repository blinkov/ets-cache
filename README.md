ets-cache
=========

Convenient Erlang caching on top of ETS
## Features
* As thin as possible wrapper around ETS
* Support for arbitrary keys and values
* Set operation can specify expiration time after which value will be invalidated

## Public API

    cache:set(Key, Value, Expiration).
    cache:get(Key).
    cache:incr(Key).
    cache:del(Key).

## Internals
* Application consists of single supervised **gen_server**, which perioadically checks cached data for expiration
* Clients perform operations directly with data ETS table, which is public and with read/write concurrency

## Future Plans
* Expand the API to be a subset of [Redis API](http://redis.io/commands)
* Allow to use separate namespaces
* Cleanup when memory used exceeds some threshold