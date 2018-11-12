
whiteWalker(2,3).
whiteWalker(1,3).
whiteWalker(2,1).
whiteWalker(2,2).

obstacle(2,1).

dragonStone(3,1).

maxGlass(3).

remWalkers(4).

gridShape(4,4).

jonSnow(3,3).




validCell(X, Y):-
    not(whiteWalker(X,Y)),
    gridShape(R,C),
    \+ (obstacle(X,Y)),
    \+ (X > R),
    \+ (X < 0),
    \+ (Y > C),
    \+ (Y < 0).



johnAt(X,Y,result(A,S)):-
    johnAt(Z,W,S),
    \+ (X = Z) ; \+ (Y = W),
    validCell(Z,W),
    validCell(X,Y),
    A is move(X,Y).

