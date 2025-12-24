:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_parameters)).
:- use_module(library(http/http_json)).
:- [logic].
:- [routes].

% Преобразование русского названия в ID
rus_to_id(Name, Id) :- atom_string(Id, Name).

% Соответствие английских ID русским названиям
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
city_name(primorskiy, 'Приморский').
city_name(kerch, 'Керчь').
city_name(armyansk, 'Армянск').
city_name(krasnogvardeyskoye, 'Красногвардейское').
city_name(dzhankoi, 'Джанкой').
city_name(alupka, 'Алупка').
city_name(foros, 'Форос').
city_name(koreiz, 'Кореиз').
city_name(partenity, 'Партенит').
city_name(gurzuf, 'Гурзуф').
city_name(bakhchisaray, 'Бахчисарай').
city_name(inkerman, 'Инкерман').
city_name(balaklava, 'Балаклава').
city_name(kirovskoye, 'Кировское').
city_name(pervomayskoye, 'Первомайское').
city_name(chernomorskoye, 'Черноморское').
city_name(mirnyy, 'Мирный').
city_name(nizhnegorskiy, 'Нижнегорский').
city_name(razdo, 'Раздольное').
city_name(yevpatoriya, 'Евпатория').
city_name(koktebel, 'Коктебель').
city_name(staryi_krym, 'Старый Крым').
city_name(shcholkino, 'Щёлкино').
city_name(krasnoselskoye, 'Красносельское').
city_name(sovietskiy, 'Советский').
city_name(krasnoarmeyskoye, 'Красноармейское').
city_name(massandra, 'Массандра').
city_name(urozhaynoye, 'Урожайное').
city_name(solnechnogorskoye, 'Солнечногорское').
city_name(novozyornoye, 'Новозёрное').

% Преобразование пути в русские названия
path_names([], []).
path_names([H|T], [HN|TN]) :-
    city_name(H, HN),
    path_names(T, TN).

% Обработчики HTTP
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

% Favicon handler (чтобы не было 404)
:- http_handler(root(favicon.ico), favicon_handler, []).
favicon_handler(_Request) :-
    format('Content-type: image/x-icon~n~n'),
    true.