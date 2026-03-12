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
    game_loop(Board).


/* =========================
   Geração do tabuleiro
   ========================= */

generate_board(easy, Board) :-
    generator:generate_easy(Board).

generate_board(hard, Board) :-
    generator:generate_hard(Board).


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

process_menu(none, none) :-
    !.

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


parse_difficulty("f", easy).
parse_difficulty("facil", easy).
parse_difficulty("d", hard).
parse_difficulty("dificil", hard).


/* =========================
   Loop principal do jogo
   ========================= */

game_loop(Board) :-
    clear_screen,
    print_board(Board),
    writeln("Digite um comando (I-B3-2, D-B3, M, Q):"),
    read_command(Str),
    string_upper(Str, StrU),

    ( StrU = "Q"
        -> writeln("Saindo do jogo..."), !

    ; StrU = "M"
        -> tutorial,
           wait_enter,
           game_loop(Board)

    ; parser:parse_command(StrU, Action, Row, Col, Value)
        -> parser:execute(Action, Row, Col, Value, Board, NewBoard),
           game_loop(NewBoard)

    ; writeln("Comando invalido"),
      wait_enter,
      game_loop(Board)
    ).


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
/* =========================
   Impressão do tabuleiro
   ========================= */

print_board(Board) :-
    nl,
    print_column_header,
    print_rows(Board, 1),
    nl.


/* Cabeçalho */

print_column_header :-
    util:color_text("    A B C   D E F   G H I", cyan, Header),
    writeln(Header).


/* Impressão das linhas */

print_rows([], _).

print_rows([Row|Rest], Index) :-
    ( Index =:= 4 ; Index =:= 7 ),
    print_separator,
    print_row(Row, Index),
    Next is Index + 1,
    print_rows(Rest, Next).

print_rows([Row|Rest], Index) :-
    print_row(Row, Index),
    Next is Index + 1,
    print_rows(Rest, Next).


/* Linha separadora dos blocos */

print_separator :-
    util:color_text("   ------+-------+------", weak_white, Sep),
    writeln(Sep).


/* Impressão de uma linha */

print_row(Row, Index) :-
    format("~w | ", [Index]),
    print_cells(Row, 1),
    nl.


/* Impressão das células */

print_cells([], _).

print_cells([Cell|Rest], Col) :-
    print_cell(Cell),

    ( Col =:= 3 ; Col =:= 6 ->
        write("| ")
    ;   write(" ")
    ),

    Next is Col + 1,
    print_cells(Rest, Next).


/* Impressão de cada célula */

print_cell(0) :-
    util:color_text(".", weak_white, T),
    write(T).

print_cell(Value) :-
    number_string(Value, S),
    util:color_text(S, yellow, T),
    write(T).