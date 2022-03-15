-module(myqueue).
-export([create/0,enqueue/2,dequeue/1]).

create() -> 
  {[],[]}.

enqueue({Inorder,Reverse}, Item) -> 
  {[Item|Inorder],Reverse} .

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