
% Comboio - [L, CarA, CarB]
% Agulha - baixo/cima
% Sendo A uma area qualquer, A = [Comboio, Carruagens no troco]
% estado - [ AreaA, AreaB, AreaC, AreaD ]

estado_inicial([ [[], CarruagensA], [Comboio, CarruagensB, Agulha], [[],CarruagensC], [[],CarruagensD] ]):-
	Comboio = [l, car,car],
	Agulha = cima,
	CarruagensA = [],
	CarruagensB = [],
	CarruagensC = [],
	CarruagensD = [].

estado_final([ [[], CarruagensA], [[], CarruagensB, Agulha], [[],CarruagensC], [Comboio,CarruagensD]]):-
	Comboio= [l, car, car],
	Agulha= baixo,
	CarruagensA = [],
	CarruagensB = [],
	CarruagensC = [],
	CarruagensD = [].

% ------------------------------- OPERACOES ---------------------------------
op(EI, frente, EF, 1):-
	frente(EI, EF).

op(EI, tras, EF, 1):-
	tras(EI, EF).

op(EI, engatar_frente, EF, 1):-
	engatar(EI, frente, EF).

op(EI, engatar_tras, EF, 1):-
        engatar(EI, tras, EF).

op(EI, desengatar_frente, EF, 1):-
	desengatar(EI, EF, frente).

op(EI, desengatar_frente, EF, 1):-
	desengatar(EI, EF, tras).

op(EI, comutar_agulha, EF, 1):-
	comutar(EI, EF).

% ------------------------------- COMUTAR ----------------------------------
comutar([AreaA|[AreaB|Outras]], [AreaA|[NovaAreaB|Outras]]):-
	comutar_(AreaB, NovaAreaB).

comutar_([Comboio|[Carr,baixo|[]]], [Comboio|[Carr,cima|[]]]).
comutar_([Comboio|[Carr,cima|[]]], [Comboio|[Carr,baixo|[]]]).

% ------------------------------- ENGATAR ----------------------------------
engatar( [Area|T], Direccao, [[NovoComboio|[[]|T2]]|T]):-
	Area = [Comboio|[H|T2]],
        Comboio \= [],
	H \= [],
	engatar_(Comboio, H, NovoComboio, Direccao),!.

engatar( [H|T], Dir, [H|EF] ):-
	engatar( T, Dir, EF ).

engatar_(Comboio, Cars, NovoComboio, frente):-
	append(Comboio, Cars, NovoComboio).

engatar_(Comboio, Cars, NovoComboio, tras):-
	append(Cars, Comboio, NovoComboio).


% ------------------------------ DESENGATAR ----------------------------------
desengatar(EI, EF, Dir):-
	desengatar_(EI, EF, Dir).

desengatar_([Area|Outras], [[NovoComboio, Carruagens2|T]|Outras], frente):-
	Area = [Comboio|[Carruagens|T]],
	length(Comboio, Size),
	Size > 1, nth(1, Comboio, E), E \= l,
	remove_first_position(Comboio, NovoComboio, Carruagem),
	append(Carruagens, [Carruagem], Carruagens2).

desengatar_([Area|Outras], [[NovoComboio, Carruagens2|T]|Outras], tras):-
        Area = [Comboio|[Carruagens|T]],
        length(Comboio, Size),
        Size > 1, nth(Size, Comboio, E), E \= l,
        remove_last_position(Comboio, NovoComboio, Carruagem),
        append(Carruagens, [Carruagem], Carruagens2).

desengatar_([H|T], [H|EF], Dir):-
	desengatar_(T, EF, Dir).



% -------------------------------- FRENTE ------------------------------------
frente(EI, EF):-
	remove_from( P, EI, EI2, Comboio ),
	frente_(P, EI2, EF, Comboio).
% A -> B
frente_(1, EI, EF, Comboio):-
	is_cima(EI),
	insert_at(2, EI, EF, Comboio),!.
% A -> D
frente_(1, EI, EF, Comboio):-
	insert_at(4, EI, EF, Comboio),!.
% B -> C
frente_(2, EI, EF, Comboio):-
	insert_at(3, EI, EF, Comboio),!.
% D -> C
frente_(4, EI, EF, Comboio):-
	insert_at(3, EI, EF, Comboio).

% ---------------------------- ANDAR PARA TRAS ------------------------------
tras(EI, EF):-
	remove_from(P, EI, EI2, Comboio),
	tras_(P, EI2, EF, Comboio).
% C -> B
tras_(3, EI, EF, Comboio):-
	is_cima(EI),
	insert_at(2, EI, EF, Comboio),!.
% C -> D
tras_(3, EI, EF, Comboio):-
	insert_at(4, EI, EF, Comboio),!.
% B -> A
tras_(2, EI, EF, Comboio):-
	insert_at(1, EI, EF, Comboio),!.
% D -> A
tras_(4, EI, EF, Comboio):-
	insert_at(1, EI, EF, Comboio).

% -------------------------- FUNCOES AUXILIARES------------------------------

% O predicado is_cima(?EstadoInicial) é true se a agulha esta virada para cima
is_cima(EI):-
	nth(2, EI, Area),
	member(cima, Area).

% Dado um estado inicial insere o comboio na posicao P
% insert_at( ?Posicao, ?EstadoInicial, ?EstadoFinal, Comboio)
insert_at( P, EI, EF, Comboio):-
	insert_at( P, EI, EF, Comboio, 1).

insert_at(P, [Area|T], [[Comboio|T1]|T], Comboio, I):-
	P = I,
	Area = [_|T1].

insert_at(P, [Area|T], [Area|T2], Comboio, I):-
	I2 is I + 1,
	insert_at(P, T, T2, Comboio, I2).

% Remove o comboio da lista e devolve a posicao
% remove_from( ?Posicao,?AreasComOComboio, ?AreasSemOComboio, ?Comboio).
remove_from( P, Areas, NewAreas, Comboio ):-
	remove_from_(P, Areas, NewAreas, Comboio, 1).

remove_from_( P, [Area|T], [[[]|T1]|T], Comboio, I):-
	Area = [Comboio|T1],
	Comboio \= [],
	P = I.

remove_from_( P, [Area|T], [Area|T1], Comboio2, I):-
	Area = [Comboio|_],
	Comboio = [],
	I2 is I + 1,
	remove_from_( P, T, T1, Comboio2, I2).

remove_last_position([E], [], E).

remove_last_position([H|T], [H|T2], E):-
	remove_last_position(T, T2, E).


remove_first_position([H|T], T, H).

% Diz em que area esta o comboio
posicao_comboio(P, Areas):-
	posicao_(P, Areas, 1).

posicao_(P, [Area|T], I):-
	Area = [Comboio|_],
	Comboio \= [],
	P = I.
posicao_(P, [_|T], I):-
	I2 is I+1,
	posicao_(P, T, I2).


% --------------------------- HEURISTICA -------------------------------

h(E, V):-
	h1(E, V1),
	h2(E, V2),
	V is V1.

% -------------------------- HEURISTICA 1 ------------------------------
% Calcula a distancia que o comboio esta da area no estado final
h1(E, C):-
	estado_final(EF),
	posicao_comboio(Y, EF),
	posicao_comboio(X, E),
	nth(2, E, AreaB),
	nth(3, AreaB, Agulha),
	c(X, Y, C, Agulha).

%h1_(E, X, Y, C):-
%	is_cima(E),
%	custo_cima(X, Y, C).
%h1_(E, X, Y, C):-
%	is_cima(E),
%	custo_cima(Y, X, C).

%h1_(E, X, Y, C):-
%	\+is_cima(E),
%	custo_baixo(X, Y, C).

%h1_(E, X, Y, C):-
%	\+is_cima(E),
%	custo_baixo(Y, X, C).


% Custo com a agulha para cima
% c(?Origem, ?Destino, ?Custo, ?Agulha).
c(1, 2, 1, cima).
c(1, 3, 2, cima).
c(1, 4, 2, cima).
c(3, 4, 2, cima).
c(3, 2, 1, cima).
c(2, 4, 3, cima).
% Nao interessa a posicao da agulha
c(X, X, 0, _).
c(4, 1, 1, _).
c(4, 3, 1, _).
c(2, 1, 1, _).
c(2, 3, 1, _).
c(1, 3, 2, _).
c(3, 1, 2, _).
% Custo com a agulha para baixo
c(1, 2, 2, baixo).
c(1, 3, 2, baixo).
c(1, 4, 1, baixo).
c(2, 4, 2, baixo).
c(3, 4, 1, baixo).
c(3, 2, 2, baixo).
c(4, 2, 3, baixo).


heuristica1([ [_, _], [Comboio, _, baixo], [_,_], [_,_]], 2):-
	Comboio \=[].

heuristica1([ [_, _], [_, _, cima], [_,_], [Comboio,_]], 2):-
	Comboio\=[].

heuristica1([ [_, _], [Comboio, _, cima], [_,_], [_,_]], 1):-
	Comboio\=[].

heuristica1([ [_, _], [_, _, baixo], [_,_], [Comboio,_]], 1):-
	Comboio\=[].

% -------------------------- HEURISTICA 2 ------------------------------

h2(E, V):-
	estado_inicial(Ei),
	num_carruagens_comboio(Ei, NC1),
	num_carruagens_comboio(E, NC2),
	NC is NC1 + NC2,
	modulo(NC, V).

modulo(X,Z):-
	X > 0,
	Z = X.

modulo(X,Z):-
	X =< 0,
	Z = -X.
	



num_carruagens_comboio(Areas, N):-
	remove_from( _, Areas, _, Comboio ),
	length(Comboio, N1), N is N1 -1.

% Devolve uma lista com o num de carruagens de carruagens de cada area
num_carruagens_areas([Area], [N]):-
	num_carruagens_area(Area, N).

num_carruagens_areas([Area|Outras], [N|N2]):-
	num_carruagens_area(Area, N),
	num_carruagens_areas(Outras, N2).

num_carruagens_area(Area, N):-
	nth(2, Area, Carruagens),
	length(Carruagens, N).
