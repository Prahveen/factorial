
-module(database_logic).
-author("Adrian").
-include_lib("stdlib/include/qlc.hrl").
%% API
-export([initDB/0,getDB/1, getTwoDB/1,storeDB/2,deleteDB/1]).

-record(factorial , {nodeName , comment,createdOn}).

initDB() ->
  mnesia:create_schema([node()]),
  mnesia:start(),
  try
      mnesia:table_info(type,factorial)
  catch
      exit: _ ->
          mnesia:create_table(factorial , [{attributes , record_info(fields , factorial)},
            {type,bag},
            {disc_copies , [node()]}
      ])
  end.

storeDB(NodeName , Comments) ->
  AF = fun()->
    {   CreatedOn, _} =calendar:universal_time(),
        mnesia:write(#factorial{nodeName = NodeName ,comment = Comments , createdOn = CreatedOn})
       end,
  mnesia:transaction(AF).

getDB(NodeName) ->
    AF = fun()->
            Query = qlc:q([X || X <- mnesia:table(factorial),
              X#factorial.nodeName =:= NodeName]),
            Results = qlc:e(Query),

            lists:map(fun(Item)-> Item#factorial.comment end,Results)
         end,
            {atomic , Comments} = mnesia:transaction(AF),
            Comments.

getTwoDB(NodeName)->
    AF = fun()->
            Query = qlc:q([X||X <- mnesia:table(factorial),
              X#factorial.nodeName =:= NodeName]),
            Results = qlc:e(Query),

            lists:map(fun(Item)-> {Item#factorial.comment ,Item#factorial.createdOn} end,Results)

         end,
            {atomic , Comment} = mnesia:transaction(AF),
            Comment.

deleteDB(NodeName)->
  AF = fun()->
          Query = qlc:q([X||X <- mnesia:table(factorial) ,
            X#factorial.nodeName=:=NodeName]),
          Results = qlc:e(Query),

          F = fun()->
                lists:foreach(fun(Result)-> mnesia:delete_object(Result) end, Results)
              end,
                mnesia:transaction(F)
       end,
           mnesia:transaction(AF).