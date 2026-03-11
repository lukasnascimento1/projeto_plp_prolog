/*
Interface de usuário para o jogo Sudoku.
*/

:- module(ui, [start/0]).

:- use_module(board).
:- use_module(generator).
:- use_module(util).
:- use_module(parser).


/* =========================
   Geração do tabuleiro
   ========================= */

generate_board(easy, Board) :-
    generator:generate_easy(Board).

generate_board(hard, Board) :-
    generator:generate_hard(Board).


/* =========================
   Predicado principal
   ========================= */

start :-
    intro,
    menu_loop(Difficulty),
    generate_board(Difficulty, Board),
    game_loop(Board).


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
        "[A] Sobre o Sudoku\n[T] Tutorial\n[Q] Sair\nQualquer outra tecla inicia o jogo\n",
        green).

actions(Action) :-
    read_line_to_string(user_input, Input),
    string_upper(Input, Upper),
    string_chars(Upper, [Action|_]).

process_menu('A', none) :-
    clear_screen,
    about,
    wait_enter.

process_menu('T', none) :-
    clear_screen,
    tutorial,
    wait_enter.

process_menu('Q', quit) :-
    writeln("Saindo do jogo...").


wait_enter :-
    print_color("Pressione Enter para voltar ao menu.", weak_green),
    read_line_to_string(user_input, _).

/* =========================
   Escolha da dificuldade
   ========================= */

choose_difficulty(Difficulty) :-
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
    print_board(Board),
    writeln("Digite um comando (I-B3-2, D-B3, M, Q):"),
    read_command(Str),
    string_upper(Str, StrU),

    ( StrU = "Q"
        -> writeln("Saindo do jogo..."), !

    ; StrU = "M"
        -> tutorial,
           NewBoard = Board,
           game_loop(NewBoard)

    ; parser:parse_command(StrU, Action, Row, Col, Value)
        -> parser:execute(Action, Row, Col, Value, Board, NewBoard),
           game_loop(NewBoard)

    ; writeln("Comando invalido"),
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
    ( Cell =:= 0 -> write('.') ; write(Cell) ),
    write(' '),
    print_row(Rest).


print_cells([]).
print_cells([Cell|Rest]) :-
    ( Cell =:= 0 -> write('.') ; write(Cell) ),
    write(' '),
    print_cells(Rest).