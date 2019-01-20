-module (game).

-behaviour (supervisor).

-export ([start_link/0, start_play/0]).

-export ([init/1]).

start_link() ->
	supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init(Args) ->
  {First_deck, Second_deck} = dealer:prepare_cards(),

  Player1Config = {player1, {player, start_link, [[denis, First_deck]]}, temporary, brutal_kill, worker, [player]},
  Player2Config = {player2, {player, start_link, [[victor, Second_deck]]}, temporary, brutal_kill, worker, [player]},

  Restart = {one_for_one, 0, 1},

  {ok, {Restart, [Player1Config, Player2Config]}}.

start_play() ->
	player:turn_a_card(whereis(denis)),
	player:turn_a_card(whereis(victor)).
