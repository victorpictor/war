-module (player).

-behaviour (gen_server).

-export ([start_link/1, turn_a_card/1, turn_three_cards/1, won/2, lost/1]).
-export ([init/1, handle_cast/2, handle_info/2]).

-record (state, {player, cards = []}).

start_link([Name, Deck] = Args) ->
  gen_server:start_link({local, Name}, ?MODULE, Args, []).

turn_a_card(Player) ->
  gen_server:cast(Player, {turn_a_card}).
turn_three_cards(Player) ->
  gen_server:cast(Player, {turn_three_cards}).
won(Player, Cards) ->
  gen_server:cast(Player, {won_cards, Cards}).
lost(Player) ->
  gen_server:stop(Player).

init([Name, Deck]) ->
  io:format("[info] name ~p ~n", [Name]),
  {ok, #state{player= Name, cards= Deck}}.
handle_cast({won_cards, Cards}, #state{cards=CardsInHand}=State) ->
  io:format("[info] ~p won ~p ~n", [self(), Cards]),
  {noreply, #state{cards=CardsInHand ++ Cards}};
handle_cast({turn_a_card}, #state{cards=[]}= State) ->
  io:format("[info] ~p lost ~n", [self()]),
  game_events:player_lost(self()),
  {noreply, State};
handle_cast({turn_a_card}, #state{cards=[Next | RestOfCards]}= State) ->
  io:format("[info] ~p turning ~p ~n", [self(), Next]),
  game_events:turned_a_card(self(), Next),
  {noreply, #state{cards=RestOfCards}};
handle_cast({turn_three_cards}, #state{cards=Cards}=State) when length(Cards) >= 3 ->
  {ToBeTurned, Rest} = lists:split(3, Cards),
  game_events:turned_three_cards(self(), ToBeTurned),
  {noreply, #state{cards=Rest}};
handle_cast({turn_three_cards}, #state{cards=Cards}=State) ->
  %not enough cards
  {noreply, #state{cards=Cards}}.

handle_info(Message, State) ->
	{noreply, State}.
