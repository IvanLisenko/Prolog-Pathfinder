:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_parameters)).
:- use_module(library(http/http_json)).
:- [logic].

% Главная страница
:- http_handler(root(.), serve_index, []).

serve_index(Request) :-
    http_reply_file('web/index.html', [], Request).

% Статические файлы (CSS, JS)
:- http_handler(root(web), serve_files_in_web, [prefix]).

serve_files_in_web(Request) :-
    atom_concat('web/', Request.path_info, File),
    http_reply_file(File, [], Request).

% Обработчик маршрутов
:- http_handler(root(find), find_route_handler, []).

find_route_handler(Request) :-
    http_parameters(Request, [
        from(From, [string]),
        to(To, [string])
    ]),
    atom_string(A, From),
    atom_string(B, To),
    ( find_shortest(A, B, D, T, P) ->
        reply_json_dict(_{distance: D, time: T, route: P})
    ; reply_json_dict(_{error: "Route not found"})
    ).

%find_route_handler(Request) :-
%    http_parameters(Request, [
%        from(From, [string]),
%        to(To, [string])
%    ]),
%
%    atom_string(FromAtom, From),
%    atom_string(ToAtom, To),
%
%    (   find_direct_route(FromAtom, ToAtom, Distance, Time, Route)
%    ->  maplist(atom_string, RouteStrings, Route),
%        reply_json(_{
%            distance: Distance,
%            time: Time,
%            route: RouteStrings
%        })
%    ;   reply_json(_{
%            error: "Route not found"
%        }, [status(404)])
%    ).
%
%% Ищем только прямые маршруты или через один город
%find_direct_route(From, To, Distance, Time, [From, To]) :-
%    (road(From, To, Distance, Time); road(To, From, Distance, Time)),
%    !.
%
%find_direct_route(From, To, Distance, Time, [From, Via, To]) :-
%    (   road(From, Via, D1, T1),
%        road(Via, To, D2, T2)
%    ;   road(From, Via, D1, T1),
%        road(To, Via, D2, T2)
%    ;   road(Via, From, D1, T1),
%        road(Via, To, D2, T2)
%    ;   road(Via, From, D1, T1),
%        road(To, Via, D2, T2)
%    ),
%    Distance is D1 + D2,
%    Time is T1 + T2,
%    !.
