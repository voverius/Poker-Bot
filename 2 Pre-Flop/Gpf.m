function gs = Gpf(gs) %GENERAL PRE-FLOP

StealFreq = [40 50 60];
ReqPO = [2.5 4 1];
temp = cell(1,5);
PosBet = [3.5 3 3 2.5 2.5 2.5];

%Analysing input 'gs'
for i = 1:6
    if size(gs{6,i},2) == 2
        Hpos = i;
        break
    end
end
Hpos = 2;
GameStatus = gs{6,Hpos};
HH = gs{3,Hpos};
Cards = gs{4,Hpos};
RoundBet = GameStatus{7,1};
BET = GameStatus{2,1};

Position = Hpos - 2;
if Position == 0
    Position = 6;
elseif Position == -1
    Position = 5;
end

if GameStatus{11,1} == 1
    Position = 4;
end


Action = GameStatus{2,1};
if Action > 3
    Action = 3;
end

CallAmount = GameStatus{7,1} - gs{5,Hpos};


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

%ACTION LINE

for i = 7:size(gs,1)
    if cellfun(@isempty, gs(i,Hpos))
        Hline = i;
        break
    elseif i == size(gs,1)
        Hline = i+1;
    end
end


%STEAL BET
if Position == 3 && GameStatus{1,1} == 0 && Output ~=2 && BET == 1
    if randi(100) < StealFreq(1)
        Output = 2;
    end
elseif Position == 4 && GameStatus{1,1} == 0 && Output ~=2 && BET == 1
    if randi(100) < StealFreq(2)
        Output = 2;
    end
elseif Position == 5 && GameStatus{1,1} == 0 && Output ~=2 && BET == 1
    if randi(100) < StealFreq(3)
        Output = 2;
    end
end

%IF ALREADY PUT MONEY IN

if size(strfind(gs{Hline-1,Hpos}{1,1},'LIMP'),1) > 0 || size(strfind(gs{Hline-1,Hpos}{1,1},'CALL'),1) > 0 ||...
   size(strfind(gs{Hline-1,Hpos}{1,1},'BET'),1) > 0

    if Output == 0
        Output = 4;
        ReqPO = [2.5 4 0.8];
    end
end
 

%Adjusting coinflips by actual Card Odds
if Output == 4 
    
    PotOdds = GameStatus{6,1}/CallAmount;
    
    if PotOdds < ReqPO(1)
        Output = 0;
    elseif PotOdds >= ReqPO(1) && PotOdds < ReqPO(2)
        
    HHMatrix = zeros(2,3);
        if BET == 1
            HHMatrix(1,1) = 4;
        elseif BET == 2
            HHMatrix(1,1) = 3;
        elseif BET == 3
            HHMatrix(1,1) = 2;
        end
            
        
    HHMatrix(1,2:3) = HH(1:2);
    COdds = CardOdds(HHMatrix);
        
        if PotOdds*COdds >= ReqPO(3)
            Output = 1;
        else 
            Output = 0;
        end
    
    elseif PotOdds >= ReqPO(2)
        Output = 1;
    end;
        
end

if GameStatus{10,1} == 1 && Output == 2
    Output = 1;
end    


%___________________________________________________________________________________________________________
                                                %ACTION OUTPUT



if Output == 0
    if GameStatus{10,1} == 1
        temp{1,1} = [num2str(BET),'AFOLD'];
    elseif BET == 1
        if GameStatus{1,1} == 0
            temp{1,1} = 'aFOLD';
        elseif GameStatus{1,1} == 1
            temp{1,1} = 'bFOLD';
        else
            temp{1,1} = 'cFOLD';
        end
    elseif BET == 2
        if Position == 6 && GameStatus{3,1} == 1
            temp{1,1} = 'SFOLD';
        elseif GameStatus{4,1} == 1
            if size(strfind(gs{Hline-1,Hpos}{1,1},'LIMP'),1) > 0
                temp{1,1} = 'IFOLD';
            else
                temp{1,1} = '2FOLD';
            end
        else
            temp{1,1} = '2FOLD';
        end
    elseif BET == 3
        if size(strfind(gs{Hline-1,Hpos}{1,1},'BET'),1) > 0
            temp{1,1} = '3BFOLD';
        else
            temp{1,1} = '3FOLD';
        end
    else
        temp{1,1} = [num2str(BET),'FOLD'];
    end
                
        
    temp{1,2} = RoundBet - gs{5,Hpos}; 
    temp{1,3} = RoundBet;
    temp{1,4} = GameStatus{6,1};
    temp{1,5} = gs{2,Hpos};
    
    gs{Hline,Hpos} = temp;
    
elseif Output == 1
    
    if GameStatus{10,1} == 1
        temp{1,1} = [num2str(BET),'ACALL'];
    elseif BET == 1
        if GameStatus{1,1} == 0
            temp{1,1} = 'aLIMP';
        elseif GameStatus{1,1} == 1
            temp{1,1} = 'bLIMP';
        else
            temp{1,1} = 'cLIMP';
        end
    elseif BET == 2
        if Position == 6 && GameStatus{3,1} == 1
            temp{1,1} = 'SCALL';
        elseif GameStatus{4,1} == 1
            if size(strfind(gs{Hline-1,Hpos}{1,1},'LIMP'),1) > 0
                temp{1,1} = 'ICALL';
            else
                temp{1,1} = '2CALL';
            end
        else
            temp{1,1} = '2CALL';
        end     
    else
        temp{1,1} = [num2str(BET),'CALL'];
    end    
    
    
    
    
    if BET == 1 && Position < 5
        temp{1,2} = RoundBet;
        GameStatus{1,1} = GameStatus{1,1} + 1;
    elseif BET == 1 && Position == 5
        temp{1,2} = RoundBet - gs{5,Hpos};
        GameStatus{1,1} = GameStatus{1,1} + 1;
    elseif BET > 1
        
        if GameStatus{10,1} == 0
            temp{1,2} = RoundBet - gs{5,Hpos};
        else
            temp{1,2} = RoundBet - gs{5,Hpos};
        end
        
    elseif RoundBet == gs{5,Hpos};
        
        if GameStatus{1,1} == 1
            temp{1,1} = 'bCHECK';
        else
            temp{1,1} = 'cCHECK';
        end
        
        temp{1,2} = 0;
        GameStatus{1,1} = GameStatus{1,1} + 1;
    end
    
    temp{1,3} = RoundBet;
    temp{1,4} = GameStatus{6,1};
    temp{1,5} = gs{2,Hpos};
    gs{Hline,Hpos} = temp;
    
    gs{5,Hpos} = RoundBet;
    gs{2,Hpos} = gs{2,Hpos} - RoundBet + temp{1,2};
    GameStatus{6,1} = GameStatus{6,1} + temp{1,2};
    
    if BET == 1
        GameStatus{1,1} = GameStatus{1,1} + 1;
    end
    
    
elseif Output == 2
    if BET == 1
        if GameStatus{3,1} == 0 && Position >= 4 && Position ~= 6
            temp{1,1} = 'SBET';
            temp{1,2} = RoundBet * PosBet(Position); 
            gs{6,Hpos}{3,1} = 1;        
        elseif GameStatus{1,1} == 0
            temp{1,1} = '2BET';
            temp{1,2} = RoundBet * PosBet(Position); 
        elseif GameStatus{1,1} == 1
            temp{1,1} = 'IBET';
            temp{1,2} = RoundBet * PosBet(1); %Isolation bet size - UTG open 2Bet
            gs{6,Hpos}{4,1} = 1;
        else
            temp{1,1} = '2BET';
            temp{1,2} = RoundBet * PosBet(1); %multiple isolation bet size - UTG open 2Bet

        end
        
    elseif BET > 1
        if GameStatus{6,1} >= gs{2,Hpos}*0.8 || RoundBet >= 3*gs{2,Hpos} %Go all-in if pot is 80% of stack or regular bet will go all-in 
            temp{1,1} = [num2str(BET+1),'ABET'];
            temp{1,2} = gs{2,Hpos} + gs{5,Hpos}; %ALL-IN MOVE
            GameStatus{10,1} = 1;
        elseif GameStatus{3,1} == 1 && BET == 2 && Position == 6
            temp{1,1} = 'SRBET';
            temp{1,2} = RoundBet * 3;
        else 
            temp{1,1} = [num2str(BET+1),'BET'];
            temp{1,2} = RoundBet * 3; %triple any previous bet
        end            
    end
        
    temp{1,3} = RoundBet;
    temp{1,4} = GameStatus{6,1};
    temp{1,5} = gs{2,Hpos};    
    gs{Hline,Hpos} = temp;
    
    GameStatus{7,1} = temp{1,2};
    gs{2,Hpos} = gs{2,Hpos} - temp{1,2} + gs{5,Hpos};
    GameStatus{6,1} = GameStatus{6,1} + temp{1,2} - gs{5,Hpos};
    gs{5,Hpos} = temp{1,2};
    GameStatus{2,1} = GameStatus{2,1} + 1;
        
        
end
    

gs{6,Hpos} = GameStatus; %PUTS GAME STATUS BACK INTO MAIN MATRIX
end

