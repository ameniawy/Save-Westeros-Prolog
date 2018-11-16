
whiteWalker(2, 3, s0).
whiteWalker(1, 3, s0).
whiteWalker(2, 1, s0).
whiteWalker(2, 2, s0).

obstacle(2,1).

dragonStone(3,1).

maxGlass(3).

remWalkers(4).

gridShape(4,4).


currentDragonGlass(0, s0).


jonAt(3, 3, s0).


validCell(X, Y, Situation):-
    \+ whiteWalker(X, Y, Situation),
    \+ (obstacle(X,Y)),
    gridShape(R,C),
    \+ (X > R),
    \+ (X < 0),
    \+ (Y > C),
    \+ (Y < 0).




% if Jon was in a different cell that is valid and the new cell is also valid and the action was right, left, up, or down.
jonAt(X,Y,result(Action, Situation)):-
    jonAt(Z,W,Situation),
    \+ (X = Z) ; \+ (Y = W),
    validCell(Z,W),
    validCell(X,Y),
    ((Action = right); (Action = left); (Action = up); (Action = down)).


% if Jon was already in X, Y before and the action performed did not change that fact.
jonAt(X, Y, result(Action, Situation)):-
    (jonAt(X, Y, Situation),
    (Action = kill; Action = refill));
    (jonAt(Z, W, Situation),
    \+ (X = Z) ; \+ (Y = W),
    validCell(Z,W),
    ((Action = right); (Action = left); (Action = up); (Action = down)),
    \+ validCell(X, Y)).



% if white walker existed in the previous sitation in this location and the action was not a kill.
whiteWalker(X, Y, result(Action, Situation)):-
    whiteWalker(X, Y, Situation),
    ((Action = right); (Action = left); (Action = up); (Action = down); (Action = refill)).


% if the action was a kill but Jon was not in the neighbouring cells.
whiteWalker(X, Y, result(Action, Situation)):-
    whiteWalker(X, Y, Situation),
    (Action = kill),
    \+ jonAt(X + 1, Y, Situation),
    \+ jonAt(X - 1, Y, Situation),
    \+ jonAt(X, Y + 1, Situation),
    \+ jonAt(X, Y - 1, Situation).

% if the action was a kill and Jon was in a neighbouring cell but had no dragonGlass.
whiteWalker(X, Y, result(Action, Situation)):-
    whiteWalker(X, Y, Situation),
    (Action = kill),
    (jonAt(X + 1, Y, Situation);
    jonAt(X - 1, Y, Situation);
    jonAt(X, Y + 1, Situation);
    jonAt(X, Y - 1, Situation)),
    currentDragonGlass(0, Situation).



% if our dragonGlass was not N and it became N as a result of refilling or killing.
currentDragonGlass(N, result(Action, Situation)):-
    currentDragonGlass(M, Situation),
    \+ (N = M),
    ((Action = refill); ((Action = kill), jonAt(X, Y, Situation), whiteWalker(X + 1, Y, Situation), whiteWalker(X - 1, Y, Situation), whiteWalker(X, Y + 1, Situation), whiteWalker(X, Y - 1, Situation))).


% if action was move.
currentDragonGlass(N, result(Action, Situation)):-
    currentDragonGlass(N, Situation),
    ((Action = right); (Action = left); (Action = up); (Action = down)).


% if action was refill and the dragonGlass has not changed.
currentDragonGlass(N, result(Action, Situation)):-
    currentDragonGlass(N, Situation),
    (Action = refill),
    maxGlass(N).

% if action was kill and dragonGlass is zero, it will not change.
currentDragonGlass(N, result(Action, Situation)):-
    currentDragonGlass(N, Situation),
    (Action = kill),
    (N = 0).



    


% move right
takeAction(Situation):-
    jonAt(X, Y, Situation),
    validCell(X + 1, Y, Situation),
    move(X + 1, Y, Situation),



