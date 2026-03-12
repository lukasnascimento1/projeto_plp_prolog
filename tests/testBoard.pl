:- begin_tests(board).
:- use_module('../src/board').

% Testa se o tabuleiro vazio é gerado corretamente (9x9 com zeros)
test(empty_board) :-
    board_empty(Board),
    length(Board, 9),
    nth0(0, Board, Row),
    length(Row, 9),
    sum_list(Row, 0). % A soma de todos os elementos da linha de zeros deve ser 0

% Testa se a validação de coordenadas aceita os limites corretos
test(valid_coordinates) :-
    validate_coordinates(0, 0),
    validate_coordinates(8, 8).

% Testa se a validação falha para coordenadas fora do limite
% A tag [fail] indica ao plunit que esperamos que este teste retorne false
test(invalid_coordinates_out_of_bounds, [fail]) :-
    validate_coordinates(9, 0).

test(invalid_coordinates_out_of_bounds2, [fail]) :-
    validate_coordinates(0, 9).

test(invalid_coordinates_negative, [fail]) :-
    validate_coordinates(-1, 5).

% Valor válido inserido na linha
test(insert_on_row_valid) :-
    Row = [0,0,0,0,0,0,0,0,0],
    insert_on_row(5, 0, Row, R0), nth0(0, R0, 5),
    insert_on_row(5, 4, Row, R4), nth0(4, R4, 5),
    insert_on_row(5, 8, Row, R8), nth0(8, R8, 5).

% Valor válido inserido em linha inválida (fora do limite)
test(insert_on_row_invalid) :-
    Row = [0,0,0,0,0,0,0,0,0],
    insert_on_row(9, -1, Row, Row),
    insert_on_row(5, 20, Row, Row).

% Testa a inserção de um valor válido no tabuleiro
test(insert_valid_value) :-
    board_empty(B),
    insert_on_board(5, 0, 0, B, NewB, Result),
    Result == ok,
    get_row(0, NewB, Row),
    nth0(0, Row, 5). % Verifica se o 5 realmente está na posição 0 da linha 0

% Testa a tentativa de inserção em uma coordenada inválida
test(insert_invalid_coordinate) :-
    board_empty(B),
    insert_on_board(5, 10, 0, B, NewB, Result),
    Result == error(invalid_coordinates),
    B == NewB. % Garante que o tabuleiro não foi modificado

% Remoção de um valor válido do tabuleiro
test(delete_valid_value) :-
    board_empty(B),
    insert_on_board(5, 2, 2, B, B1, ok),
    delete_from_board(2, 2, B1, B2, ok),
    get_row(2, B2, Row),
    nth0(2, Row, 0).
% Remoção em uma coordenada inválida
test(delete_invalid_coordinate) :-
    board_empty(B),
    delete_from_board(9, 0, B, B, error(invalid_coordinates)).

:- end_tests(board).
