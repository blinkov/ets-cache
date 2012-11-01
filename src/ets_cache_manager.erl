-module(ets_cache_manager).
-behaviour(gen_server).
-author("Ivan Blinkov <ivan@blinkov.ru>").

-include("constants.hrl").
-define(NAME, State#state.name).
-define(PAUSE, 1000).

-export([
	start_link/1
]).
-export([
	init/1,
	handle_call/3,
	handle_cast/2,
	handle_info/2,
	terminate/2,
	code_change/3
]).

-record(state, {
	name :: atom()
}).

start_link([Name]) ->
	gen_server:start_link({local, Name}, ?MODULE, [Name], []).

init([Name]) ->
	ets:new(Name, [
		named_table, 
		public,
		{read_concurrency, true},
		{write_concurrency, true}
	]),
	timer:send_after(?PAUSE, cleanup),
	{ok, #state{name = Name}}.

handle_call(_Request, _From, State) ->
	{reply, ok, State}.

handle_cast(_Msg, State) ->
	{noreply, State}.

handle_info(cleanup, State) ->
	ets:select_delete(?NAME, 
	[
		{
			{'_', '_', '$1'},
			[{'<', '$1', ets_cache_util:timestamp()}],
			[true]
		}
	]),
	timer:send_after(?PAUSE, cleanup),
	{noreply, State};

handle_info(_Info, State) ->
	{noreply, State}.

terminate(_Reason, _State) ->
	ok.

code_change(_OldVsn, State, _Extra) ->
	{ok, State}.