-module (dealer).

-behaviour (gen_event).

-export ([prepare_cards/0, start_link/0, start_game/0]).
-export ([init/1, handle_event/2]).

-record (game, {turns=[], battle=[]}).
-record (playerTurn, {player, card}).

start_link()->
	game_observer:add_handler(?MODULE,[]).

init([])->
	io:format("[Dealer:info] started ~n", []),
	{ok, #game{}}.

start_game() ->
	game:start_play().

handle_event({turned_three_cards, Cards, Player}, #game{battle=BattleCards}=State) ->
	io:format("[Dealer:info] cards turned ~p ~p ~n", [Player, Cards]),
	{ok, State#game{battle = BattleCards ++ Cards}};
handle_event({player_lost, Player}, State) ->
	io:format("[Dealer:info] game over ~p ~n", [Player]),
	{ok, State};
handle_event({turned_card, Card, Player}, #game{turns=T, battle=BattleCards}=State) ->
	io:format("[Dealer:info] card turned ~p ~p ~n", [Player, Card]),
  Turns = [#playerTurn{player = Player, card = Card} | T],

  case length(Turns) == 2 of
    false  ->
      {ok, State#game{turns=Turns}};
    true ->
      tryCompleteRound(Turns, BattleCards),
			game:start_play(),
			{ok, #game{}}
  end.

tryCompleteRound([Player1Turn, Player2Turn], BattleCards) ->
  #playerTurn{card = Card1, player = Player1}=Player1Turn,
  #playerTurn{card = Card2, player = Player2}=Player2Turn,

  case cards_deck:cards_equal(Card1, Card2) of
    true ->
      player:turn_three_cards(Player1),
      player:turn_three_cards(Player2);
    false ->
      case cards_deck:card_is_greater(Card1, Card2) of
        true ->
          player:won(Player1, [Card1, Card2] ++ BattleCards);
        _ ->
          player:won(Player2, [Card1, Card2] ++ BattleCards)
      end
  end.

prepare_cards() ->
  Deck_of_cards = shufle(),
  take(Deck_of_cards).

take(Deck) ->
  take(Deck, [], []).
take([], Acc1, Acc2) ->
  {Acc1, Acc2};
take([F | [S | T]], Acc1, Acc2) ->
  take(T, [F | Acc1], [S | Acc2]).

shufle() ->
  shufle(cards_deck:new_deck(),[]).
shufle([], Acc) ->
  Acc;
shufle(Deck, Acc) ->
  {First, [Head | Last]} = lists:split(rand:uniform(length(Deck)) -1, Deck),
  shufle(First ++ Last, [Head | Acc]).
