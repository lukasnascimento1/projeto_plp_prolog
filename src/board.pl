:- module(board, [
    board_empty/1,                 % -Board
    validate_coordinates/2,         % +Row +Col
    insert_on_row/4,                % +Value +Index +Row -NewRow
    insert_on_board/6,              % +Value +Row +Col +Board -NewBoard -Result
    get_row/3,                      % +RowIndex +Board -Row
    delete_from_board/5             % +Row +Col +Board -NewBoard -Result
]).

/*
  Representação (recomendada):
    - Board = lista de 9 linhas
    - Cada linha = lista de 9 inteiros
    - 0 = vazio; 1..9 = preenchido
    - Coordenadas Row/Col: 0..8 (igual ao Haskell)
*/

% Result = ok | error(invalid_coordinates)

board_empty(Board) :-
    % Gera um tabuleiro vazio (9x9 com zeros)
    length(Row, 9),
    maplist(=(0), Row),
    length(Board, 9),
    maplist(=(Row), Board).

validate_coordinates(Row, Col) :-
    % verifica se as coordenadas estão dentro dos limites do tabuleiro
    integer(Row), integer(Col),
    Row >= 0, Row < 9,
    Col >= 0, Col < 9.

insert_on_row(_Value, Index, Row, NewRow) :-
    % insert_on_row em caso de fracasso retorna a mesma linha sem alterações
    (   Index < 0
    ;   length(Row, Len),
        Index >= Len
    ),
    !,
    NewRow = Row.
insert_on_row(Value, Index, Row, NewRow) :-
    % insert_on_row em caso de sucesso retorna a nova linha com o valor inserido
    same_length(Row, NewRow),
    nth0(Index, Row, _Old, Rest),
    nth0(Index, NewRow, Value, Rest).

insert_on_board(Value, Row, Col, Board, NewBoard, Result) :-
    % Insere um valor no tabuleiro em posição (Row, Col)
    (   validate_coordinates(Row, Col)
    ->  same_length(Board, NewBoard),
        nth0(Row, Board, OldRow, BoardRest),
        insert_on_row(Value, Col, OldRow, NewRow),
        nth0(Row, NewBoard, NewRow, BoardRest),
        Result = ok
    ;   NewBoard = Board,
        Result = error(invalid_coordinates)
    ).

get_row(RowIndex, Board, Row) :-
    % Retorna a linha do tabuleiro correspondente ao índice fornecido
    nth0(RowIndex, Board, Row).

delete_from_board(Row, Col, Board, NewBoard, Result) :-
    % Remove um valor do tabuleiro (substitui por 0)
    insert_on_board(0, Row, Col, Board, NewBoard, Result).
