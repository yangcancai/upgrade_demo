%%%-------------------------------------------------------------------
%%% @author cam
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. 十一月 2017 下午11:51
%%%-------------------------------------------------------------------
-module(player).
-author("cam").

-behaviour(gen_server).

%% API
-export([start_link/1]).

%% gen_server callbacks
-export([init/1,
  handle_call/3,
  handle_cast/2,
  handle_info/2,
  terminate/2,
  code_change/3]).

-define(SERVER, ?MODULE).
-export([start_player/1]).
-export([stop_player/1]).
-record(state, {id, from}).

%%%===================================================================
%%% API
%%%===================================================================
start_player(Id) when is_integer(Id)->
  case supervisor:start_child(player_sup, [Id]) of
    {ok, Pid} ->
      {ok, Pid} ;
    {error,{already_started, Pid}} ->
      {ok, Pid}
  end.

stop_player(Id) when is_integer(Id) ->
  gen_server:call(name(Id), stop).
%%--------------------------------------------------------------------
%% @doc
%% Starts the server
%%
%% @end
%%--------------------------------------------------------------------
-spec(start_link(Id :: integer()) ->
  {ok, Pid :: pid()} | ignore | {error, Reason :: term()}).
start_link(Id) ->
  gen_server:start_link({local, name(Id)}, ?MODULE, [Id], []).

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Initializes the server
%%
%% @spec init(Args) -> {ok, State} |
%%                     {ok, State, Timeout} |
%%                     ignore |
%%                     {stop, Reason}
%% @end
%%--------------------------------------------------------------------
-spec(init(Args :: term()) ->
  {ok, State :: #state{}} | {ok, State :: #state{}, timeout() | hibernate} |
  {stop, Reason :: term()} | ignore).
init([Id]) ->
  {ok, #state{id = Id}}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling call messages
%%
%% @end
%%--------------------------------------------------------------------
-spec(handle_call(Request :: term(), From :: {pid(), Tag :: term()},
    State :: #state{}) ->
  {reply, Reply :: term(), NewState :: #state{}} |
  {reply, Reply :: term(), NewState :: #state{}, timeout() | hibernate} |
  {noreply, NewState :: #state{}} |
  {noreply, NewState :: #state{}, timeout() | hibernate} |
  {stop, Reason :: term(), Reply :: term(), NewState :: #state{}} |
  {stop, Reason :: term(), NewState :: #state{}}).
handle_call(call, _From, State) ->
  timer:sleep(5000),
  io:format("~p ~n",[call_here]),
  {reply, call, State};
handle_call(stop, From, State) ->
  {stop, normal, State#state{from = From}};
handle_call(_Request, _From, State) ->
  {reply, ok, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling cast messages
%%
%% @end
%%--------------------------------------------------------------------
-spec(handle_cast(Request :: term(), State :: #state{}) ->
  {noreply, NewState :: #state{}} |
  {noreply, NewState :: #state{}, timeout() | hibernate} |
  {stop, Reason :: term(), NewState :: #state{}}).
handle_cast(_Request, State) ->
  {noreply, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling all non call/cast messages
%%
%% @spec handle_info(Info, State) -> {noreply, State} |
%%                                   {noreply, State, Timeout} |
%%                                   {stop, Reason, State}
%% @end
%%--------------------------------------------------------------------
-spec(handle_info(Info :: timeout() | term(), State :: #state{}) ->
  {noreply, NewState :: #state{}} |
  {noreply, NewState :: #state{}, timeout() | hibernate} |
  {stop, Reason :: term(), NewState :: #state{}}).
handle_info(_Info, State) ->
  {noreply, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% This function is called by a gen_server when it is about to
%% terminate. It should be the opposite of Module:init/1 and do any
%% necessary cleaning up. When it returns, the gen_server terminates
%% with Reason. The return value is ignored.
%%
%% @spec terminate(Reason, State) -> void()
%% @end
%%--------------------------------------------------------------------
-spec(terminate(Reason :: (normal | shutdown | {shutdown, term()} | term()),
    State :: #state{}) -> term()).
terminate(Reason, #state{from = undefined}) ->
   io:format(" terminate => ~p ~n",[Reason]) ,
  ok;
terminate(normal , #state{from = From}) ->
  %% do some terminate
  gen:reply(From, terminated),
  ok.


%%--------------------------------------------------------------------
%% @private
%% @doc
%% Convert process state when code is changed
%%
%% @spec code_change(OldVsn, State, Extra) -> {ok, NewState}
%% @end
%%--------------------------------------------------------------------
-spec(code_change(OldVsn :: term() | {down, term()}, State :: #state{},
    Extra :: term()) ->
  {ok, NewState :: #state{}} | {error, Reason :: term()}).
code_change("0.1.3", State, _Extra) ->
  upgrade:update("0.1.2", "0.1.3"),
  {ok, State};
code_change({down, "0.1.2"}, State, _Extra) ->
  upgrade:update("0.1.3", "0.1.2"),
  {ok, State}.


%%%===================================================================
%%% Internal functions
%%%===================================================================
-spec name(Id :: integer()) -> atom().
name(Id) ->
  erlang:list_to_atom(lists:concat([?MODULE,"_", Id])).
