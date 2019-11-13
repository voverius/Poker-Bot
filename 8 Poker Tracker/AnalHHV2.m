% function AnalHH V2.0  - Analyzie Hand History

%AH variable dimensions
gap = 1;
AHcol = 6;
AHRow = 90;

%Loading variables:

%VP comes from PokerTracker and represents the Villains Position in HH matrix                               
NW = NWMatrix{VP,1}; %New Way matrix, same as per StatCounter
NWr = size(NW,1);    %How many lines are there in NW
VarNick = NWMatrix{VP,2};   %Varnick is Villain nick with only alphabet and numericals
SummaryTemp = HH{5,VP,1};   %stores game summary from TableHistory
PotSummary = HH{5,VP,2};    %This is for the winner
TS = HH{5,VP,3}; %Table summary (stores all folds raises etc. for every player);
BB = SummaryTemp{1,6};      %duhhh
RC = ConvertToRange(HH{4,VP,1}); %Ranged Cards e.g. AJo
AC = ConvertCards(HH{4,VP,1});   %Actual Cards e.g. [141 113]
CC = EvaluatePFHand(AC); %which percentile are the cards in
HS = zeros(3,1); %Hand strength for every street 


%Checking for AH file - saved, existing or new
New = 0;
VariableName = ['AH_',VarNick];
FileName = ['D:\OneDrive\Poker\Europe\AH Files\Work\',VariableName,'.mat'];

if exist(VariableName,'var') == 1
    AH = eval(VariableName);
elseif exist(FileName,'file') == 2
    load(FileName);
    PT = eval(VariableName);
else
    AH = zeros(AHRow,AHcol+AHcol*gap+3,6); % 'uint32'  <-- change to it when finished developing
    New = 1;
end    


%Checking if won any pots
for a = 1:size(PotSummary,1)
    if strcmp(HH{1,VP,1},PotSummary{a,1})
        HasWon = 1;
    break
    end
end

%Modifying the pre-flop table summary
% VPt = VP - 2;
% if VPt < 1
%     VPt = VPt + 6;
% end
% TSt = TS(:,:,1);
% TS(:,1:4,1) = TSt(:,3:6,1);
% TS(:,5:6,1) = TSt(:,1:2,1);


%Overall AH variables
TotH = AH(1,6,1) + 1;
if TotH >= 1000
    %5th position stores thousands & 6th stores hundreds
    %This is so to keep from factorizing the whole matrix
    AH(1,5,1) = AH(1,5,1) + 1;
    AH(1,6,1) = AH(1,6,1) - 1000 + 1;
else
    AH(1,6,1) = AH(1,6,1) + 1;
end



%_________________________________________________________________________________________________________
%_________________________________________________________________________________________________________
%                                                INDEX:

%   PRE-FLOP BLOCKS:
%1st - 2Bet for every position
%2nd - 2Bet call
%3rd - 3Bet for every position
%4th - 3Bet call
%5th - 4Bet for every position
%6th - 4Bet call
%7th - All-in Raise
%8th - All-in call

%   POST-FLOP BLOCKS:
%1st - 1Bet for every street (IP/OOP)
%2nd - CBet for every street (IP/OOP)
%3rd - Chech/raise & Check/call for every street




%_________________________________________________________________________________________________________    
                                    WL = 3; %WORKING LINE DEFINED HERE '3'

%1 - 2Bet Raise for every position
if NW(1,1,1) == 3 && NW(1,2,1) == 2   %&& (VPt == 1 || all(TS(1,(1:VPt-1),1) == 1))
    
    %1st layer:
    %1st row - number of hands open raised in that particular position
    %2nd row - AQs+
    %3rd - ATo+
    %4th - 22-10
    %5th - JTo + A2s
    %6th - 65s+ 86s+
    %7th - the rest
    
    %2nd layer - min raising at 2xBB
    %3rd layer - raising between 2 & 2.5BB
    %4th layer - between 2.5 & 3
    %5th layer - between 3 & 3.5
    %6th layer - above 3.5 (excluding)
    
    %8th column - overall disregarding position
    %1st layer - 
    %2nd - 
    %3-6th - etc

    AH(WL,8,1) = AH(WL,8,1) + 1; %total hands
    AHpos = AHcol + 4 + (VP - 1)*gap;
    AH(WL,AHpos,1) = AH(WL,AHpos,1) + 1;
    AH(WL,VP,1) = AH(WL,AHpos,1);
    
    %Working out the hand rank
    WLt = WL + CC;
    AH(WLt,AHpos,1) = AH(WLt,AHpos,1) + 1;

    
    %Working out the bet size in bb
    BetRatio = NW(1,5,1)/BB;
    if BetRatio == 2
        WLl = 2; %Working Line layer
    elseif BetRatio <= 2.5
        WLl = 3;
    elseif BetRatio <= 3
        WLl = 4;
    elseif BetRatio <= 3.5
        WLl = 5;
    else
        WLl = 6;
    end
    AH(WL,AHpos,WLl) = AH(WL,AHpos,WLl) + 1;
    AH(WLt,AHpos,WLl) = AH(WLt,AHpos,WLl) + 1;
    AH(WLt,8,WLl) = AH(WLt,8,WLl) + 1;
    AH(WL,8,WLl) = AH(WL,8,WLl) + 1;
    
    %Updating the main variables
    for a = 1:6
        %Sorts out position vs percentile - main & by bet amount
        AH(WL+a,VP,1) = AH(WL+a,AHpos,1)*100/AH(WL,VP,1);
        AH(WL+a,VP,WLl) = AH(WL+a,AHpos,WLl)*100/AH(WL,AHpos,WLl);
        
        %sorts out overall percentile - main & by bet amount
        AH(WL+a,8,1) = sum(AH(WL+a,10:end,1))*100/AH(WL,8,1);
        AH(WL+a,8,WLl) = sum(AH(WL+a,10:end,WLl))*100/AH(WL,8,WLl);
    end
    
    for a = 2:6
        AH(WL,VP,a) = AH(WL,AHpos,a)*100/AH(WL,VP,1);
    end
end
WLP = 8; %Working line plus


%_________________________________________________________________________________________________________    
                                  WL = WL + WLP; %WORKING LINE DEFINED HERE '11'


%2 - 2Bet call for every position
if NW(1,1,1) == 2 && NW(1,2,1) == 2  
    
    AH(WL,8,1) = AH(WL,8,1) + 1; 
    AHpos = AHcol + 4 + (VP - 1)*gap;
    AH(WL,AHpos,1) = AH(WL,AHpos,1) + 1;
    AH(WL,VP,1) = AH(WL,AHpos,1);
    
    
    %Working out the hand rank
    WLt = WL + CC;
    AH(WLt,AHpos,1) = AH(WLt,AHpos,1) + 1;
    
    
    %Working out the bet size in bb
    BetRatio = NW(1,6,1)/BB;
    if BetRatio == 2
        WLl = 2; %Working Line layer
    elseif BetRatio <= 2.5
        WLl = 3;
    elseif BetRatio <= 3
        WLl = 4;
    elseif BetRatio <= 3.5
        WLl = 5;
    else
        WLl = 6;
    end
    AH(WL,AHpos,WLl) = AH(WL,AHpos,WLl) + 1;
    AH(WLt,AHpos,WLl) = AH(WLt,AHpos,WLl) + 1;
    AH(WLt,8,WLl) = AH(WLt,8,WLl) + 1;
    AH(WL,8,WLl) = AH(WL,8,WLl) + 1;
    
    
    %Updating the main variables
    for a = 1:6
        %Sorts out position vs percentile - main & by bet amount
        AH(WL+a,VP,1) = AH(WL+a,AHpos,1)*100/AH(WL,VP,1);
        AH(WL+a,VP,WLl) = AH(WL+a,AHpos,WLl)*100/AH(WL,AHpos,WLl);
        
        %sorts out overall percentile - main & by bet amount
        AH(WL+a,8,1) = sum(AH(WL+a,10:end,1))*100/AH(WL,8,1);
        AH(WL+a,8,WLl) = sum(AH(WL+a,10:end,WLl))*100/AH(WL,8,WLl);
    end
    
    for a = 2:6
        AH(WL,VP,a) = AH(WL,AHpos,a)*100/AH(WL,VP,1);
    end
end
WLP = 8; %Working line plus


%_________________________________________________________________________________________________________    
                                 WL = WL + WLP; %WORKING LINE DEFINED HERE '19'


%3 - 3Bet for every position
if NW(1,1,1) == 3 && NW(1,2,1) == 3 || NWr > 1 &&  NW(2,1,1) == 3 && NW(2,2,1) == 3
    
    AH(WL,8,1) = AH(WL,8,1) + 1; 
    AHpos = AHcol + 4 + (VP - 1)*gap;
    AH(WL,AHpos,1) = AH(WL,AHpos,1) + 1;
    AH(WL,VP,1) = AH(WL,AHpos,1);
    
    %Working out the hand rank
    WLt = WL + CC;
    AH(WLt,AHpos,1) = AH(WLt,AHpos,1) + 1;
    
    
    %Working out the bet size in bb
    BetRatio = NW(1,5,1)/NW(1,6,1);
    if BetRatio <= 2
        WLl = 2; %Working Line layer
    elseif BetRatio <= 2.5
        WLl = 3;
    elseif BetRatio <= 2.9
        WLl = 4;
    elseif BetRatio <= 3.5
        WLl = 5;
    else
        WLl = 6;
    end
    AH(WL,AHpos,WLl) = AH(WL,AHpos,WLl) + 1;
    AH(WLt,AHpos,WLl) = AH(WLt,AHpos,WLl) + 1;
    AH(WLt,8,WLl) = AH(WLt,8,WLl) + 1;
    AH(WL,8,WLl) = AH(WL,8,WLl) + 1;
    
    
    %Updating the main variables
    for a = 1:6
        %Sorts out position vs percentile - main & by bet amount
        AH(WL+a,VP,1) = AH(WL+a,AHpos,1)*100/AH(WL,VP,1);
        AH(WL+a,VP,WLl) = AH(WL+a,AHpos,WLl)*100/AH(WL,AHpos,WLl);
        
        %sorts out overall percentile - main & by bet amount
        AH(WL+a,8,1) = sum(AH(WL+a,10:end,1))*100/AH(WL,8,1);
        AH(WL+a,8,WLl) = sum(AH(WL+a,10:end,WLl))*100/AH(WL,8,WLl);
    end
    
    for a = 2:6
        AH(WL,VP,a) = AH(WL,AHpos,a)*100/AH(WL,VP,1);
    end
end
WLP = 8; %Working line plus


%_________________________________________________________________________________________________________    
                                 WL = WL + WLP; %WORKING LINE DEFINED HERE '27'


%4 - 3Bet Call for every position
if NWr > 1 && NW(2,1,1) == 2 && NW(2,2,1) == 3
    
    AH(WL,8,1) = AH(WL,8,1) + 1; 
    AHpos = AHcol + 4 + (VP - 1)*gap;
    AH(WL,AHpos,1) = AH(WL,AHpos,1) + 1;
    AH(WL,VP,1) = AH(WL,AHpos,1);
    
    WLt = WL + CC;
    AH(WLt,AHpos,1) = AH(WLt,AHpos,1) + 1;
    
    
    BetRatio = NW(2,6,1)/BB;
    if BetRatio <= 5
        WLl = 2;
    elseif BetRatio <= 7
        WLl = 3;
    elseif BetRatio <= 9
        WLl = 4;
    elseif BetRatio <= 11
        WLl = 5;
    else
        WLl = 6;
    end
    AH(WL,AHpos,WLl) = AH(WL,AHpos,WLl) + 1;
    AH(WLt,AHpos,WLl) = AH(WLt,AHpos,WLl) + 1;
    AH(WLt,8,WLl) = AH(WLt,8,WLl) + 1;
    AH(WL,8,WLl) = AH(WL,8,WLl) + 1;
    
    
    for a = 1:6
        AH(WL+a,VP,1) = AH(WL+a,AHpos,1)*100/AH(WL,VP,1);
        AH(WL+a,VP,WLl) = AH(WL+a,AHpos,WLl)*100/AH(WL,AHpos,WLl);
        
        AH(WL+a,8,1) = sum(AH(WL+a,10:end,1))*100/AH(WL,8,1);
        AH(WL+a,8,WLl) = sum(AH(WL+a,10:end,WLl))*100/AH(WL,8,WLl);
    end
    
    for a = 2:6
        AH(WL,VP,a) = AH(WL,AHpos,a)*100/AH(WL,VP,1);
    end
end
WLP = 8; 


%_________________________________________________________________________________________________________    
                                 WL = WL + WLP; %WORKING LINE DEFINED HERE '35'


%5 - 4Bet for every position
if any(NW(:,2,1) == 4)
    flag = 0;
    for a = NWr:-1:1
        if NW(a,1,1) == 3 && NW(a,2,1) == 4
            flag = 1;
        end
    end
    
    if flag == 1
        AH(WL,8,1) = AH(WL,8,1) + 1; 
        AHpos = AHcol + 4 + (VP - 1)*gap;
        AH(WL,AHpos,1) = AH(WL,AHpos,1) + 1;
        AH(WL,VP,1) = AH(WL,AHpos,1);

        WLt = WL + CC;
        AH(WLt,AHpos,1) = AH(WLt,AHpos,1) + 1;


        BetRatio = NW(1,5,1)/NW(1,6,1);
        if BetRatio <= 2
            WLl = 2;
        elseif BetRatio <= 2.5
            WLl = 3;
        elseif BetRatio <= 2.9
            WLl = 4;
        elseif BetRatio <= 3.5
            WLl = 5;
        else
            WLl = 6;
        end
        AH(WL,AHpos,WLl) = AH(WL,AHpos,WLl) + 1;
        AH(WLt,AHpos,WLl) = AH(WLt,AHpos,WLl) + 1;
        AH(WLt,8,WLl) = AH(WLt,8,WLl) + 1;
        AH(WL,8,WLl) = AH(WL,8,WLl) + 1;


        for a = 1:6
            AH(WL+a,VP,1) = AH(WL+a,AHpos,1)*100/AH(WL,VP,1);
            AH(WL+a,VP,WLl) = AH(WL+a,AHpos,WLl)*100/AH(WL,AHpos,WLl);

            AH(WL+a,8,1) = sum(AH(WL+a,10:end,1))*100/AH(WL,8,1);
            AH(WL+a,8,WLl) = sum(AH(WL+a,10:end,WLl))*100/AH(WL,8,WLl);
        end

        for a = 2:6
            AH(WL,VP,a) = AH(WL,AHpos,a)*100/AH(WL,VP,1);
        end
    end
end
WLP = 8; 


%_________________________________________________________________________________________________________    
                                WL = WL + WLP; %WORKING LINE DEFINED HERE '43'


%6 - 4Bet Call for every position - excluding bet sizing
if any(NW(:,2,1) == 4)
    flag = 0;
    for a = NWr:-1:1
        if NW(a,1,1) == 2 && NW(a,2,1) == 4
            flag = 1;
            break
        end
    end
    
    if flag == 1
        AH(WL,8,1) = AH(WL,8,1) + 1; 
        AHpos = AHcol + 4 + (VP - 1)*gap;
        AH(WL,AHpos,1) = AH(WL,AHpos,1) + 1;
        AH(WL,VP,1) = AH(WL,AHpos,1);

        WLt = WL + CC;
        AH(WLt,AHpos,1) = AH(WLt,AHpos,1) + 1;

        for a = 1:6
            AH(WL+a,VP,1) = AH(WL+a,AHpos,1)*100/AH(WL,VP,1);
            AH(WL+a,8,1) = sum(AH(WL+a,10:end,1))*100/AH(WL,8,1);
        end
    end
end
WLP = 8; 


%_________________________________________________________________________________________________________    
                                 WL = WL + WLP; %WORKING LINE DEFINED HERE '51'


%7 - All-in raise for every position
if any(NW(:,4,1) == 1) && NW(NWr,1,1) == 3
    AH(WL,8,1) = AH(WL,8,1) + 1; 
    AHpos = AHcol + 4 + (VP - 1)*gap;
    AH(WL,AHpos,1) = AH(WL,AHpos,1) + 1;
    AH(WL,VP,1) = AH(WL,AHpos,1);

    WLt = WL + CC;
    AH(WLt,AHpos,1) = AH(WLt,AHpos,1) + 1;


    BetRatio = NW(1,8,1)/BB;
    if BetRatio <= 50
        WLl = 2;
    elseif BetRatio <= 100
        WLl = 3;
    else
        WLl = 4;
    end
    AH(WL,AHpos,WLl) = AH(WL,AHpos,WLl) + 1;
    AH(WLt,AHpos,WLl) = AH(WLt,AHpos,WLl) + 1;
    AH(WLt,8,WLl) = AH(WLt,8,WLl) + 1;
    AH(WL,8,WLl) = AH(WL,8,WLl) + 1;


    for a = 1:6
        AH(WL+a,VP,1) = AH(WL+a,AHpos,1)*100/AH(WL,VP,1);
        AH(WL+a,VP,WLl) = AH(WL+a,AHpos,WLl)*100/AH(WL,AHpos,WLl);

        AH(WL+a,8,1) = sum(AH(WL+a,10:end,1))*100/AH(WL,8,1);
        AH(WL+a,8,WLl) = sum(AH(WL+a,10:end,WLl))*100/AH(WL,8,WLl);
    end

    for a = 2:4
        AH(WL,VP,a) = AH(WL,AHpos,a)*100/AH(WL,VP,1);
    end
end
WLP = 8; 


%_________________________________________________________________________________________________________    
                                 WL = WL + WLP; %WORKING LINE DEFINED HERE '59'


%8 - All-in call for every position
flag = 0;
if any(NW(:,4,1) == 1) && NW(NWr,1,1) == 2 
    flag = 1;
else
    for a = NWr:-1:1
        if NW(a,1,1) == 2 && NW(a,3,1) == 11
            flag = 1;
            break
        end
    end
end

if flag == 1
    AH(WL,8,1) = AH(WL,8,1) + 1; 
    AHpos = AHcol + 4 + (VP - 1)*gap;
    AH(WL,AHpos,1) = AH(WL,AHpos,1) + 1;
    AH(WL,VP,1) = AH(WL,AHpos,1);

    WLt = WL + CC;
    AH(WLt,AHpos,1) = AH(WLt,AHpos,1) + 1;


    BetRatio = NW(1,8,1)/BB;
    if BetRatio > NW(NWr,6,1)/BB
        BetRatio = NW(NWr,6,1)/BB; 
    end
        
    if BetRatio <= 50
        WLl = 2;
    elseif BetRatio <= 100
        WLl = 3;
    else
        WLl = 4;
    end
    AH(WL,AHpos,WLl) = AH(WL,AHpos,WLl) + 1;
    AH(WLt,AHpos,WLl) = AH(WLt,AHpos,WLl) + 1;
    AH(WLt,8,WLl) = AH(WLt,8,WLl) + 1;
    AH(WL,8,WLl) = AH(WL,8,WLl) + 1;


    for a = 1:6
        AH(WL+a,VP,1) = AH(WL+a,AHpos,1)*100/AH(WL,VP,1);
        AH(WL+a,VP,WLl) = AH(WL+a,AHpos,WLl)*100/AH(WL,AHpos,WLl);

        AH(WL+a,8,1) = sum(AH(WL+a,10:end,1))*100/AH(WL,8,1);
        AH(WL+a,8,WLl) = sum(AH(WL+a,10:end,WLl))*100/AH(WL,8,WLl);
    end

    for a = 2:4
        AH(WL,VP,a) = AH(WL,AHpos,a)*100/AH(WL,VP,1);
    end
end
WLP = 8; 


%_________________________________________________________________________________________________________ 
%                                        !!!!!  POST FLOP BABY  !!!!!
%_________________________________________________________________________________________________________    
                                  WL = WL + WLP; %WORKING LINE DEFINED HERE '51'    
 

%Open Bet for every street (IP & OOP)
for b = 1:3
    WC = b;
    c = WC + 6;
    if any(NW(:,1,b+1) > 0) 
        HS(b) = SM(HandCount,1)*100;
        if NW(1,1,b+1) == 3 && NW(1,2,b+1) == 1
            if NW(1,9,b+1) == 1
                WC = WC*2 - 1; 
                AHpos2 = 0;
            else
                WC = WC*2;
                AHpos2 = 1;
            end
        
            AHpos = AHcol + 4 + (WC - 1)*gap;
            AH(WL,AHpos,1) = AH(WL,AHpos,1) + 1;
            AH(WL,WC,1) = AH(WL,AHpos,1);   
            AH(WL,c,1) = AH(WL,c,1) + 1; 
            AHpos2 = AHpos - AHpos2;

            if HS(b) >= 80
                WLt = WL + 1; 
            elseif HS(b) >= 60
                WLt = WL + 2;
            elseif HS(b) >= 40
                WLt = WL + 3;
            else
                WLt = WL + 4;
            end
            AH(WLt,AHpos,1) = AH(WLt,AHpos,1) + 1;

            BetRatio = NW(1,5,b+1)*100/NW(1,7,b+1);
            if BetRatio <= 40
                WLl = 2;
            elseif BetRatio <= 60
                WLl = 3;
            elseif BetRatio <= 80
                WLl = 4;
            elseif BetRatio <= 110
                WLl = 5;    
            else
                WLl = 6;
            end
            AH(WL,AHpos,WLl) = AH(WL,AHpos,WLl) + 1;
            AH(WLt,AHpos,WLl) = AH(WLt,AHpos,WLl) + 1;
            AH(WLt,c,WLl) = AH(WLt,c,WLl) + 1;
            AH(WL,c,WLl) = AH(WL,c,WLl) + 1;

            for a = 1:4
                AH(WL+a,WC,1) = AH(WL+a,AHpos,1)*100/AH(WL,WC,1);
                AH(WL+a,WC,WLl) = AH(WL+a,AHpos,WLl)*100/AH(WL,AHpos,WLl);
                
                AH(WL+a,c,1) = sum(AH(WL+a,AHpos2:AHpos2+1,1))*100/AH(WL,c,1);
                AH(WL+a,c,WLl) = sum(AH(WL+a,AHpos2:AHpos2+1,WLl))*100/AH(WL,c,WLl);                
            end
            for a = 2:5
                AH(WL,WC,a) = AH(WL,AHpos,a)*100/AH(WL,WC,1);
            end
        end
    end
end
WLP = 6; 

%_________________________________________________________________________________________________________    
                                  WL = WL + WLP; %WORKING LINE DEFINED HERE '57'  

%Continuation Bet on every street & IP/OOP
for b = 1:3
    WC = b;
    c = WC + 6;
    if any(NW(:,1,b+1) > 0) 
        HS(b) = SM(HandCount,1)*100;
        if NW(1,1,b+1) == 3 && NW(1,3,b+1) == 8
            if NW(1,9,b+1) == 1
                WC = WC*2 - 1; 
                AHpos2 = 0;
            else
                WC = WC*2;
                AHpos2 = 1;
            end
            
            AHpos = AHcol + 4 + (WC - 1)*gap;
            AH(WL,AHpos,1) = AH(WL,AHpos,1) + 1;
            AH(WL,WC,1) = AH(WL,AHpos,1);   
            AH(WL,c,1) = AH(WL,c,1) + 1; 
            AHpos2 = AHpos - AHpos2;

            if HS(b) >= 80
                WLt = WL + 1; 
            elseif HS(b) >= 60
                WLt = WL + 2;
            elseif HS(b) >= 40
                WLt = WL + 3;
            else
                WLt = WL + 4;
            end
            AH(WLt,AHpos,1) = AH(WLt,AHpos,1) + 1;

            BetRatio = NW(1,5,b+1)*100/NW(1,7,b+1);
            if BetRatio <= 40
                WLl = 2;
            elseif BetRatio <= 60
                WLl = 3;
            elseif BetRatio <= 80
                WLl = 4;
            elseif BetRatio <= 110
                WLl = 5;    
            else
                WLl = 6;
            end
            AH(WL,AHpos,WLl) = AH(WL,AHpos,WLl) + 1;
            AH(WLt,AHpos,WLl) = AH(WLt,AHpos,WLl) + 1;
            AH(WLt,c,WLl) = AH(WLt,c,WLl) + 1;
            AH(WL,c,WLl) = AH(WL,c,WLl) + 1;

            for a = 1:4
                AH(WL+a,WC,1) = AH(WL+a,AHpos,1)*100/AH(WL,WC,1);
                AH(WL+a,WC,WLl) = AH(WL+a,AHpos,WLl)*100/AH(WL,AHpos,WLl);
                
                AH(WL+a,c,1) = sum(AH(WL+a,AHpos2:AHpos2+1,1))*100/AH(WL,c,1);
                AH(WL+a,c,WLl) = sum(AH(WL+a,AHpos2:AHpos2+1,WLl))*100/AH(WL,c,WLl);                
            end
            for a = 2:5
                AH(WL,WC,a) = AH(WL,AHpos,a)*100/AH(WL,WC,1);
            end
        end
    end
end
WLP = 6; 

%_________________________________________________________________________________________________________    
                                  WL = WL + WLP; %WORKING LINE DEFINED HERE '63'    

%Check raise for every street
for b = 1:3
    WC = b;
    if any(NW(:,1,b+1) > 0) 
        HS(b) = SM(HandCount,1)*100;
        if NWr > 1 && NW(1,1,b+1) == 4 && NW(2,1,b+1) == 3
            AHpos = AHcol + 4 + (WC - 1)*gap;
            AH(WL,AHpos,1) = AH(WL,AHpos,1) + 1;
            AH(WL,8,1) = AH(WL,8,1) + 1; 
            AH(WL,WC,1) = AH(WL,AHpos,1);       

            if HS(b) >= 80
                WLt = WL + 1; 
            elseif HS(b) >= 60
                WLt = WL + 2;
            elseif HS(b) >= 40
                WLt = WL + 3;
            else
                WLt = WL + 4;
            end
            AH(WLt,AHpos,1) = AH(WLt,AHpos,1) + 1;

            BetRatio = NW(2,5,b+1)*100/NW(2,6,b+1);
            if BetRatio <= 2
                WLl = 2;
            elseif BetRatio <= 3
                WLl = 3;
            elseif BetRatio <= 4
                WLl = 4;    
            else
                WLl = 5;
            end
            AH(WL,AHpos,WLl) = AH(WL,AHpos,WLl) + 1;
            AH(WLt,AHpos,WLl) = AH(WLt,AHpos,WLl) + 1;
            AH(WLt,8,WLl) = AH(WLt,8,WLl) + 1;
            AH(WL,8,WLl) = AH(WL,8,WLl) + 1;

            for a = 1:4
                AH(WL+a,WC,1) = AH(WL+a,AHpos,1)*100/AH(WL,WC,1);
                AH(WL+a,WC,WLl) = AH(WL+a,AHpos,WLl)*100/AH(WL,AHpos,WLl);
                
                AH(WL+a,8,1) = sum(AH(WL+a,10:12,1))*100/AH(WL,8,1);
                AH(WL+a,8,WLl) = sum(AH(WL+a,10:12,WLl))*100/AH(WL,8,WLl);                
            end
            for a = 2:5
                AH(WL,WC,a) = AH(WL,AHpos,a)*100/AH(WL,WC,1);
            end
        end
    end
end


%Check call for every street
for b = 1:3
    WC = b+3;
    if any(NW(:,1,b+1) > 0) 
        HS(b) = SM(HandCount,1)*100;
        if NWr > 1 && NW(1,1,b+1) == 4 && NW(2,1,b+1) == 2
            AHpos = AHcol + 4 + (WC - 1)*gap;
            AH(WL,AHpos,1) = AH(WL,AHpos,1) + 1;
            AH(WL,9,1) = AH(WL,9,1) + 1; 
            AH(WL,WC,1) = AH(WL,AHpos,1);       

            if HS(b) >= 80
                WLt = WL + 1; 
            elseif HS(b) >= 60
                WLt = WL + 2;
            elseif HS(b) >= 40
                WLt = WL + 3;
            else
                WLt = WL + 4;
            end
            AH(WLt,AHpos,1) = AH(WLt,AHpos,1) + 1;

            BetRatio = NW(2,5,b+1)*100/NW(2,7,b+1);
            if BetRatio <= 40
                WLl = 2;
            elseif BetRatio <= 60
                WLl = 3;
            elseif BetRatio <= 80
                WLl = 4;
            elseif BetRatio <= 110
                WLl = 5;    
            else
                WLl = 6;
            end
            AH(WL,AHpos,WLl) = AH(WL,AHpos,WLl) + 1;
            AH(WLt,AHpos,WLl) = AH(WLt,AHpos,WLl) + 1;
            AH(WLt,9,WLl) = AH(WLt,9,WLl) + 1;
            AH(WL,9,WLl) = AH(WL,9,WLl) + 1;

            for a = 1:4
                AH(WL+a,WC,1) = AH(WL+a,AHpos,1)*100/AH(WL,WC,1);
                AH(WL+a,WC,WLl) = AH(WL+a,AHpos,WLl)*100/AH(WL,AHpos,WLl);
                
                AH(WL+a,9,1) = sum(AH(WL+a,13:15,1))*100/AH(WL,9,1);
                AH(WL+a,9,WLl) = sum(AH(WL+a,13:15,WLl))*100/AH(WL,9,WLl);                
            end
            for a = 2:5
                AH(WL,WC,a) = AH(WL,AHpos,a)*100/AH(WL,WC,1);
            end
        end
    end
end
WLP = 6; 










































%Transfering from AH to AH_*
eval(['AH_' VarNick ' = AH;']);


% end