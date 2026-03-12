/*
Utilidades para UI

Definição de regras de cor, predicados para colorir textos e animações
E predicados de funções auxiliares para o sistema

Autor: @lukasnascimento1
*/

:- module(util, [
    clear_screen/0,
    print_sudoku_logo_color/1,
    print_sudoku_logo_color_animation/2,
    print_color/2,
    print_color_and_delay/3,
    text_color/2,
    color_text/3,
    board_header/1,
    tutorial/0,
    about/0,
    coord_to_index/3
]).

/* ================================
   Limpar tela
   ================================ */

clear_screen :-
    write('\033[2J'),
    write('\033[H').

board_header("    A B C D E F G H I").


/* ================================
   Definição de cores
   ================================ */

text_color(weak_white, "\033[2;37m").
text_color(weak_green, "\033[2;32m").
text_color(weak_blue,  "\033[2;34m").
text_color(weak_cyan,  "\033[2;36m").
text_color(weak_yellow,"\033[2;93m").

text_color(magenta, "\033[95m").
text_color(grid_green, "\033[92m").
text_color(cyan_fixed, "\033[96m").
text_color(cyan, "\033[36m").
text_color(red,  "\033[31m").
text_color(green,"\033[92m").
text_color(yellow,"\033[93m").

text_color(bold,"\033[1m").

reset_color("\033[0m").


/* ================================
   Tutorial
   ================================ */

tutorial_lines([
    "[I-A9-X] é o comando para INSERIR um número",
    "[D-B7] é o comando para DELETAR um número",
    " ^^  Ao selecionar essas ações acima você precisará inserir as coordenadas ('A1','D7','I9')",
    "[V] Verificar solução",
    "[M] Exibe o menu de ações"
]).

menu_lines([
    "[A] Sobre o Sudoku",
    "[T] Tutorial",
    "[R] Reiniciar",
    "[Q] Sair",
    "Qualquer outra tecla inicia o jogo"]).

color_command_line(Line, Colored) :-
    ( sub_string(Line, Before, _, After, "]")
    ->
        End is Before + 1,
        sub_string(Line, 0, End, _, Prefix),
        sub_string(Line, End, _, 0, Rest),

        color_text(Prefix, yellow, CP),
        color_text(Rest, green, CR),

        format(string(Colored), "~w~w", [CP, CR])
    ;
        color_text(Line, green, Colored)
    ).

tutorial :-
    tutorial_lines(Lines),
    maplist(print_tutorial_line, Lines).

print_tutorial_line(Line) :-
    color_command_line(Line, Colored),
    writeln(Colored).

print_menu_line(Line) :-
    color_command_line(Line, Colored),
    writeln(Colored).


/* ================================
   Sobre o jogo
   ================================ */

about :-
    print_color(
        "\nSUDOKU é um jogo de lógica em que se preenche uma grade 9×9 com números de 1 a 9, sem repetir valores em linhas, colunas e regiões 3×3.\n",
        green).


/* ================================
   Logo do Sudoku
   ================================ */

sudoku_logo([
    " ██████╗ ██╗   ██╗██████╗  ██████╗ ██╗  ██╗██╗   ██╗",
    "██╔════╝ ██║   ██║██╔══██╗██╔═══██╗██║ ██╔╝██║   ██║",
    "╚█████╗  ██║   ██║██║  ██║██║   ██║█████╔╝ ██║   ██║",
    " ╚═══██╗ ██║   ██║██║  ██║██║   ██║██╔═██╗ ██║   ██║",
    "██████╔╝ ╚██████╔╝██████╔╝╚██████╔╝██║  ██╗╚██████╔╝",
    "╚═════╝   ╚═════╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═╝ ╚═════╝"
]).


/* ================================
   Coloração de texto
   ================================ */

color_text(Text, ColorName, Colored) :-
    text_color(ColorName, Code),
    reset_color(Reset),
    format(string(Colored), "~w~w~w", [Code, Text, Reset]).

print_color(Text, ColorName) :-
    color_text(Text, ColorName, Colored),
    writeln(Colored).


/* ================================
   Impressão da logo
   ================================ */

print_color_line(Color, Line) :-
    print_color(Line, Color).

print_sudoku_logo_color(Color) :-
    sudoku_logo(Linhas),
    maplist(print_color_line(Color), Linhas).


/* ================================
   Logo com animação
   ================================ */

print_logo_line_animation(Color, Time, Line) :-
    print_color_and_delay(Line, Color, Time).

print_sudoku_logo_color_animation(Color, Time) :-
    sudoku_logo(Linhas),
    maplist(print_logo_line_animation(Color, Time), Linhas).


/* ================================
   Impressão com delay
   ================================ */

print_color_and_delay(Text, ColorName, Time) :-
    print_color(Text, ColorName),
    sleep(Time).


/* ================================
   Conversão de coordenadas
   ================================ */

coord_to_index(Coord, Row, Col) :-
    string_chars(Coord, [ColChar,RowChar]),
    char_code(ColChar, CodeCol),
    Col is CodeCol - 65,
    char_code(RowChar, CodeRow),
    Row is CodeRow - 49.