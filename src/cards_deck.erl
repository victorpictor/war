-module (cards_deck).

-export ([new_deck/0, cards_equal/2, card_is_greater/2]).

new_deck() ->
  [{X,Y} ||
    X <- [2,3,4,5,6,7,8,9,10,j,q,k,a],
    Y <- [dimond, clubs, spade, hearts]].

cards_equal({X,_}, {X,_}) ->
  true;
cards_equal(X, Y) ->
  false.

card_is_greater({a,_}, {a,_}) ->
  false;
card_is_greater({a,_}, {X,_}) ->
  true;
card_is_greater({k,_}, {q,_}) ->
  true;
card_is_greater({q,_}, {k,_}) ->
  false;
card_is_greater({A,_}, {B,_}) ->
  A>B.
