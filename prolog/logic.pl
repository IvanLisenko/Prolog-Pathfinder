find_shortest(From, To, Distance, Time, Path) :-
    findall(D-T-P, find_route(From, To, D, T, P), Routes),
    Routes \== [],
    min_distance(Routes, Distance, Time, Path).

find_route(From, To, Distance, Time, Path) :-
    find_route(From, To, 0, 0, [From], Distance, Time, Path).

find_route(To, To, DistAcc, TimeAcc, Visited, DistAcc, TimeAcc, Path) :-
    reverse(Visited, Path).

find_route(Current, To, DistAcc, TimeAcc, Visited, Distance, Time, Path) :-
    (road(Current, Next, D, T); road(Next, Current, D, T)),
    \+ member(Next, Visited),
    NewDist is DistAcc + D,
    NewTime is TimeAcc + T,
    find_route(Next, To, NewDist, NewTime, [Next|Visited], Distance, Time, Path).

min_distance([D-T-P], D, T, P) :- !.
min_distance([D1-T1-P1, D2-T2-P2|Rest], BestD, BestT, BestP) :-
    (D1 =< D2 -> min_distance([D1-T1-P1|Rest], BestD, BestT, BestP)
               ; min_distance([D2-T2-P2|Rest], BestD, BestT, BestP)).
