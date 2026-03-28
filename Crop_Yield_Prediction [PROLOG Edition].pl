%   CROP YIELD PREDICTION SYSTEM
%   This is program that accepts predicted value from the user about the weather conditions and then using machine learning, it will predict the crop yield
%   Also, it will accept actual value from the user and will determine the crop yield
%   At the end, it will compare the predicted and actual crop yields 
%   At the interface we can ask query and can provide the predicted and actual weather condition value


%   The below list gives the weather conditions that must be inputted in order
%   [Rainfall, Temp, Humidity, Fertilizer, SoilPH, Sunlight, Irrigation, Yield]
season([1000, 41, 60, 58, 8.5, 10.4, 9, 4.2]).
season([2200, 38, 65, 45, 7.2,  9.8, 8, 5.8]).
season([4000, 35, 85, 38, 6.2,  8.4, 4, 8.9]).
season([5000, 29, 90, 30, 6.5,  7.6, 2, 9.5]).
season([2800, 38, 75, 49, 7.0,  9.0, 7, 6.0]).

% Get value at index
val_at(0, [H|_], H) :- !.
val_at(I, [_|T], V) :-
    I > 0, I1 is I - 1, val_at(I1, T, V).

% Sum of (Yield / Feature_i) across all seasons are entoned below
sum_ratios(_, [], 0).
sum_ratios(I, [Row|Rest], Total) :-
    val_at(I, Row, Feature), Feature \= 0,
    val_at(7, Row, Yield),
    sum_ratios(I, Rest, RestSum),
    Total is RestSum + (Yield / Feature).

% Weight for feature index I
weight(I, W) :-
    findall(R, season(R), Rows),
    length(Rows, N),
    sum_ratios(I, Rows, Sum),
    W is Sum / N.

% All 7 weights are given at the bottom
all_weights([W0,W1,W2,W3,W4,W5,W6]) :-
    weight(0,W0), weight(1,W1), weight(2,W2),
    weight(3,W3), weight(4,W4), weight(5,W5), weight(6,W6).

% Yield formula
calc_yield([W0,W1,W2,W3,W4,W5,W6],
           [Rain,Temp,Hum,Fert,Ph,Sun,Irr], Yield) :-
    Raw is (W0*Rain + W1*Temp + W2*Hum + W3*Fert
          + W4*Ph  + W5*Sun  + W6*Irr) / 10,
    Yield is round(Raw * 100) / 100.

bar(0, '') :- !.
bar(N, B) :-
    N > 0, N1 is N - 1,
    bar(N1, B1),
    atom_concat(B1, '#', B).

show_bar(Label, Value) :-
    Blocks is truncate(Value * 4),
    bar(Blocks, B),
    format("  ~w (~2f t/ha) : ~w~n", [Label, Value, B]).

% Main predictions
% predict(Rain1,Temp1,Hum1,Fert1,Ph1,Sun1,Irr1,
%         Rain2,Temp2,Hum2,Fert2,Ph2,Sun2,Irr2)
predict(Rain1,Temp1,Hum1,Fert1,Ph1,Sun1,Irr1,
        Rain2,Temp2,Hum2,Fert2,Ph2,Sun2,Irr2) :-
    all_weights(W),
    calc_yield(W, [Rain1,Temp1,Hum1,Fert1,Ph1,Sun1,Irr1], PY),
    calc_yield(W, [Rain2,Temp2,Hum2,Fert2,Ph2,Sun2,Irr2], AY),
    Diff  is AY - PY,
    RDiff is round(Diff * 100) / 100,
    nl,
    writeln('================================================'),
    writeln('       CROP YIELD PREDICTION SYSTEM            '),
    writeln('================================================'),
    nl,
    writeln('--- PREDICTED Field Conditions ---'),
    format("  Rainfall    : ~w mm~n",    [Rain1]),
    format("  Temperature : ~w C~n",     [Temp1]),
    format("  Humidity    : ~w %%~n",    [Hum1]),
    format("  Fertilizer  : ~w kg/ha~n", [Fert1]),
    format("  Soil pH     : ~w~n",       [Ph1]),
    format("  Sunlight    : ~w hrs~n",   [Sun1]),
    format("  Irrigation  : ~w / 10~n",  [Irr1]),
    nl,
    format("  >> Predicted Yield : ~2f tons/ha~n", [PY]),
    nl,
    writeln('--- ACTUAL Field Conditions ---'),
    format("  Rainfall    : ~w mm~n",    [Rain2]),
    format("  Temperature : ~w C~n",     [Temp2]),
    format("  Humidity    : ~w %%~n",    [Hum2]),
    format("  Fertilizer  : ~w kg/ha~n", [Fert2]),
    format("  Soil pH     : ~w~n",       [Ph2]),
    format("  Sunlight    : ~w hrs~n",   [Sun2]),
    format("  Irrigation  : ~w / 10~n",  [Irr2]),
    nl,
    format("  >> Actual Yield    : ~2f tons/ha~n", [AY]),
    format("  >> Difference      : ~2f tons/ha~n", [RDiff]),
    nl,
    writeln('--- Actual vs Predicted  (each # = 0.25 t/ha) ---'),
    show_bar('Predicted', PY),
    show_bar('Actual   ', AY),
    nl,
    ( Diff > 0 -> writeln('  Result: Actual yield was HIGHER than predicted.')
    ; Diff < 0 -> writeln('  Result: Actual yield was LOWER than predicted.')
    ;             writeln('  Result: Actual and Predicted yields are EQUAL.')
    ),
    nl,
    writeln('================================================'),
    nl.
