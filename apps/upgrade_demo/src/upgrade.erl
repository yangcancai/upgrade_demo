%%%-------------------------------------------------------------------
%%% @author cam
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 05. 十一月 2017 下午8:36
%%%-------------------------------------------------------------------
-module(upgrade).
-author("cam").

%% API
-export([update/2]).

update("0.1.0", "0.1.1") ->
  lib_mnesia:ensure_started();
update("0.1.1", "0.1.0") ->
  ok;
update("0.1.1", "0.1.2") ->
  {ok, _} = upgrade_demo_sup:start_player_sup();
update("0.1.2", "0.1.1") ->
  upgrade_demo_sup:stop_player_sup().
