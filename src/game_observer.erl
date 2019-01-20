-module (game_observer).

-export ([ref/0, start_link/0, add_handler/2, remove_handler/2]).

ref()->
	?MODULE.

start_link() ->
	gen_event:start_link({local, ?MODULE}).

add_handler(Handler, Args) ->
	gen_event:add_handler(?MODULE, Handler, Args).

remove_handler(Handler, Args) ->
	gen_event:delete_handler(?MODULE, Handler, Args).
