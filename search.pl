
whiteWalker(0, 0, s0).
whiteWalker(3, 0, s0).
whiteWalker(0, 3, s0).

obstacle(0, 2).

dragonStone(1,2).

maxGlass(3).

gridShape(4,4).


jonAt(3, 3, 0, s0).


validCell(X, Y, Situation):-
    \+ whiteWalker(X, Y, Situation),
    \+ (obstacle(X,Y)),
    gridShape(R,C),
    \+ (X > R-1),
    \+ (X < 0),
    \+ (Y > C-1),
    \+ (Y < 0).


% JONAT SUCCESSOR STATE AXIOMS
% if action is to move right
% CDG -> current Dragon Glass
jonAt(X,Y, CDG, result(Action, Situation)):-
    ((Action = right, jonAt(X - 1, Y, CDG, Situation);
     (Action = left, jonAt(X + 1, Y, CDG, Situation);
     (Action = up, jonAt(X, Y-1, CDG, Situation);
     (Action = down, jonAt(X, Y+1, CDG, Situation))
    validCell(X,Y).

% if action is kill
jonAt(X, Y, CDG, result(Action, Situation)):-
    (Action = kill),
    jonAt(X, Y, CDG + 1, Situation), 
    (whiteWalker(X+1, Y, Situation); whiteWalker(X-1, Y, Situation); whiteWalker(X, Y+1, Situation); whiteWalker(X, Y-1, Situation)).

% if action is refill
jonAt(X, Y, Max, result(Action, Situation)):-
    maxGlass(Max),
    (Action = refill),
    dragonGlass(X, Y),
    jonAt(X, Y, _, Situation).


% WHITE WALKERS SUCCESSOR STATE AXIOMS
% if white walker existed in the previous sitation in this location and the action was not a kill.
whiteWalker(X, Y, result(Action, Situation)):-
    whiteWalker(X, Y, Situation),
    ((Action = right); (Action = left); (Action = up); (Action = down); (Action = refill)).

% if the action was a kill but Jon was not in the neighbouring cells.
whiteWalker(X, Y, result(Action, Situation)):-
    whiteWalker(X, Y, Situation),
    (Action = kill),
    \+ jonAt(X + 1, Y, _, Situation),
    \+ jonAt(X - 1, Y, _, Situation),
    \+ jonAt(X, Y + 1, _, Situation),
    \+ jonAt(X, Y - 1, _, Situation).

% if the action was a kill and Jon was in a neighbouring cell but had no dragonGlass.
whiteWalker(X, Y, result(Action, Situation)):-
    whiteWalker(X, Y, Situation),
    (Action = kill),
    (jonAt(X + 1, Y, 0, Situation);
    jonAt(X - 1, Y, 0, Situation);
    jonAt(X, Y + 1, 0, Situation);
    jonAt(X, Y - 1, 0, Situation)).

%goal test
goalTest(Situation):-
    \+ whiteWalker(_, _, Situation).
    
run(Situation):-
    goalTest(Situation),
    jonAt(_, _, _, Situation).

run(Situation):-
    jonAt(_, _, _, result(Action, Situation)),
    run(result(Action, Situation)).


