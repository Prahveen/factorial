-module(factorial_server).
-author("Adrian").


%% Let the compiler know this is a gen_server
%% Must implement the functions
-behaviour(gen_server).

%% User interface grouping
-export([start_link/0,factorial/1,stop/0,factorial/2]).

%% Gen_Server
-export([init/1 ,handle_call/3 , handle_cast/2, handle_info/2, terminate/2,code_change/3]).

%% ====================================================================
%% 			Client Call Functions
%% ====================================================================

start_link() ->
  gen_server:start_link({local, ?MODULE},?MODULE, [], []).

stop() ->
  gen_server:cast({global,?MODULE},stop).


factorial(Val) ->
  gen_server:call({global,?MODULE},{factorial,Val}).

factorial(Val,IoDevice) ->
  gen_server:call({global,?MODULE} , {factorial,Val, IoDevice}).



%% ====================================================================
%% 			Call Back Functions
%% ====================================================================

init([])->
  process_flag(trap_exit,true),
  io:format("~p (~p) starting.... ~n", [{local,?MODULE},self()]),
  {ok,[]}.

handle_call({factorial,Val},_From,State) ->
  {reply,factorial_logic:factorial(Val, 1), State};

handle_call({factorial,Val,IoDevice},_From,State) ->
  {reply,factorial_logic:factorial(Val, 1,IoDevice), State};


handle_call(_Request,_From,State) ->
  {reply,i_don_t_know, State}.


handle_cast(_Request,State) ->
  {noreply,State}.

handle_info(Info,State) ->
  {noreply,Info, State}.

terminate(_reason,_State) ->
  io:format("terminating ~p ~n" , [{local,?MODULE}]),
  ok.

code_change(_OldVersion,State,_Extra) ->
  {ok,State}.

