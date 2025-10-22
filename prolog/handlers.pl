:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_parameters)).
:- use_module(library(http/http_json)).
:- [logic].
:- [routes].

rus_to_id(Name, Id) :- atom_string(Id, Name).

city_name(simferopol, 'Симферополь').
city_name(alushta, 'Алушта').
city_name(belogorsk, 'Белогорск').
city_name(saki, 'Саки').
city_name(oktyabrskoye, 'Октябрьское').
city_name(krasnoperekopsk, 'Красноперекопск').
city_name(sevastopol, 'Севастополь').
city_name(yalta, 'Ялта').
city_name(sudak, 'Судак').
city_name(feodosiya, 'Феодосия').
city_name(primorskyi, 'Приморский').
city_name(kerch, 'Керчь').
city_name(armyansk, 'Армянск').
city_name(krasnogvardeiskoe, 'Красногвардейское').
city_name(dzhankoi, 'Джанкой').

path_names([], []).
path_names([H|T], [HN|TN]) :-
    city_name(H, HN),
    path_names(T, TN).

:- http_handler(root(.), serve_index, []).
serve_index(Request) :-
    http_reply_file('web/index.html', [], Request).

:- http_handler(root(web), serve_files_in_web, [prefix]).
serve_files_in_web(Request) :-
    atom_concat('web/', Request.path_info, File),
    http_reply_file(File, [], Request).

:- http_handler(root(find), find_route_handler, []).
find_route_handler(Request) :-
    http_parameters(Request, [
        from(From, [string]),
        to(To, [string])
    ]),
    (   (rus_to_id(From, FromId), rus_to_id(To, ToId))
    ->  (   find_shortest(FromId, ToId, D, T, P)
        ->  path_names(P, P_Rus),
            reply_json_dict(_{distance: D, time: T, route: P_Rus})
        ;   reply_json_dict(_{error: "Маршрут не найден"})
        )
    ;   reply_json_dict(_{error: "Город не найден"})
    ).
