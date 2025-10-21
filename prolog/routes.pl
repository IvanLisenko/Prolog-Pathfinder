% road(City1, City2, Distance, Time)
road(simferopol, alushta, 45, 50).
road(simferopol, belogorsk, 44, 37).
road(simferopol, saki, 49, 37).
road(simferopol, oktyabrskoye, 44, 30).
road(simferopol, krasnoperekopsk, 124, 86).
road(simferopol, sevastopol, 78, 70).
road(alushta, yalta, 38, 29).
road(alushta, sudak, 81, 57).
road(belogorsk, feodosiya, 72, 75).
road(sudak, feodosiya, 53, 40).
road(belogorsk, primorskyi, 84, 92).
road(feodosiya, primorskyi, 14, 11).
road(primorskyi, kerch, 85, 68).
road(krasnoperekopsk, armyansk, 20, 15).
road(oktyabrskoye, krasnogvardeiskoe, 28, 19).
road(krasnogvardeiskoe, dzhankoi, 27, 16).

% Правило для симметричности дорог (дороги работают в обе стороны)
%route(X, Y, Distance, Time) :- road(X, Y, Distance, Time).
%route(X, Y, Distance, Time) :- road(Y, X, Distance, Time).