-module(chatv3).
-export([start_server/1]).

start_server(Port) ->
  {ok, LSock} = gen_tcp:listen(Port, [binary, {active, once}, {packet, line},
                                      {reuseaddr, true}]),
  DefaultRoom = spawn(fun()-> room([]) end),
  register(default_room, DefaultRoom),
  spawn(fun() -> acceptor(LSock, DefaultRoom) end),
  ok.

acceptor(LSock, Room) ->
  {ok, Sock} = gen_tcp:accept(LSock),
  spawn(fun() -> acceptor(LSock, Room) end),
  Room ! {enter, self()},
  user(Sock, Room).



room(Pids) ->
  receive
    {enter, Pid} ->
      io:format("user entered~n", []),
      room([Pid | Pids]);
    {line, Data} = Msg ->
      io:format("received ~p~n", [Data]),
      [Pid ! Msg || Pid <- Pids],
      room(Pids);
    {leave, Pid} ->
      io:format("user left~n", []),
      room(Pids -- [Pid])
  end.

user(Sock, Room) ->
  Self = self(),
  receive
    {line, {Self, _}} -> % {line, {Self, Data}} ->
      inet:setopts(Sock, [{active, once}]),
      %gen_tcp:send(Sock, Data),
      user(Sock, Room);
    {line, {_, Data}} ->
      gen_tcp:send(Sock, Data),
      user(Sock, Room);
    {tcp, _, Data} ->
      case Data of 
        <<"\\room " , NewRoomBinRaw/binary>> ->
            NewRoomBin = string:trim(NewRoomBinRaw),
            NewRoomAtom = binary_to_atom(NewRoomBin), 
            NewRoom = create_room_if_absent(NewRoomAtom), 
            Room ! {leave, self()},
            NewRoom ! {enter, self()},
            inet:setopts(Sock, [{active, once}]),
            user(Sock,NewRoom);
        _ -> 
          Room ! {line, {Self, Data}}, user(Sock, Room)
      end;
    {tcp_closed, _} ->
      Room ! {leave, self()};
    {tcp_error, _, _} ->
      Room ! {leave, self()}
  end.


create_room_if_absent(NewRoomName) ->
  case whereis(NewRoomName) of 
    undefined -> 
      NewRoom = spawn(fun()-> room([]) end),
      register(NewRoomName, NewRoom),
      NewRoom;
    Pid -> Pid
  end.