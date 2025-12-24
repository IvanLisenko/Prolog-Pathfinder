% Алгоритм Дейкстры
find_shortest(Start, Goal, Distance, Time, Path) :-
    dijkstra(Start, Goal, Distance, Time, Path).

dijkstra(Start, Goal, Distance, Time, Path) :-
    % Инициализация
    empty_assoc(Visited),
    empty_assoc(Distances),
    empty_assoc(Prevs),
    put_assoc(Start, Distances, 0.0, Distances1),
    put_assoc(Start, Prevs, none, Prevs1),
    
    % Основной цикл
    dijkstra_loop([node(0.0, 0.0, Start)], Goal, Visited, Distances1, Prevs1, 
                  FinalDist, FinalPrev),
    
    % Извлечение результатов
    get_assoc(Goal, FinalDist, Distance),
    get_time_for_path(Goal, FinalPrev, Time),
    build_path(Goal, FinalPrev, [], Path).

dijkstra_loop([], _, _, Dist, Prev, Dist, Prev).
dijkstra_loop([node(CurDist, CurTime, Cur)|Queue], Goal, Visited, Dist, Prev, 
              FinalDist, FinalPrev) :-
    (Cur == Goal ->
        FinalDist = Dist, FinalPrev = Prev
    ;
        % Помечаем как посещённую
        put_assoc(Cur, Visited, true, Visited1),
        
        % Находим и фильтруем соседей
        findall((Next, D, T), (road(Cur, Next, D, T); road(Next, Cur, D, T)), AllNeighbors),
        process_neighbors(AllNeighbors, CurDist, CurTime, Dist, Prev, [], NewNodes, Dist1, Prev1),
        
        % Добавляем в приоритетную очередь
        merge_into_queue(Queue, NewNodes, NewQueue),
        
        % Продолжаем
        dijkstra_loop(NewQueue, Goal, Visited1, Dist1, Prev1, FinalDist, FinalPrev)
    ).

% Обработка соседей
process_neighbors([], _, _, Dist, Prev, Nodes, Nodes, Dist, Prev).
process_neighbors([(Next, D, T)|Rest], CurDist, CurTime, Dist, Prev, AccNodes, 
                  NewNodes, FinalDist, FinalPrev) :-
    NewDist is CurDist + D,
    NewTime is CurTime + T,
    (get_assoc(Next, Dist, OldDist) ->
        (NewDist < OldDist ->
            % Обновляем если нашли короче
            put_assoc(Next, Dist, NewDist, Dist1),
            put_assoc(Next, Prev, Cur, Prev1),
            process_neighbors(Rest, CurDist, CurTime, Dist1, Prev1, 
                             [node(NewDist, NewTime, Next)|AccNodes], 
                             NewNodes, FinalDist, FinalPrev)
        ;
            % Пропускаем если не короче
            process_neighbors(Rest, CurDist, CurTime, Dist, Prev, 
                             AccNodes, NewNodes, FinalDist, FinalPrev)
        )
    ;
        % Новая вершина
        put_assoc(Next, Dist, NewDist, Dist1),
        put_assoc(Next, Prev, Cur, Prev1),
        process_neighbors(Rest, CurDist, CurTime, Dist1, Prev1,
                         [node(NewDist, NewTime, Next)|AccNodes],
                         NewNodes, FinalDist, FinalPrev)
    ).

% Слияние очередей (по расстоянию)
merge_into_queue([], New, New).
merge_into_queue(Old, [], Old).
merge_into_queue([node(D1, T1, C1)|Old], [node(D2, T2, C2)|New], 
                 [node(D1, T1, C1)|Merged]) :-
    D1 =< D2,
    merge_into_queue(Old, [node(D2, T2, C2)|New], Merged).
merge_into_queue([node(D1, T1, C1)|Old], [node(D2, T2, C2)|New],
                 [node(D2, T2, C2)|Merged]) :-
    D1 > D2,
    merge_into_queue([node(D1, T1, C1)|Old], New, Merged).

% Построение пути
build_path(City, Prevs, Acc, Path) :-
    (get_assoc(City, Prevs, Prev), Prev \= none ->
        build_path(Prev, Prevs, [City|Acc], Path)
    ;
        Path = [City|Acc]
    ).

% Вычисление времени
get_time_for_path(Goal, Prevs, TotalTime) :-
    build_path(Goal, Prevs, [], Path),
    calculate_time(Path, 0.0, TotalTime).

calculate_time([_], Time, Time).
calculate_time([City1, City2|Rest], Acc, Total) :-
    (road(City1, City2, _, T); road(City2, City1, _, T)),
    NewAcc is Acc + T,
    calculate_time([City2|Rest], NewAcc, Total).