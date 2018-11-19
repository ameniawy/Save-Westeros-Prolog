
% WW EE OO
% EE EE DS
% WW EE JS


whiteWalker(0, 0, 1, s0).      
whiteWalker(2, 0, 1, s0).


obstacle(0, 2).

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
    ((Action = right, jonAt(X - 1, Y, CDG, Situation));
     (Action = left, jonAt(X + 1, Y, CDG, Situation));
     (Action = up, jonAt(X, Y + 1, CDG, Situation));
     (Action = down, jonAt(X, Y - 1, CDG, Situation))),
    validCell(X,Y, Situation).

% if action is kill
jonAt(X, Y, CDG, result(Action, Situation)):-
    (Action = kill),
    jonAt(X, Y, CDG + 1, Situation), 
    (whiteWalker(X+1, Y, 1, Situation); whiteWalker(X-1, Y, 1, Situation); whiteWalker(X, Y+1, 1, Situation); whiteWalker(X, Y-1, 1, Situation)).


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
    \+ jonAt(X + 1, Y, _, Situation),
    \+ jonAt(X - 1, Y, _, Situation),
    \+ jonAt(X, Y + 1, _, Situation),
    \+ jonAt(X, Y - 1, _, Situation).

% if the action was a kill and Jon was in a neighbouring cell but had no dragonGlass.
whiteWalker(X, Y, 1, result(kill, Situation)):-
    whiteWalker(X, Y, 1, Situation),
    % (Action = kill),
    (jonAt(X + 1, Y, 0, Situation);
    jonAt(X - 1, Y, 0, Situation);
    jonAt(X, Y + 1, 0, Situation);
    jonAt(X, Y - 1, 0, Situation)).


% dead when whiteWalker(X, Y, Alive, result(kill, S))
whiteWalker(X, Y, 0, result(kill, Situation)):-
    whiteWalker(X, Y, 1, Situation),
    % continue with conditions for death
    (jonAt(X + 1, Y, 0, Situation);
    jonAt(X - 1, Y, 0, Situation);
    jonAt(X, Y + 1, 0, Situation);
    jonAt(X, Y - 1, 0, Situation)).



% for all white walkers their alive flag is 0






%goal test
goalTest(Situation):-
    \+ whiteWalker(_, _, 1, Situation).
    
run(Situation):-
    goalTest(Situation),
    jonAt(_, _, _, Situation).

run(Situation):-
    jonAt(_, _, _, result(Action, Situation)),
    ((Action = right); (Action = left); (Action = up); (Action = down); (Action = kill); (Action = refill)),
    run(result(Action, Situation)).





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