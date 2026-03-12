:- use_module(library(plunit)).
:- begin_tests(validation).
:- use_module('../src/validation').
:- use_module('../src/board').

test(sequence_valid) :-
    Sequence = [5, 6, 9, 4, 8, 1, 2, 3, 7],
    validation:is_sequence_valid(Sequence).

test(sequence_invalid_with_zero, [fail]) :-
    Sequence = [5, 0, 9, 4, 8, 1, 2, 3, 7],
    validation:is_sequence_valid(Sequence).

test(sequence_invalid_duplicate, [fail]) :-
    Sequence = [5, 6, 9, 4, 6, 1, 2, 3, 7], % Note o '6' repetido
    validation:is_sequence_valid(Sequence).

test(empty_board_invalid, [fail]) :-
    board_empty(Board),
    validation:is_solution_valid(Board).

:- end_tests(validation).

run_validation_tests :-
    run_tests(validation).