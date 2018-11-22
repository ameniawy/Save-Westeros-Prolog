dragonStone(2,1).
whiteWalker(0,1,1,s0).
whiteWalker(0,2,1,s0).
obstacle(0,0).

killWalkers(S):-
	run((whiteWalker(0,1,0,S),whiteWalker(0,2,0,S))).

jonAt(2,2,0,s0).
maxGlass(2).
remWalkers(2).
gridShape(3,3).