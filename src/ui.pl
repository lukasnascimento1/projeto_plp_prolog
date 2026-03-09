:- discontiguous process/3.

print_board(Board) :-
    nl,
    print_rows(Board, 0),
    nl.

print_rows([], _).
print_rows([Row|Rest], Index) :-
    format("~w | ", [Index]),
    print_row(Row),
    nl,
    Next is Index + 1,
    print_rows(Rest, Next).

print_row([]).
print_row([Cell|Rest]) :-
    (Cell =:= 0 -> write('.') ; write(Cell)),
    write(' '),
    print_row(Rest).

print_cells([]).
print_cells([Cell|Rest]) :-
    (Cell =:= 0 -> write('.') ; write(Cell)),
    write(' '),
    print_cells(Rest).


:- use_module(board).

start :-
    board_empty(Board),
    game_loop(Board).

game_loop(Board) :-
    print_board(Board),
    writeln("Digite comando (I-B3-2, D-B3, MENU):"),
    read_command(Str),
    string_upper(Str, StrU),
    ( StrU = "M"
      -> show_commands, NewBoard = Board
      ; parse_command(StrU, Action, Row, Col, Value)
        -> execute(Action, Row, Col, Value, Board, NewBoard)
      ; writeln("Comando invalido"), NewBoard = Board
    ),
    game_loop(NewBoard).

process(insert(_,_,_), Board, NewBoard) :-
    insert_mode(Board, NewBoard).

process(delete(_,_), Board, NewBoard) :-
    delete_mode(Board, NewBoard).

insert_mode(Board, NewBoard) :-
    write('Digite coordenada (ex: d4).'), nl,
    read(Coord),
    coord_to_index(Coord, Row, Col),
    write('Valor (1..9): '), nl,
    read(Value),
    board:insert_on_board(Value, Row, Col, Board, NewBoard, Result),
    write(Result), nl.

delete_mode(Board, NewBoard) :-
    write('Digite coordenada (ex: d4).'), nl,
    read(Coord),
    coord_to_index(Coord, Row, Col),
    board:delete_from_board(Row, Col, Board, NewBoard, Result),
    write(Result), nl.

process(_, Board, Board) :-
    write('Comando invalido.'), nl.

validate_board(_Board) :-
    write('Validacao ainda nao implementada.'), nl.

show_commands :-
    nl,
    write('Comandos disponiveis:'), nl,
    write('  insert(Row,Col,Val).'), nl,
    write('  delete(Row,Col).'), nl,
    write('  validate.'), nl,
    write('  exit.'), nl,
    nl.

read_command(Command) :-
    read_line_to_string(user_input, Command).

coord_to_index(Coord, Row, Col) :-
    string_chars(Coord, [ColChar,RowChar]),
    char_code(ColChar, CodeCol),
    Col is CodeCol - 65,   % 'A' -> 0
    char_code(RowChar, CodeRow),
    Row is CodeRow - 49.   % '1' -> 0

action("I", insert).
action("D", delete).

parse_command(String, Action, Row, Col, Value) :-
    split_string(String, "-", "", [Act,Coord,ValStr]),
    string_upper(Act, ActU),
    string_upper(Coord, CoordU),
    atom_string(ValueAtom, ValStr),
    atom_number(ValueAtom, Value),
    coord_to_index(CoordU, Row, Col),
    action(ActU, Action).

parse_command(String, menu, 0, 0, 0) :-
    normalize_space(string(Clean), String),
    string_upper(Clean, "M").

execute(insert, Row, Col, Value, Board, NewBoard) :-
    board:insert_on_board(Value, Row, Col, Board, NewBoard, Result),
    writeln(Result).

execute(delete, Row, Col, _, Board, NewBoard) :-
    board:delete_from_board(Row, Col, Board, NewBoard, Result),
    writeln(Result).