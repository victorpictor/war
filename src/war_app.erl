-module(war_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
  case war_sup:start_link() of
        {ok, Pid} ->
            game_observer:start_link(),
            dealer:start_link(),
            {ok, Pid};
        Other ->
            {error, Other}
  end.

stop(_State) ->
    ok.
