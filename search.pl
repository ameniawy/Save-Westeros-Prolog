
%% WW EE WW
%% EE EE EE
%% OO DS JS

discontiguous(whiteWalker/4).
discontiguous(jonAt/4).

whiteWalker(0, 2, 1, s0).      
whiteWalker(2, 0, 1, s0).


obstacle(0, 0).

dragonStone(1,2).

maxGlass(2).

gridShape(3,3).


jonAt(2, 2, 0, s0).


validCell(X, Y, Situation):-
    \+ whiteWalker(X, Y, 1, Situation),
    \+ (obstacle(X,Y)),
    gridShape(R,C),
    (X < R),
    \+ (X < 0),
    (Y < C),
    \+ (Y < 0).


% JONAT SUCCESSOR STATE AXIOMS
% if action is to move right
% CDG -> current Dragon Glass
jonAt(X,Y, CDG, result(Action, Situation)):-
    nonvar(X),
    nonvar(Y),
    X1 is X - 1,
    X2 is X + 1,
    Y1 is Y + 1,
    Y2 is Y - 1,
    ((Action = right, jonAt(X1, Y, CDG, Situation));
     (Action = left, jonAt(X2, Y, CDG, Situation));
     (Action = up, jonAt(X, Y1, CDG, Situation));
     (Action = down, jonAt(X, Y2, CDG, Situation))),
    validCell(X,Y, Situation).

% if action is kill
jonAt(X, Y, CDG, result(Action, Situation)):-
    (Action = kill),
    nonvar(CDG),
    CDG1 is CDG + 1,
    jonAt(X, Y, CDG1, Situation),
    nonvar(X),
    nonvar(Y),
    X1 is X + 1,
    X2 is X - 1,
    Y1 is Y + 1,
    Y2 is Y - 1,
    (whiteWalker(X1, Y, 1, Situation); whiteWalker(X2, Y, 1, Situation); whiteWalker(X, Y1, 1, Situation); whiteWalker(X, Y2, 1, Situation)).


% dead white walker??
% killedWalker


% if action is refill
jonAt(X, Y, Max, result(Action, Situation)):-
    maxGlass(Max),
    (Action = refill),
    dragonStone(X, Y),
    jonAt(X, Y, _, Situation).


% WHITE WALKERS SUCCESSOR STATE AXIOMS
% if white walker existed in the previous sitation in this location and the action was not a kill.
whiteWalker(X, Y, 1, result(Action, Situation)):-
    whiteWalker(X, Y, 1, Situation),
    ((Action = right); (Action = left); (Action = up); (Action = down); (Action = refill)).

% if the action was a kill but Jon was not in the neighbouring cells.
whiteWalker(X, Y, 1, result(kill, Situation)):-
    whiteWalker(X, Y, 1, Situation),
    % (Action = kill),
    nonvar(X),
    nonvar(Y),
    X1 is X + 1,
    X2 is X - 1,
    Y1 is Y + 1,
    Y2 is Y - 1,
    \+ jonAt(X1, Y, _, Situation),
    \+ jonAt(X2, Y, _, Situation),
    \+ jonAt(X, Y1, _, Situation),
    \+ jonAt(X, Y2, _, Situation).

% if the action was a kill and Jon was in a neighbouring cell but had no dragonGlass.
whiteWalker(X, Y, 1, result(kill, Situation)):-
    whiteWalker(X, Y, 1, Situation),
    nonvar(X),
    nonvar(Y),
    X1 is X + 1,
    X2 is X - 1,
    Y1 is Y + 1,
    Y2 is Y - 1,
    (jonAt(X1, Y, 0, Situation);
    jonAt(X2, Y, 0, Situation);
    jonAt(X, Y1, 0, Situation);
    jonAt(X, Y2, 0, Situation)).


% when is a white walker dead? if the action was a kill and it was alive in the previous situation
% dead when whiteWalker(X, Y, Alive, result(kill, S))
whiteWalker(X, Y, 0, result(kill, Situation)):-
    whiteWalker(X, Y, 1, Situation),
    % continue with conditions for death
    nonvar(X),
    nonvar(Y),
    X1 is X + 1,
    X2 is X - 1,
    Y1 is Y + 1,
    Y2 is Y - 1,
    (jonAt(X1, Y, DG, Situation);
    jonAt(X2, Y, DG, Situation);
    jonAt(X, Y1, DG, Situation);
    jonAt(X, Y2, DG, Situation)),
    \+ (DG = 0).



% for all white walkers their alive flag is 0

findPath(S):-
    forall(whiteWalker(X,Y,1,s0),
    whiteWalker(X,Y,0,S)).

findPath2(S):-
    run((whiteWalker(0,2,0,S),whiteWalker(2,0,0,S))).



%%main predicate to run the code where Q represent query to be used
run(Q):-
  run_helper(Q,3).

%%helper for the main predicate just to have the initial starting depth called I
run_helper(Q, I):-
  call_with_depth_limit(Q,I,R),
  run_helper2(Q,I,R).

%%checks if R is not depth_limit_exceeded then the agent have found a solution so it stops and returns this solution
run_helper2(_, _, R):-
  R \= depth_limit_exceeded.

%%checks if R is depth_limit_exceeded then the agent have not found a solution so it increments the depth to search in a deeper level
run_helper2(Q, I, R):-
  R == depth_limit_exceeded,
  I1 is I +1,
  run_helper(Q,I1).