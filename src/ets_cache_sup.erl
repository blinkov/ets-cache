-module(ets_cache_sup).
-behaviour(supervisor).
-author("Ivan Blinkov <ivan@blinkov.ru>").

-include("constants.hrl").

-export([
	start_link/0
]).
-export([
	init/1
]).

-spec start_link() -> {ok, Pid::pid()}.
start_link() ->
	supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init(_Args) ->
	{ok, 
		{
			{one_for_one, 10, 10},
			[get_child_spec(?DEFAULT_DATA_TABLE)]
		}
	}.

-spec get_child_spec(Name :: atom()) -> supervisor:child_spec().
get_child_spec(Name) ->
   {Name, {ets_cache_manager, start_link, [[Name]]},
     permanent, 5000, worker, [Name]}.