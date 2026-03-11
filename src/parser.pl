/*
Módulo dedicado a interpretar comandos

Autor: @lukasnascimento1
*/

:- module(parser, [
    parse_command/5,
    execute/6
]).

:- use_module(board).
:- use_module(util).


/*Mapeamento de comando*/
action_in_game("I", insert).
action_in_game("D", delete).

/*
Interpreta comandos do usuário no formato:
   I-B3-2  -> inserir valor naquela coordenada
   D-B3    -> remover valor daquela coordenada
   M       -> mostrar menu de comandos
Converte a string em ação e coordenadas utilizáveis pelo sistema.
*/
parse_command(String, Action, Row, Col, Value) :-
    split_string(String, "-", "", [Act,Coord,ValStr]),
    string_upper(Act, ActU),
    string_upper(Coord, CoordU),
    atom_string(ValueAtom, ValStr),
    atom_number(ValueAtom, Value),
    coord_to_index(CoordU, Row, Col),
    action_in_game(ActU, Action).

parse_command(String, menu, 0, 0, 0) :-
    normalize_space(string(Clean), String),
    string_upper(Clean, "M").


/* Função para detectar comando inválido */
process(_, Board, Board) :-
    write('Comando invalido.'), nl.

/* Mapeamento da dificuldade escolhida pelo usuário para gerar o tabuleiro correspodente */
parse_difficulty("f", easy).
parse_difficulty("facil", easy).
parse_difficulty("d", hard).
parse_difficulty("dificil", hard).

/*  Executa a ação solicitada pelo usuário.
    Actions:
    insert -> insere um valor no tabuleiro
    delete -> remove um valor do tabuleiro
    Retorna o novo estado do tabuleiro em NewBoard.
*/
execute(insert, Row, Col, Value, Board, NewBoard) :-
    board:insert_on_board(Value, Row, Col, Board, NewBoard, Result),
    writeln(Result).

execute(delete, Row, Col, _, Board, NewBoard) :-
    board:delete_from_board(Row, Col, Board, NewBoard, Result),
    writeln(Result).