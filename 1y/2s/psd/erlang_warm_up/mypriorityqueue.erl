-module(mypriorityqueue).
-export([create/0,enqueue/3,dequeue/1]).

create() -> maps:new().

enqueue(Queues, Item, Priority) ->
    Fun = fun(OldV) -> myqueue:enqueue(OldV,Item) end,
    case maps:find(Priority,Queues) of
        error -> maps:put(Priority,myqueue:create(),Queues);
        _ -> true
    end,
    maps:update_with(Priority,Fun,Queues).

dequeue(Queues) -> 
   case maps:keys(Queues) of
     [] -> Queues;
     Keys -> Min = lists:min(Keys), dequeue(Queues, Min)
   end.

dequeue(Queues, Priority) ->
    case maps:find(Priority,Queues) of
        {ok,Queue} -> {Item,NewQueue} = myqueue:dequeue(Queue), {Item, maps:put(Priority,NewQueue,Queues)};
        error -> dequeue(Queues,Priority+1)
    end.
