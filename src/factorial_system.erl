
-module(factorial_system).
-author("Adrian").

-behaviour(application).
-author("Adrian").
% application
-export([start/0, start/2, stop/1, stop/0]).


%%% application:stop(factorial_application).
%%% application:start(factorial_application).
start() ->
  io:format("fuck ~p ~n" , [?MODULE]),
  application:start(?MODULE).

% application callbacks
start(_Type, _Args) ->
  %% Start top level supervisor
  factorial_supervisor:start_link().


stop() ->
  mnesia:stop(),

  application:stop(?MODULE).

stop(_State) ->
  %% Otp will take care of this
  ok.

