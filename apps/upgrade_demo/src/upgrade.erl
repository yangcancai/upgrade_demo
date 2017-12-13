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
  upgrade_demo_sup:stop_player_sup();

update("0.1.2", "0.1.3") ->
  F = fun({m_upgrade, Key, Value, Epoch}) -> {m_upgrade , Key, Value, Epoch, 0};
    (Other) -> Other end,
  {atomic, ok} = mnesia:transform_table(m_, F, [key, value, epoch, count]);

update("0.1.3", "0.1.2") ->
  F = fun({m_upgrade, Key, Value, Epoch, _Count}) -> {m_upgrade , Key, Value, Epoch};
    (Other) -> Other end,
  {atomic, ok} = mnesia:transform_table(m_, F, [key, value, epoch]);

update(_OldVsn, _NewVsn) ->
  ok.