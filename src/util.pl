print_board([]).
print_board([Row|Rest]) :-
    write(Row), nl,
    print_board(Rest).