solve(Board) :-
    member(Row, Board),
    member(Cell, Row),
    var(Cell),
    between(1,9,Value),
    Cell = Value,
    solve(Board).

solve(_).