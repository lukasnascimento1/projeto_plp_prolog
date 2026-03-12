/*
* Módulo responsável pela validação da solução no tabuleiro.
*/

:- module(validation, [
    is_solution_valid/1
]).

:- use_module(board).
:- use_module(generator). % Para usar get_column e get_box
:- use_module(library(lists)).

/*
* verifica se uma sequência (linha, coluna ou box) contém exatamente os números de 1 a 9
*/
is_sequence_valid(Sequence) :-
    msort(Sequence, Sorted), 
    Sorted = [1, 2, 3, 4, 5, 6, 7, 8, 9].

/*
* verifica se todas as linhas formam uma sequência válida
*/
are_all_rows_valid(Board) :-
    forall(between(0, 8, R), 
           (board:get_row(R, Board, Row), is_sequence_valid(Row))).

/*
* verifica se todas as colunas formam uma sequência válida
*/
are_all_columns_valid(Board) :-
    forall(between(0, 8, C), 
           (generator:get_column(C, Board, Column), is_sequence_valid(Column))).

/*
* verifica se todas as submatrizes 3x3 (boxes) formam uma sequência válida
*/
are_all_boxes_valid(Board) :-
    StartingPoints = [0, 3, 6],
    forall((member(R, StartingPoints), member(C, StartingPoints)),
           (generator:get_box(R, C, Board, Box), is_sequence_valid(Box))).

/*
* verifica se a solução cumpre todos os requisitos do Sudoku
*/
is_solution_valid(Board) :-
    are_all_rows_valid(Board),
    are_all_columns_valid(Board),
    are_all_boxes_valid(Board).
