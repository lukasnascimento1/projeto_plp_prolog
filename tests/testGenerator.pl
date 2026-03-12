:- begin_tests(generator).
:- use_module('../src/board').
:- use_module('../src/generator').

test(get_column_empty) :-
    board_empty(B),
    get_column(0, B, Col),
    length(Col, 9),
    maplist(=(0), Col).

test(get_box_empty) :-
    board_empty(B),
    get_box(0, 0, B, Box0),
    length(Box0, 9),
    maplist(=(0), Box0),
    get_box(5, 5, B, Box5),
    maplist(=(0), Box5).

test(is_position_valid_tests) :-
    board_empty(B),
    is_position_valid(1, 0, 0, B),
    insert_on_board(1, 0, 0, B, B1, ok),
    \+ is_position_valid(1, 0, 1, B1),
    \+ is_position_valid(1, 1, 0, B1),
    \+ is_position_valid(1, 1, 1, B1),
    is_position_valid(2, 0, 1, B1).

test(find_empty_positions_all) :-
    board_empty(B),
    find_empty_positions(B, Empties),
    length(Empties, 81). % 9x9 = 81

test(find_empty_positions_partial) :-
    board_empty(B),
    insert_on_board(1, 0, 0, B, B1, ok),
    find_empty_positions(B1, Empties),
    length(Empties, 80),
    \+ member((0,0), Empties).

test(delete_from_board_invalid) :-
    board_empty(B),
    delete_from_board(-1, 0, B, _, _).

test(solve_valid) :-
    board_empty(B),
    once(solve(B, Solution)),
    length(Solution, 9),
    nth0(0, Solution, Row0),
    nth0(0, Row0, Val),
    Val >= 1, Val =< 9.

:- end_tests(generator).