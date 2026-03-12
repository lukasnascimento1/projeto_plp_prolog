/*
Interface de usuário para o jogo Sudoku.
*/

:- module(ui, [start/0]).

:- use_module(board).
:- use_module(generator).
:- use_module(util).
:- use_module(parser).


/* =========================
   Predicado principal
   ========================= */

start :-
    intro,
    menu_loop(Difficulty),
    generate_board(Difficulty, Board),
    build_fixed(Board, Fixed),
    game_loop(Board, Fixed).


/* =========================
   Geração do tabuleiro
   ========================= */

generate_board(easy, Board) :-
    generator:generate_easy(Board).

generate_board(hard, Board) :-
    generator:generate_hard(Board).


/* =========================
   Construção da máscara fixa
   ========================= */

build_fixed(Board, Fixed) :-
    maplist(build_fixed_row, Board, Fixed).

build_fixed_row(Row, FixedRow) :-
    maplist(cell_fixed, Row, FixedRow).

cell_fixed(0, false).
cell_fixed(_, true).


/* =========================
   Menu inicial
   ========================= */

menu_loop(Difficulty) :-
    repeat,
    show_menu,
    actions(Action),
    process_menu(Action, Difficulty),
    Difficulty \= none.


show_menu :-
    clear_screen,
    print_sudoku_logo_color(yellow),
    nl,
    print_color(
        "[A] Sobre o Sudoku\n[T] Tutorial\n[J] Jogar\n[Q] Sair\n",
        green).


actions(Action) :-
    read_line_to_string(user_input, Input),
    ( Input = "" ->
        Action = none
    ;
        string_upper(Input, Upper),
        string_chars(Upper, [Action|_])
    ).


/* =========================
   Processamento do menu
   ========================= */

process_menu(none, none) :- !.

process_menu('A', none) :-
    clear_screen,
    about,
    wait_enter.

process_menu('T', none) :-
    clear_screen,
    tutorial,
    wait_enter.

process_menu('Q', _) :-
    writeln("Saindo do jogo..."),
    halt.

process_menu('J', Difficulty) :-
    choose_difficulty(Difficulty).

process_menu(_, none).

wait_enter :-
    print_color("Pressione Enter para voltar ao menu.", weak_green),
    read_line_to_string(user_input, _).


/* =========================
   Escolha da dificuldade
   ========================= */

choose_difficulty(Difficulty) :-
    clear_screen,
    print_color("Escolha a dificuldade:", green),
    print_color("  f -> facil", green),
    print_color("  d -> dificil", green),
    read_line_to_string(user_input, Input),
    string_lower(Input, L),
    parse_difficulty(L, Difficulty).

/* Mapeamento da dificuldade escolhida pelo usuário para gerar o tabuleiro correspodente */
parse_difficulty("f", easy).
parse_difficulty("facil", easy).
parse_difficulty("d", hard).
parse_difficulty("dificil", hard).

/* =========================
   Loop principal do jogo
   ========================= */

game_loop(Board, Fixed) :-
    clear_screen,
    print_board(Board, Fixed),
    print_color("Digite um comando (I-B3-2, D-B3, V, M, R, Q):", green),
    read_command(Str),
    string_upper(Str, StrU),

    ( StrU = "Q"
        -> writeln("Saindo do jogo..."), !

    ; StrU = "M"
        -> tutorial,
           wait_enter,
           game_loop(Board, Fixed)

    ; StrU = "V"
        -> check_board(Board),
           wait_enter,
           game_loop(Board, Fixed)
    
    ; StrU = "R"
    -> start

    ; parser:parse_command(StrU, Action, Row, Col, Value)
        -> execute(Action, Row, Col, Value, Board, Fixed, NewBoard),
           game_loop(NewBoard, Fixed)

    ; print_color("Comando invalido", red),
      wait_enter,
      game_loop(Board, Fixed)
    ).

check_board(Board) :-
    ( sudoku_correct(Board)
        -> print_color("Parabéns! O Sudoku está correto!", green)
        ;  print_color("O tabuleiro ainda possui erros.", red)
    ).

/* =========================
   Execução protegida
   ========================= */

execute(insert, Row, Col, _, Board, Fixed, Board) :-
    nth0(Row, Fixed, FR),
    nth0(Col, FR, true),
    print_color("Essa célula pertence ao puzzle e não pode ser alterada.", red),
    !.

execute(insert, Row, Col, Value, Board, _, NewBoard) :-
    board:insert_on_board(Value, Row, Col, Board, NewBoard, Result),
    writeln(Result).

execute(delete, Row, Col, _, Board, Fixed, Board) :-
    nth0(Row, Fixed, FR),
    nth0(Col, FR, true),
    print_color("Essa célula pertence ao puzzle e não pode ser removida.", red),
    !.

execute(delete, Row, Col, _, Board, _, NewBoard) :-
    board:delete_from_board(Row, Col, Board, NewBoard, Result),
    writeln(Result).


/* =========================
   Introdução
   ========================= */

intro :-
    print_color_and_delay(
        "Pratique seu raciocínio lógico com...", green, 0.3),
    print_sudoku_logo_color_animation(yellow, 0.08).


/* =========================
   Leitura de comando
   ========================= */

read_command(Command) :-
    read_line_to_string(user_input, Command).


/* =========================
   Impressão do tabuleiro
   ========================= */

print_board(Board, Fixed) :-
    nl,
    print_column_header,
    print_rows(Board, Fixed, 1),
    nl.


/* coordenadas */
print_column_header :-
    util:color_text("    A B C   D E F   G H I", magenta, H),
    writeln(H).


print_rows([], [], _).

print_rows([Row|Rest], [FRow|FRest], I) :-
    (I =:= 4 ; I =:= 7),
    print_separator,
    print_row(Row, FRow, I),
    I2 is I + 1,
    print_rows(Rest, FRest, I2).

print_rows([Row|Rest], [FRow|FRest], I) :-
    print_row(Row, FRow, I),
    I2 is I + 1,
    print_rows(Rest, FRest, I2).


print_separator :-
    util:color_text("   ------+-------+------", weak_white, S),
    writeln(S).


print_row(Row, FixedRow, Index) :-
    number_string(Index, S),
    util:color_text(S, magenta, IStr),
    format("~w | ", [IStr]),
    print_cells(Row, FixedRow, 1),
    nl.


print_cells([], [], _).

print_cells([Cell|Rest], [Fix|FRest], Col) :-
    print_cell(Cell, Fix),

    ( (Col =:= 3 ; Col =:= 6)
        -> write(" | ")
        ;  write(" ")
    ),

    Next is Col + 1,
    print_cells(Rest, FRest, Next).


print_cell(0, _) :-
    util:color_text(".", weak_white, T),
    write(T).

print_cell(Value, true) :-
    number_string(Value, S),
    util:color_text(S, weak_cyan, T),      % número original
    write(T).

print_cell(Value, false) :-
    number_string(Value, S),
    util:color_text(S, yellow, T),    % número inserido pelo jogador
    write(T).