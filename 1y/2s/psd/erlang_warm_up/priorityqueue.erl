-module(priorityqueue).
-export([create/0,enqueue/3,dequeue/1]).

create() -> 
  {[],[]}.

enqueue({Inorder,Reverse}, Item, Priority) ->
    case Inorder of
        [] -> {[{Item,Priority}],Reverse};
        [{H,P}|T] -> if P =< Priority -> 
            {I,R} = enqueue({T,Reverse},Item,Priority), {[{H,P}|I],R};
            true -> {[{H,P},{Item,Priority}|T],Reverse} 
        end
    end.

dequeue({Inorder,Reverse}) ->
    case Reverse of
        [] when Inorder == [] -> empty;
        [] -> [H|T] = reverse(Inorder), {H,{Inorder,T}};
        [Item|NewReverse] -> {Item, {Inorder,NewReverse}}
    end.

reverse(List) ->
    case List of 
      [] -> [];
      [H|T] -> reverse(T) ++ [H]
    end.    