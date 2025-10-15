:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_parameters)).
:- use_module(library(http/http_json)).

:- ensure_loaded(routes).
:- ensure_loaded(logic).
:- ensure_loaded(handlers).

server(Port) :-
    http_server(http_dispatch, [port(Port)]).

:- initialization(server(8080)).
