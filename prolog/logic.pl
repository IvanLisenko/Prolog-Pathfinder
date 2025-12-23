% logic.pl - алгоритм Дейкстры для поиска кратчайшего пути

find_shortest(Start, Goal, Distance, Time, Path) :-
    dijkstra_search([(0.0, 0.0, [Start])], Goal, [], Distance, Time, RevPath),
    reverse(RevPath, Path).

% Базовый случай: нашли цель
dijkstra_search([(Dist, Time, [Goal|Path])|_], Goal, _, Dist, Time, [Goal|Path]) :- !.

% Рекурсивный случай: продолжаем поиск
dijkstra_search([(CurDist, CurTime, [Cur|Path])|Queue], Goal, Visited, BestDist, BestTime, BestPath) :-
    % Находим всех соседей текущего города
    findall(
        (NewDist, NewTime, [Next, Cur|Path]),
        (
            (road(Cur, Next, D, T); road(Next, Cur, D, T)),  % Дорога в любую сторону
            \+ member(Next, [Cur|Path]),                     % Избегаем циклов
            NewDist is CurDist + D,
            NewTime is CurTime + T
        ),
        NewPaths
    ),
    % Добавляем новые пути в очередь
    append(Queue, NewPaths, UnsortedQueue),
    % Сортируем по расстоянию (кратчайший первый)
    sort_paths(UnsortedQueue, SortedQueue),
    % Продолжаем поиск с отсортированной очередью
    dijkstra_search(SortedQueue, Goal, [Cur|Visited], BestDist, BestTime, BestPath).

% Вспомогательный предикат для сортировки путей по расстоянию
sort_paths(Unsorted, Sorted) :-
    predsort(compare_paths, Unsorted, Sorted).

% Компаратор: сравниваем только по расстоянию (первый элемент кортежа)
compare_paths(Order, (D1, _, _), (D2, _, _)) :-
    compare(Order, D1, D2).