%%%-------------------------------------------------------------------
%%% @author cam
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 05. 十一月 2017 下午8:38
%%%-------------------------------------------------------------------
-module(lib_mnesia).
-author("cam").

%% API
-export([ensure_started/0]).
-define(M_UPGRADE, m_upgrade).
-record(m_upgrade,{key, value, epoch, count}).
ensure_started() ->
  ensure_mnesia_tables().
ensure_mnesia_tables() ->
    ensure_schema(),
    ensure_table(),
    wait_for_mnesia().

ensure_schema() ->
    case mnesia:table_info(schema, disc_copies) of
        [] ->
            mnesia:change_table_copy_type(schema, node(), disc_copies);
        _ ->
            ok
    end.

ensure_table() ->
    TableDef = [
    {type,set},
    {disc_copies,[node()]},
    {record_name, m_upgrade},
    {index, [#m_upgrade.epoch]},
    {attributes, record_info(fields, m_upgrade)}],
    case mnesia:create_table(?M_UPGRADE, TableDef) of
        {atomic, ok} ->
            ok;
        {aborted, {already_exists, ?M_UPGRADE}} ->
            ok
    end.

wait_for_mnesia() ->
    mnesia:wait_for_tables([?M_UPGRADE], infinity).