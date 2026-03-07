:- consult(board).
:- consult(util).
:- consult(generator).

menu :-
    writeln("Sudoku em Prolog"),
    empty_board(Board),
    print_board(Board),
    nl,
    writeln("Gerando solução..."),
    solve(Board),
    print_board(Board).