:- module(util, [
    color_cell/1,
    clear_screen/0,
    print_header/0
]).

/* Predicado para colorir células*/
color_cell(Value) :-
    ( Value =:= 0 ->
        write('\033[90m.\033[0m ')     % cinza
    ;
        format('\033[36m~w\033[0m ', [Value]) % ciano
    ).


/*Efeito de limpar a tela*/
clear_screen :-
    write('\033[2J'),
    write('\033[H').

print_header :-
    writeln("    A B C D E F G H I").