-module(ets_cache_util).
-author("Ivan Blinkov <ivan@blinkov.ru>").

-include("constants.hrl").

-export([
	timestamp/0
]).

-spec timestamp() -> integer().
timestamp() ->
	{Megaseconds, Seconds, _Microseconds} = os:timestamp(),
	Megaseconds * 1000000 + Seconds.



	