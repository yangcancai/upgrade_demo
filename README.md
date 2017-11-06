upgrade_demo
=====

step by step upgrade your application which programing by erlang

versions
---
- release-0.1.0
    - create proj
- release-0.1.1
    - add appup.src
    - add mnesia and create schema and table

Build
-----

    $ rebar3 compile

How to upgrade
-----
from release-0.1.0 to release-0.1.1

example:
```
     $git checkout release-0.1.0
     $rebar3 as prod tar
     $git chckout release-0.1.1
     $rebar3 as prod release
     $rebar3 as prod appup generate
     $cp _build/prod/lib/upgrade_demo/ebin/upgrade_demo.appup apps/upgrade_demo/src/upgrade_demo.appup.src
     $vim apps/upgrade_demo/src/upgrade_demo.appup.src %% add this line  {apply, {upgrade, update, ["0.1.0", "0.1.1"]}}
     $rebar3 as prod appup generate
     $rebar3 as prod rel tar
     $mkdir update
     $cp _build/prod/rel/upgrade_demo/upgrade_demo-0.1.0.tar.gz update
     $cd update
     $ tar -xvf upgrade_demo-0.1.0.tar.gz
     $bin/upgrade_demo start
     $cp ../upgrade_demo-0.1.1.tar.gz releases
     $bin/upgrade_demo upgrade 0.1.1
```
