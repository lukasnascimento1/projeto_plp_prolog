empty_board([
[_,_,_,_,_,_,_,_,_],
[_,_,_,_,_,_,_,_,_],
[_,_,_,_,_,_,_,_,_],
[_,_,_,_,_,_,_,_,_],
[_,_,_,_,_,_,_,_,_],
[_,_,_,_,_,_,_,_,_],
[_,_,_,_,_,_,_,_,_],
[_,_,_,_,_,_,_,_,_],
[_,_,_,_,_,_,_,_,_]
]).

get_cell(Board, Row, Col, Value) :-
    nth1(Row, Board, Line),
    nth1(Col, Line, Value).

set_cell(Board, Row, Col, Value, NewBoard) :-
    nth1(Row, Board, Line),
    replace(Line, Col, Value, NewLine),
    replace(Board, Row, NewLine, NewBoard).

replace(List, Index, Elem, NewList) :-
    same_length(List, NewList),
    append(Prefix, [_|Suffix], List),
    length(Prefix, N),
    Index is N+1,
    append(Prefix, [Elem|Suffix], NewList).