
-module(database_server).
-author("Adrian").

-behaviour(gen_server).

%% API
-export([start_link/0]).

-export([getDB/1,getDbTwo/1, store/2,delete/1]).

%% gen_server callbacks
-export([init/1,handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3] ).



-record(state, {}).

%%%===================================================================
%%%       Client call
%%%===================================================================
start_link() ->
  gen_server:start_link({local, ?MODULE},?MODULE, [], []).

store(NodeName , Comment)->
  gen_server:call({global,?MODULE} , {store, NodeName, Comment}).

getDB(NodeName)->
  gen_server:call({global,?MODULE} , {getDB, NodeName}).

getDbTwo(NodeName)->
  gen_server:call({global,?MODULE} , {getDbTwo, NodeName}).

delete(NodeName)->
  gen_server:call({global,?MODULE} , {delete,NodeName}).



%%%===================================================================
%%%     Call back functions
%%%===================================================================


init([]) ->
  process_flag(trap_exit , true),
  io:format("~p (~p) starting ............. ~n" , [{global ,?MODULE} , self()]),
  database_logic:initDB(),
  {ok,#state{}}.

%% Handle call for STORE DATA
handle_call({store , NodeName ,Comment}, _From, State) ->
  database_logic:storeDB(NodeName , Comment),
  io:format("Comment has been saved for ~p ~n" , [NodeName]),
  {reply, ok, State};
%% Handle call for GET ONE DATA
handle_call({getDB , NodeName} , _From , State) ->
  Comment  = database_logic:getDB(NodeName),
  lists:foreach(fun(CM)->
                  io:format("Recieved ~p ~n" , [CM])
                end, Comment),
  {reply,ok,State};

%% Handle call for GET MORE DATA
handle_call({getDbTwo , NodeName}, _From, State) ->
  Comment = database_logic:getTwoDB(NodeName),
  lists:foreach(fun(CM , CO)->
                  io:format("Recieeved ~p for Created on ~p ~n",[CM,CO])
                end,Comment),
  {reply, ok, State};


%% Handle call for DELETE DATA
handle_call({delete , NodeName}, _From ,State)->
  database_logic:deleteDB(NodeName),
  io:format("Data deleted for ~p ~n" , [NodeName]),
  {reply, ok, State};


handle_call(_Request, _From, State) ->
  {reply, ok, State}.


handle_cast(_Request, State) ->
  {noreply, State}.


handle_info(_Info, State) ->
  {noreply, State}.

terminate(_Reason, _State) ->
  ok.


code_change(_OldVsn, State, _Extra) ->
  {ok, State}.


