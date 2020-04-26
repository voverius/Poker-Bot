function O = EvaluatePFHand(Input)

% dev:
% Input = uint8([81 61 ]);

SC = Input./10;
tSC = SC;
S = rem(Input,10);
if S(1) == S(2)
    Suited = 1;
else
    Suited = 0;
end

%________________________________________________________________________________________________________
%              RANKING:
%   1 - Premium      - JJ+ AQs+ AKo
%   2 - Broadway +   - JTs+ ATo+
%   3 - Pocket pairs - 22-TT
%   4 - Broad + Aces - JTo+, A2+
%   5 - Suited Conn. - 65s+ 68s+
%   6 - Shite        - The rest


if SC(1) == SC(2)
    %Pocket Pair
    if SC(1) >= 11
        O = 1;
    else
        O = 3;
    end  
else
    tSC(1) = max(SC);
    tSC(2) = min(SC);
    
    if tSC(2) == 13
        O = 1;
    elseif tSC(2) >= 10
        if Suited == 1
            if tSC(2) == 12
                O = 1;
            else
                O = 2;
            end
        else
            if tSC(1) == 14 && tSC(2) >= 10 %ATo+
                O = 2;
            else
                O = 4;
            end
        end
    elseif tSC(1) == 14
        O = 4;
    elseif Suited == 1 && (tSC(2) >= 5 && tSC(1) - tSC(2) == 1 || tSC(2) >= 6 && tSC(1) - tSC(2) == 2)
        O = 5;
    else
        O = 6;
    end
end
end