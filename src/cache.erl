-module(cache).
-author("Ivan Blinkov <ivan@blinkov.ru>").

-include("constants.hrl").

-export([
	start/0,
	set/2, set/3,
	get/1,
	incr/1, incr/2,
	del/1
]).

-spec start() -> ok.
start() ->
	application:start(ets_cache).

-spec set(Key :: any(), Value :: any()) -> ok.
set(Key, Value) ->
	set(Key, Value, undefined).

-spec set(Key :: any(), Value :: any(), Expiration :: integer()) -> ok.
set(Key, Value, Expiration) ->
	ExpireAfter = case Expiration of
		undefined -> undefined;
		Expiration when is_integer(Expiration) ->
			ets_cache_util:timestamp() + Expiration;
		_ -> undefined
	end,
	true = ets:insert(?DEFAULT_DATA_TABLE, {Key, Value, ExpireAfter}),
	ok.

-spec get(Key :: any()) -> any() | undefined.
get(Key) ->
	case ets:lookup(?DEFAULT_DATA_TABLE, Key) of
		[{_Key, Value, _Expiration}] -> Value;
		[] -> undefined
	end.

-spec incr(Key :: any()) -> integer() | undefined.
incr(Key) ->
	incr(Key, 1).

-spec incr(Key :: any(), Offset :: integer()) -> integer() | undefined.
incr(Key, Offset) ->
	try
		ets:update_counter(?DEFAULT_DATA_TABLE, Key, Offset)
	catch
		error:badarg ->
			ets:insert(?DEFAULT_DATA_TABLE, {Key, Offset, undefined}),
			Offset
	end.

-spec del(Key :: any()) -> ok.
del(Key) ->
	true = ets:delete(?DEFAULT_DATA_TABLE, Key),
	ok.