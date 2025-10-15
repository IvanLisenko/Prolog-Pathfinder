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
    ( find_shortest(A, B, D, T) ->
        reply_json_dict(_{distance: D, time: T})
    ; reply_json_dict(_{error: "Route not found"})
    ).
