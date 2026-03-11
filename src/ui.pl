/*
Interface de usuário para o jogo Sudoku.

Responsabilidades deste módulo:
    - Inicializar o jogo;
    - Solicitar a dificuldade ao usuário (fácil ou difícil);
    - Gerar o tabuleiro inicial utilizando o módulo generator.pl;
    - Exibir o estado atual do tabuleiro no terminal;
    - Ler e interpretar comandos do usuário;
    - Executar operações de inserção e remoção de valores;
    - Manter o loop principal do jogo até seu encerramento.

Dependências:
    board.pl      -> manipulação e atualização do tabuleiro
    generator.pl  -> geração de tabuleiros Sudoku (fácil e difícil)

Autor: @lukasnascimento1
*/

:- discontiguous process/3. 
:- use_module(board).
:- use_module(generator).
:- use_module(util).


/* 
Exibe o tabuleiro Sudoku no terminal.
Recebe um tabuleiro representado como uma lista de listas (9x9)
e imprime cada linha numerada. Células com valor 0 são exibidas como '.'.
*/
print_board(Board) :-
    nl,
    print_header,
    print_rows(Board, 0),
    nl.

/*
Percorre todas as linhas do tabuleiro imprimindo cada uma delas.
Index representa o número da linha atual exibido ao lado do tabuleiro.
*/
print_rows([], _).
print_rows([Row|Rest], Index) :-
    format("~w | ", [Index]),
    print_row(Row),
    nl,
    Next is Index + 1,
    print_rows(Rest, Next).

/*
Imprime uma única linha do tabuleiro.
Substitui valores 0 por '.' para indicar células vazias.
*/
print_row([]).
print_row([Cell|Rest]) :-
    (Cell =:= 0 -> write('.') ; write(Cell)),
    write(' '),
    print_row(Rest).

print_cells([]).
print_cells([Cell|Rest]) :-
    (Cell =:= 0 -> write('.') ; write(Cell)),
    write(' '),
    print_cells(Rest).

/*
Solicita ao usuário a escolha da dificuldade do jogo.
Os níveis de dificuldade são Fácil e Difícil. 
Os níveis de dificuldade se diferenciam pela porcentagem de 
células do tabuleiro já preenchidas
*/
choose_difficulty(Difficulty) :-
    writeln("Escolha a dificuldade:"),
    writeln("  f -> facil"),
    writeln("  d -> dificil"),
    read_line_to_string(user_input, Input),
    string_lower(Input, L),
    parse_difficulty(L, Difficulty).

/*Mapeamento da dificuldade escolhida pelo usuário para gerar o tabuleiro correspodente*/
parse_difficulty("f", easy).
parse_difficulty("facil", easy).
parse_difficulty("d", hard).
parse_difficulty("dificil", hard).

/*Definição do tabuleiro a ser gerado*/
generate_board(easy, Board) :-
    generator:generate_easy(Board).

generate_board(hard, Board) :-
    generator:generate_hard(Board).

/*Predicado principal do programapara.
Inicia o sistema, solicita a dificuldade, gera o tabuleiro
e inicia o loop do game
*/
start :-
    choose_difficulty(Difficulty),
    generate_board(Difficulty, Board),
    game_loop(Board).

/*
Persistência do jogo
Aqui estão a exibição dos estados atuais do tabuleiro e
a captura de comandos e entradas do usuário
*/
game_loop(Board) :-
    print_board(Board),
    writeln("Digite comando (I-B3-2, D-B3, MENU):"),
    read_command(Str),
    string_upper(Str, StrU),
    ( StrU = "M"
      -> show_commands, NewBoard = Board
      ; parse_command(StrU, Action, Row, Col, Value)
        -> execute(Action, Row, Col, Value, Board, NewBoard)
      ; writeln("Comando invalido"), NewBoard = Board
    ),
    game_loop(NewBoard).


process(insert(_,_,_), Board, NewBoard) :-
    insert_mode(Board, NewBoard).

process(delete(_,_), Board, NewBoard) :-
    delete_mode(Board, NewBoard).

/*Fluxo para inserir número no tabuleiro*/
insert_mode(Board, NewBoard) :-
    write('Digite coordenada (ex: d4).'), nl,
    read(Coord),
    coord_to_index(Coord, Row, Col),
    write('Valor (1..9): '), nl,
    read(Value),
    board:insert_on_board(Value, Row, Col, Board, NewBoard, Result),
    write(Result), nl.

/*Fluxo para deletar número no tabuleiro*/
delete_mode(Board, NewBoard) :-
    write('Digite coordenada (ex: d4).'), nl,
    read(Coord),
    coord_to_index(Coord, Row, Col),
    board:delete_from_board(Row, Col, Board, NewBoard, Result),
    write(Result), nl.

/*Função para detectar comando inválido*/
process(_, Board, Board) :-
    write('Comando invalido.'), nl.

/*Função para validar o tabuleiro como correto/finalizado, ou não*/
validate_board(_Board) :-
    write('Validacao ainda nao implementada.'), nl.

/*Lista de comandos que o usuário pode utilizar no jogo*/
show_commands :-
    nl,
    write('Comandos disponiveis:'), nl,
    write('  insert(Row,Col,Val).'), nl,
    write('  delete(Row,Col).'), nl,
    write('  validate.'), nl,
    write('  exit.'), nl,
    nl.

/*Função para ler comando do usuário*/
read_command(Command) :-
    read_line_to_string(user_input, Command).

/*
Mapeamento da coordenada inserida pelo o usuário
para indíces válidos da matriz do tabuleiro
Exemplo: 
    "A1" -> Linha, Coluna = (0,0)
    "i9" -> Linha, Coluna = (8,8)
*/
coord_to_index(Coord, Row, Col) :-
    string_chars(Coord, [ColChar,RowChar]),
    char_code(ColChar, CodeCol),
    Col is CodeCol - 65,   % 'A' -> 0
    char_code(RowChar, CodeRow),
    Row is CodeRow - 49.   % '1' -> 0

/*Mapeamento de comando*/
action("I", insert).
action("D", delete).

/*
Interpreta comandos do usuário no formato:
   I-B3-2  -> inserir valor naquela coordenada
   D-B3    -> remover valor daquela coordenada
   M       -> mostrar menu de comandos
Converte a string em ação e coordenadas utilizáveis pelo sistema.
*/
parse_command(String, Action, Row, Col, Value) :-
    split_string(String, "-", "", [Act,Coord,ValStr]),
    string_upper(Act, ActU),
    string_upper(Coord, CoordU),
    atom_string(ValueAtom, ValStr),
    atom_number(ValueAtom, Value),
    coord_to_index(CoordU, Row, Col),
    action(ActU, Action).

parse_command(String, menu, 0, 0, 0) :-
    normalize_space(string(Clean), String),
    string_upper(Clean, "M").

/*
Executa a ação solicitada pelo usuário.
Actions:
   insert -> insere um valor no tabuleiro
   delete -> remove um valor do tabuleiro
Retorna o novo estado do tabuleiro em NewBoard.
*/
execute(insert, Row, Col, Value, Board, NewBoard) :-
    board:insert_on_board(Value, Row, Col, Board, NewBoard, Result),
    writeln(Result).

execute(delete, Row, Col, _, Board, NewBoard) :-
    board:delete_from_board(Row, Col, Board, NewBoard, Result),
    writeln(Result).