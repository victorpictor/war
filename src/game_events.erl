-module (game_events).

-export ([turned_a_card/2, turned_three_cards/2, player_lost/1]).

turned_a_card(Player, Card) ->
	gen_event:notify(game_observer:ref(), {turned_card, Card, Player}).

turned_three_cards(Player, Cards) ->
	gen_event:notify(game_observer:ref(), {turned_three_cards, Cards, Player}).

player_lost(Player) ->
	gen_event:notify(game_observer:ref(), {player_lost, Player}).
