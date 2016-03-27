
-module(factorial_client).
-author("Adrian").

-export([factorial/1, factorialRecorder/2,storeComment/2,getComment/1,getCommentWithStamp/1,deleteComment/1]).

factorial(Val)->
  facotiral_server:factorial(Val).

factorialRecorder(Val, IoDevice) ->
  factorial_server:factorial(Val, IoDevice).

storeComment(NodeName , Comment)->
  database_server:store(NodeName,Comment).

getComment(NodeName)->
  database_server:getDB(NodeName).

getCommentWithStamp(NodeName)->
  database_server:getDbTwo(NodeName).

deleteComment(NodeName)->
  database_server:delete(NodeName).