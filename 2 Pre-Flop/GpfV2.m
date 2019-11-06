function temp = GpfV2(gs) %GENERAL PRE-FLOP

StealFreq = [10 20 30];
ReqPO = [2.5 4 1];
temp = zeros(1,8);
PosBet = [3.5 3 3 2.5 2.5 2.5];

%Analysing input 'gs'
for i = 1:6
    if gs{1,i} == 1
        Hero = i;
        break
    end
end
summary = gs{3,4};
MyCards = gs{3,1};
Cards = gs{4,1};
BET = summary{2,1};
POT = summary{6,1};
RoundBet = summary{7,1};
Eq = summary{8,1};
CL = summary{12,1};
Position = Hero - 2;
AmIn = sum(summary{14,1});

if Position < 1
    Position = Position + 6;
end

if summary{11,1} == 1
    Position = 4;
end


Action = summary{2,1};
if Action > 3
    Action = 3;
end

CallAmount = RoundBet - gs{5,Hero};


%___________________________________________________________________________________________________________
                                                %BOSS TABLE
                                                

if strcmp(Cards,'AAo') || strcmp(Cards,'KKo') || strcmp(Cards,'QQo') || strcmp(Cards,'AKs') || strcmp(Cards,'AKo')
    Row = 1;
elseif strcmp(Cards,'JJo')
    Row = 2;
elseif strcmp(Cards,'TTo')
    Row = 3;
elseif strcmp(Cards,'99o') || strcmp(Cards,'88o') || strcmp(Cards,'77o')
    Row = 4;
elseif strcmp(Cards,'66o') || strcmp(Cards,'55o') || strcmp(Cards,'44o') || strcmp(Cards,'33o') || strcmp(Cards,'22o')
    Row = 5;
elseif strcmp(Cards,'AQs')
    Row = 6;
elseif strcmp(Cards,'AJs')
    Row = 7;
elseif strcmp(Cards,'ATs')
    Row = 8;
elseif strcmp(Cards,'A9s') || strcmp(Cards,'A8s') || strcmp(Cards,'A7s') || strcmp(Cards,'A6s') || strcmp(Cards,'A5s') || strcmp(Cards,'A4s') || strcmp(Cards,'A3s') || strcmp(Cards,'A2s')
    Row = 9;
elseif strcmp(Cards,'AQo') || strcmp(Cards,'AJo')
    Row = 10;
elseif strcmp(Cards,'ATo') || strcmp(Cards,'A9o')
    Row = 11;
elseif strcmp(Cards,'A8o') || strcmp(Cards,'A7o') || strcmp(Cards,'A6o')
    Row = 12;
elseif strcmp(Cards,'A5o') || strcmp(Cards,'A4o') || strcmp(Cards,'A3o') || strcmp(Cards,'A2o')
    Row = 13;
elseif strcmp(Cards,'KQs')
    Row = 14;
elseif strcmp(Cards,'KQo') || strcmp(Cards,'KJs') || strcmp(Cards,'KJo')
    Row = 15;
elseif strcmp(Cards,'KTs')
    Row = 16;
elseif strcmp(Cards,'KTo') || strcmp(Cards,'Q9s') || strcmp(Cards,'J9s') || strcmp(Cards,'K9s')
    Row = 17;
elseif strcmp(Cards,'QJs') || strcmp(Cards,'JTs') || strcmp(Cards,'QTs')
    Row = 18;
elseif strcmp(Cards,'QJo') || strcmp(Cards,'JTo') || strcmp(Cards,'QTo')
    Row = 19;
elseif strcmp(Cards,'T9s') || strcmp(Cards,'98s')
    Row = 20;
elseif strcmp(Cards,'87s') || strcmp(Cards,'76s') || strcmp(Cards,'65s') || strcmp(Cards,'54s')
    Row = 21;    
elseif strcmp(Cards,'T8s') || strcmp(Cards,'97s') || strcmp(Cards,'86s') || strcmp(Cards,'75s')
    Row = 22;     
else
    Row = 23;
end


Table = zeros(18,18);
%                  UTG      MID      CUT      BUT      SB       BB
Table(1,1:18)  = [ 2 2 2    2 2 2    2 2 2    2 2 2    2 2 2    2 2 2 ]; % AA-QQ & AKs/o
Table(2,1:18)  = [ 2 2 4    2 2 4    2 2 4    2 2 4    2 2 4    2 2 4 ]; % JJ
Table(3,1:18)  = [ 2 1 4    2 1 4    2 1 4    2 1 4    2 1 4    2 1 4 ]; % TT
Table(4,1:18)  = [ 2 1 4    2 1 4    2 1 4    2 1 4    2 1 4    2 1 4 ]; % 99-77
Table(5,1:18)  = [ 2 1 0    2 1 0    2 1 0    2 1 4    2 1 4    2 1 4 ]; % 66-22
Table(6,1:18)  = [ 2 1 4    2 2 4    2 2 4    2 2 4    2 2 4    2 2 4 ]; % AQs
Table(7,1:18)  = [ 2 1 4    2 1 4    2 1 4    2 2 4    2 1 4    2 1 4 ]; % AJs
Table(8,1:18)  = [ 2 1 4    2 1 4    2 1 4    2 1 4    2 1 4    2 1 4 ]; % ATs
Table(9,1:18)  = [ 1 1 0    1 1 0    2 1 0    2 1 4    2 1 0    1 1 0 ]; % A9s - A2s
Table(10,1:18) = [ 2 1 4    2 1 4    2 1 4    2 2 4    2 1 4    2 1 4 ]; % AQo - AJo
Table(11,1:18) = [ 1 4 0    2 1 0    2 1 0    2 1 4    2 1 0    2 1 0 ]; % ATo - A9o
Table(12,1:18) = [ 0 0 0    1 1 0    2 1 0    2 1 4    2 1 0    1 1 0 ]; % A8o - A6o
Table(13,1:18) = [ 0 0 0    1 1 0    1 1 0    2 1 4    2 1 0    1 1 0 ]; % A5o - A2o
Table(14,1:18) = [ 2 1 4    2 1 4    2 2 4    2 2 4    2 1 4    2 1 4 ]; % KQs
Table(15,1:18) = [ 1 1 0    2 1 0    2 1 0    2 1 0    2 1 0    2 1 0 ]; % KQo - KJs/o
Table(16,1:18) = [ 1 1 0    1 1 0    2 1 0    2 1 0    2 1 0    2 1 0 ]; % KTs
Table(17,1:18) = [ 0 0 0    0 0 0    1 1 0    2 1 0    2 4 0    2 4 0 ]; % KTo & K9s & Q9s & J9s
Table(18,1:18) = [ 1 1 0    1 1 0    2 1 0    2 1 4    2 1 4    2 1 4 ]; % QJs - JTs & QTs
Table(19,1:18) = [ 1 0 0    1 0 0    1 1 0    2 1 0    2 1 0    2 1 0 ]; % QJo - JTo & QTo
Table(20,1:18) = [ 1 4 0    1 4 0    2 1 4    2 1 4    2 1 0    2 1 0 ]; % T9s - 98s
Table(21,1:18) = [ 1 4 0    1 4 0    1 4 0    2 1 4    2 4 0    2 4 0 ]; % 87s - 54s
Table(22,1:18) = [ 1 4 0    1 4 0    1 4 0    2 1 4    2 4 0    2 4 0 ]; % T8s - 75s
Table(23,1:18) = [ 0 0 0    0 0 0    0 0 0    4 4 0    4 4 0    1 4 0 ]; % the rest

PosTemp = Action + (Position - 1)*3;
Output = Table(Row,PosTemp);


%STEAL BET
if summary{1,1} == 0 && BET == 1 && Output ~=2
    if Position == 3
        if randi(100) < StealFreq(1)
            Output = 2;
        end
    elseif Position == 4 
        if randi(100) < StealFreq(2)
            Output = 2;
        end
    elseif Position == 5
        if randi(100) < StealFreq(3)
            Output = 2;
        end
    end
end

%IF ALREADY PUT MONEY IN

if CL > 7
    if Output == 0
        Output = 4;
    end
    ReqPO = [1.5 4 1];
end
 

%Adjusting coinflips by actual Card Odds
if Output == 4 
    PotOdds = POT/CallAmount;
    if PotOdds < ReqPO(1)
        Output = 0;
    elseif PotOdds >= ReqPO(1) && PotOdds < ReqPO(2)
        %assumptions for how many players are in
        %UPGRADE THIS MOTHERFUCKER!! 
        
        if AmIn > 4
            hmp = 4;
        else
            if BET > 2
                hmp = uint8(mean([AmIn (sum(Eq == BET)+1)])); %averages between people in and people putting money in
                if hmp == 1
                    hmp = 2;
                end
            else
                hmp = AmIn;
            end
        end
        
        COdds = LookUpCardOddsPF(MyCards,hmp);
        if PotOdds*COdds >= ReqPO(3)
            Output = 1;
        else 
            Output = 0;
        end
    elseif PotOdds >= ReqPO(2)
        Output = 1;
    end
        
end

if summary{10,1} == 1 && Output == 2 
    Output = 1;
elseif Output == 2 && RoundBet >= (gs{2,Hero} + gs{5,Hero})
    Output = 1;    
end    


%___________________________________________________________________________________________________________
                                                %ACTION OUTPUT
if Output == 0
    temp(1) = 1;
    temp(2) = BET;
    temp(4) = 0;
    temp(5) = RoundBet - gs{5,Hero};
    temp(6) = RoundBet;
    temp(7) = POT;
    temp(8) = gs{2,Hero};
    
    if BET == 1
        if summary{1,1} == 0
            temp(3) = 1;
        elseif summary{1,1} == 1
            temp(3) = 2;
        else 
            temp(3) = 3;
        end
    elseif BET == 2 && summary{3,1} == 1 && Hero == 2
        temp(3) = 5;
    elseif BET > 1 && CL == 8
        temp2 = gs{7,Hero};
        if BET == 3 && temp2(1) == 3 && temp2(2) == 2
            if temp2(3) == 5
                temp(3) = 5;
            else
                temp(3) = 7;
            end
        elseif BET == 2 && summary{4,1} == 1 && temp2(3) < 4 
            temp(3) = 6;
        else
            temp(3) = 4;
        end
    elseif summary{10,1} > 0
        temp(3) = 11;
    else
        temp(3) = 4;
    end   
    
elseif Output == 1
    if RoundBet ~= gs{5,Hero}
        temp(1) = 2;
    else
        temp(1) = 4;
    end
    temp(2) = BET;
    if RoundBet >= gs{5,Hero} + gs{2,Hero}
        temp(4) = 1;
        temp(5) = gs{2,Hero};
    else
        temp(4) = 0;
        temp(5) = RoundBet - gs{5,Hero};
    end
    temp(6) = RoundBet;
    temp(7) = POT;
    temp(8) = gs{2,Hero};    
    
    if BET == 1
        if summary{1,1} == 0
            temp(3) = 1;
        elseif summary{1,1} == 1
            temp(3) = 2;
        else
            temp(3) = 3;
        end
    elseif BET == 2
        if summary{3,1} == 1 && Hero == 2
            temp(3) = 5;
        elseif summary{4,1} == 1 && CL == 8
            temp(3) = 6;
        else
            temp(3) = 4;
        end
    elseif BET == 3
        if CL > 7
            temp2 = gs{7,Hero};
            if temp2(1) == 3
                temp(3) = 7;
            else
                temp(3) = 4;
            end
        else
            temp(3) = 4;
        end
    else
        temp(3) = 4;
    end    
    
elseif Output == 2
    BET = BET + 1;
    temp(1) = 3;
    temp(2) = BET;
    if POT >= gs{2,i}*0.8 || 3*RoundBet >= 0.8*gs{2,Hero}
        temp(4) = 1;
    else
        temp(4) = 0;
    end
    temp(6) = RoundBet;
    temp(7) = POT;
    temp(8) = gs{2,Hero};       
    
    
    if BET == 2
        if summary{1,1} == 0 && (Hero == 5 || Hero == 6 || Hero == 1)
            temp(3) = 5;
            temp(5) = RoundBet * PosBet(Position);
        elseif summary{1,1} == 1
            temp(3) = 6;
            temp(5) = RoundBet * PosBet(1);
        else
            temp(3) = 4;
            if summary{1,1} == 0
                temp(5) = RoundBet * PosBet(Position);
            else
                temp(5) = POT;
            end
        end
    elseif BET == 3
        if Hero == 2 && summary{3,1} == 1
            temp(3) = 5;
            temp(5) = RoundBet*3;
        else 
            temp(3) = 7;
            temp(5) = RoundBet*3;
        end
    else
        temp(3) = 4;
        if temp(4) == 0
            temp(5) = RoundBet*2.5;
        else
            temp(5) = gs{2,Hero} + gs{5,Hero};
        end
    end
end        

end