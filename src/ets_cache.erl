-module(ets_cache).
-behavior(application).
-author("Ivan Blinkov <ivan@blinkov.ru>").

-include("constants.hrl").

-export([
	start/2,
	stop/1
]).

start(_Type, _Args) ->
	ets_cache_sup:start_link().

stop(_State) ->
	ok.