%%%-------------------------------------------------------------------
%% @doc upgrade_demo top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module(upgrade_demo_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).
-export([start_player_sup/0]).
-export([stop_player_sup/0]).
-define(SERVER, ?MODULE).

%%====================================================================
%% API functions
%%====================================================================
start_player_sup() ->
    supervisor:start_child(?MODULE, child_spec(player_sup)).
stop_player_sup() ->
     ok = supervisor:terminate_child(?MODULE, player_sup),
     ok = supervisor:delete_child(?MODULE, player_sup).
child_spec(Mod) ->
    {Mod, {player_sup, start_link, []}, permanent, 2000, supervisor, [Mod]}.
start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

%%====================================================================
%% Supervisor callbacks
%%====================================================================

%% Child :: {Id,StartFunc,Restart,Shutdown,Type,Modules}
init([]) ->
    {ok, { {one_for_all, 0, 1}, [child_spec(player_sup)]} }.

%%====================================================================
%% Internal functions
%%====================================================================
