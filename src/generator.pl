:- module(generator, [
    generate_filled_board/1,
    generate_easy/1,
    generate_hard/1,
    solve/2,
    find_empty_positions/2,
    is_position_valid/4,
    get_column/3,
    get_box/4,
    remove_numbers/3
]).

:- use_module(board).
:- use_module(library(random), [random/3]).

get_column(_, [], []).
get_column(Column, [Row|RestRows], [Element|RestColumn]) :-
    nth0(Column, Row, Element),
    get_column(Column, RestRows, RestColumn).

get_box(Row, Col, Board, Box) :-
    StartRow is (Row // 3) * 3,
    StartCol is (Col // 3) * 3,
    get_box_elements(StartRow, StartCol, Board, Box).

get_box_elements(StartRow, StartCol, Board, [E1,E2,E3,E4,E5,E6,E7,E8,E9]) :-
    R0 is StartRow, C0 is StartCol,
    nth0(R0, Board, Row0), nth0(C0, Row0, E1),
    C1 is StartCol + 1, nth0(C1, Row0, E2),
    C2 is StartCol + 2, nth0(C2, Row0, E3),
    R1 is StartRow + 1, nth0(R1, Board, Row1), nth0(C0, Row1, E4),
    nth0(C1, Row1, E5), nth0(C2, Row1, E6),
    R2 is StartRow + 2, nth0(R2, Board, Row2), nth0(C0, Row2, E7),
    nth0(C1, Row2, E8), nth0(C2, Row2, E9).

is_position_valid(Value, Row, Col, Board) :-
    get_row(Row, Board, RowList),
    \+ member(Value, RowList),
    get_column(Col, Board, ColList),
    \+ member(Value, ColList),
    get_box(Row, Col, Board, BoxList),
    \+ member(Value, BoxList).

find_empty_positions(Board, Positions) :-
    findall((R, C), 
            (between(0, 8, R), 
             between(0, 8, C), 
             nth0(R, Board, Row), 
             nth0(C, Row, 0)), 
            Positions).

shuffle_list([], []).
shuffle_list(List, Shuffled) :-
    length(List, Len),
    Len > 0,
    random(0, Len, Index),
    nth0(Index, List, Element),
    delete(List, Element, Rest),
    shuffle_list(Rest, RestShuffled),
    Shuffled = [Element|RestShuffled].

solve(Board, Solution) :-
    find_empty_positions(Board, EmptyPositions),
    solve_aux(Board, EmptyPositions, Solution).

solve_aux(Board, [], Board).
solve_aux(Board, [(Row, Col)|RestPositions], Solution) :-
    Numbers = [1,2,3,4,5,6,7,8,9],
    shuffle_list(Numbers, ShuffledNumbers),
    try_numbers(Board, Row, Col, ShuffledNumbers, RestPositions, Solution).

try_numbers(_Board, _Row, _Col, [], _RestPositions) :- 
    fail.
try_numbers(Board, Row, Col, [Num|_], RestPositions, Solution) :-
    is_position_valid(Num, Row, Col, Board),
    insert_on_board(Num, Row, Col, Board, NewBoard, ok),
    solve_aux(NewBoard, RestPositions, Solution).
try_numbers(Board, Row, Col, [_|RestNums], RestPositions, Solution) :-
    try_numbers(Board, Row, Col, RestNums, RestPositions, Solution).

generate_filled_board(Board) :-
    board_empty(EmptyBoard),
    solve(EmptyBoard, Board).

remove_numbers(0, Board, Board).
remove_numbers(N, Board, NewBoard) :-
    N > 0,
    random(0, 9, Row),
    random(0, 9, Col),
    nth0(Row, Board, RowData),
    nth0(Col, RowData, Value),
    Value \= 0,
    insert_on_board(0, Row, Col, Board, TempBoard, ok),
    N1 is N - 1,
    remove_numbers(N1, TempBoard, NewBoard).
remove_numbers(N, Board, NewBoard) :-
    N > 0,
    remove_numbers(N, Board, NewBoard).

generate_easy(Board) :-
    generate_filled_board(FullBoard),
    remove_numbers(35, FullBoard, Board).

generate_hard(Board) :-
    generate_filled_board(FullBoard),
    remove_numbers(60, FullBoard, Board).
