
%% WW EE WW
%% EE EE EE
%% OO DS JS

discontiguous(whiteWalker/4).
discontiguous(jonAt/4).

obstacle(0, 2).

dragonStone(1,2).

maxGlass(2).

gridShape(3,3).


jonAt(2, 2, 0, s0).

whiteWalker(0, 0, 1, s0).      
whiteWalker(2, 0, 1, s0).
whiteWalker(0, 1, 1, s0).

%checks if the cell is valid: does not have a living white walker, nor an obstacle and within the grid dimenions.
validCell(X, Y, Situation):-
    \+ whiteWalker(X, Y, 1, Situation),
    \+ (obstacle(X,Y)),
    gridShape(R,C),
    (X < R),
    \+ (X < 0),
    (Y < C),
    \+ (Y < 0).



% JONAT SUCCESSOR STATE AXIOMS
%-----------------------------
%-----------CASE 1------------
% if action is to move
% CDG -> current Dragon Glass

jonAt(Col,Row, CurrentDG, result(Action, Situation)):-
    nonvar(Col),
    nonvar(Row),
    LeftCol is Col - 1,
    RightCol is Col + 1,
    DownRow is Row + 1,
    UpRow is Row - 1,
    ((Action = right, jonAt(LeftCol, Row, CurrentDG, Situation));
     (Action = left, jonAt(RightCol, Row, CurrentDG, Situation));
     (Action = up, jonAt(Col, DownRow, CurrentDG, Situation));
     (Action = down, jonAt(Col, UpRow, CurrentDG, Situation))),
    validCell(Col,Row, Situation).


%-----------CASE 2------------
% if action is a kill and there is a white walker in the neighbouring cells, decrease dragon glasses by 1

jonAt(Col, Row, CurrentDG, result(Action, Situation)):-
    (Action = kill),
    nonvar(CurrentDG),
    OldDG is CurrentDG + 1,
    jonAt(Col, Row, OldDG, Situation),
    nonvar(Col),
    nonvar(Row),
    RightCol is Col + 1,
    LeftCol is Col - 1,
    DownRow is Row + 1,
    UpRow is Row - 1,
    (whiteWalker(RightCol, Row, 1, Situation); whiteWalker(LeftCol, Row, 1, Situation); whiteWalker(Col, DownRow, 1, Situation); whiteWalker(Col, UpRow, 1, Situation)).


%-----------CASE 3------------
% if action is refill
% check if there is a dragon stone in this cell, update current DragonGlass to the maximum value.

jonAt(Col, Row, MaxDG, result(Action, Situation)):-
    maxGlass(MaxDG),
    (Action = refill),
    dragonStone(Col, Row),
    jonAt(Col, Row, _, Situation).





% WHITE WALKERS SUCCESSOR STATE AXIOMS
%--------------------------------------

%------------CASE 1--------------------
% 3rd input is the alive flag: 1 = Alive, 0 = dead
% a white walker is alive in the result situation, if white walker was alive in the previous situation in this location and the action is not a kill.

whiteWalker(Col, Row, 1, result(Action, Situation)):-
    whiteWalker(Col, Row, 1, Situation),
    ((Action = right); (Action = left); (Action = up); (Action = down); (Action = refill)).


%------------CASE 2--------------------
% a white walker is alvie in the result of the situation, if white walker was alive in the previous situation 
% and the action is a kill but Jon was not in the neighbouring cells.

whiteWalker(Col, Row, 1, result(kill, Situation)):-
    whiteWalker(Col, Row, 1, Situation),
    nonvar(Col),
    nonvar(Row),
    RightCol is Col + 1,
    LeftCol is Col - 1,
    DownRow is Row + 1,
    UpRow is Row - 1,
    \+ jonAt(RightCol, Row, _, Situation),
    \+ jonAt(LeftCol, Row, _, Situation),
    \+ jonAt(Col, DownRow, _, Situation),
    \+ jonAt(Col, UpRow, _, Situation).


%------------CASE 3--------------------
%a white walker stays alive, if it was alive in the previous situation and the action was a kill with Jon in a neighbouring cell but had no dragonGlass.

whiteWalker(Col, Row, 1, result(kill, Situation)):-
    whiteWalker(Col, Row, 1, Situation),
    nonvar(Col),
    nonvar(Row),
    RightCol is Col + 1,
    LeftCol is Col - 1,
    DownRow is Row + 1,
    UpRow is Row - 1,
    (jonAt(RightCol, Row, 0, Situation);
    jonAt(LeftCol, Row, 0, Situation);
    jonAt(Col, DownRow, 0, Situation);
    jonAt(Col, UpRow, 0, Situation)).


%------------CASE 4--------------------
% when is a white walker dead? 
%if the action was a kill and it was alive in the previous situation and jon is in a neighbouring cell with enough dragon glasses (>0).

whiteWalker(Col, Row, 0, result(kill, Situation)):-
    whiteWalker(Col, Row, 1, Situation),
    nonvar(Col),
    nonvar(Row),
    RightCol is Col + 1,
    LeftCol is Col - 1,
    DownRow is Row + 1,
    UpRow is Row - 1,
    (jonAt(RightCol, Row, OldDG, Situation);
    jonAt(LeftCol, Row, OldDG, Situation);
    jonAt(Col, DownRow, OldDG, Situation);
    jonAt(Col, UpRow, OldDG, Situation)),
    \+ (OldDG = 0).


%------------CASE 5--------------------
%a white walker stays dead, if it was dead in the previous situation whatever the action is.
whiteWalker(Col, Row, 0, result(Action, Situation)):-
    whiteWalker(Col, Row, 0, Situation),
    ((Action = kill); (Action = refill); (Action = up); (Action = down); (Action = left); (Action = right)).



%%main predicate to run the code where Query represent query to be used
run(Query):-
  run_helper(Query,3).

%%helper for the main predicate just to have the initial starting depth limit called Limit
run_helper(Query, Limit):-
  call_with_depth_limit(Query,Limit,R),
  run_helper2(Query,Limit,R).

%%checks if R is not depth_limit_exceeded then the agent have found a solution so it stops and returns this solution
run_helper2(_, _, R):-
  R \= depth_limit_exceeded.

%%checks if R is depth_limit_exceeded then the agent have not found a solution so it increments the depth to search in a deeper level
run_helper2(Query, Limit, R):-
  R == depth_limit_exceeded,
  NewLimit is Limit + 1,
  run_helper(Query,NewLimit).