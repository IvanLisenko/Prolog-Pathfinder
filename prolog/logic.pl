:- dynamic road/4.

find_shortest(From, To, Distance, Time) :-
    road(From, To, Distance, Time), !.
find_shortest(From, To, Distance, Time) :-
    road(From, X, D1, T1),
    road(X, To, D2, T2),
    Distance is D1 + D2,
    Time is T1 + T2.
