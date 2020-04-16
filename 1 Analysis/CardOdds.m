% function [WinningPercentage, SplitPercentage, OppPercentage] = CardOdds(InputMatrix)

%     InputMatrix = [2 131 132 101 64 43 52 102; 0 0 0 0 0 0 0 0];
%     MyTwoCards = uint8([53 91]);
%     CommunityCards = uint8([71 131 113 21]);
InputMatrix = [3 141 51 121 61 22 101; 0 0 0 0 0 0 0];

NumberOfPlayers = InputMatrix(1,1);
RunAmmount = uint16(10000/NumberOfPlayers); % HOW MANY TIMES TO DO THE MONTE-CARLO SIMULATION
AllCards = uint8([21 22 23 24 31 32 33 34 41 42 43 44 51 52 53 54 61 62 63 64 71 72 73 74 81 82 83 84 91 92 93 94 101 102 103 104 111 112 113 114 121 122 123 124 131 132 133 134 141 142 143 144]);
SevenCards = uint8(zeros(1,7));
CardResultMatrix = uint8(zeros(3,RunAmmount)); %First column - win, 2nd - split, 3rd - lose
CardComparisonMatrix = int8(zeros((NumberOfPlayers-1),6)); % This holds subtracted hands. Negative means opponent is better, 0 - equal, and positive - I'm better
BestHandMatrix = int8(zeros((NumberOfPlayers),6)); % Holds BestHands for me and all the opponents

if size(InputMatrix,2) >= 6
    SevenCards(3:(size(InputMatrix,2)-1)) = InputMatrix(1,4:size(InputMatrix,2));
end
    
SevenCards(1:2) = InputMatrix(1,2:3);
RealSevenCards = SevenCards;
PlayerRanges = cell(1,NumberOfPlayers-1);

for q = 1:(NumberOfPlayers-1)
    if NumberOfPlayers <=3 && InputMatrix(2,q)>0
         PlayerRanges{1,q} = PercentileRange(InputMatrix(2,q));
    end
end


for q = 1:7
    AllCards = AllCards(AllCards ~= SevenCards(q));
end


% THE BEAAAAAAAAAAST

for q = 1:RunAmmount
    
    % MY HAND CALCULATIONS
    TempCards = AllCards;
    SevenCards = RealSevenCards;
    cutoff = 0;
    
    if size(InputMatrix,2)<8
        for w = 1:(8-size(InputMatrix,2))

            SevenCards(1,(size(InputMatrix,2)-1+w)) = TempCards(randi(size(TempCards,2)));
            TempCards = TempCards(TempCards ~= SevenCards(1,(size(InputMatrix,2)-1+w)));
        end
    end
        
    BestHandMatrix(1,:) = EvaluateCards(SevenCards);

    %OPPONENT HAND CALCULATION
    
    for e = 1:(NumberOfPlayers-1)
        
        if NumberOfPlayers <=3 && InputMatrix(2,e) > 0
            while cutoff == 0
                temp = PlayerRanges{1,e};
                OppCards = temp{randi(size(temp,1)),1};
                [SevenCards(1), SevenCards(2)] = RandomFromRange(OppCards, SevenCards);
                
                if SevenCards(1)> 0
                    cutoff = 1;
                end
            end
            
        else
            for w = 1:2
                SevenCards(1,w) = TempCards(randi(size(TempCards,2)));
                TempCards = TempCards(TempCards ~= SevenCards(1,w));
            end
        end

        BestHandMatrix((e+1),:) = EvaluateCards(SevenCards);

    end
    
    
    for w = 1:(NumberOfPlayers-1)
        CardComparisonMatrix(w,:) = (BestHandMatrix(1,:) - BestHandMatrix((w+1),:));
    end
    
    for w = 1:6
        if all(CardComparisonMatrix(:,w)>0)
            CardResultMatrix(1,q) = 1;
            break
        elseif  any(CardComparisonMatrix(:,w)<0)
            CardResultMatrix(3,q) = 1;
            break
        elseif w == 6 && any(sum(CardComparisonMatrix,2)==0) 
            CardResultMatrix(2,q) = 1;
        end
    end
    
end


RunAmmount = single(RunAmmount);
WinningPercentage = sum(CardResultMatrix(1,:))/RunAmmount;
SplitPercentage = sum(CardResultMatrix(2,:))/RunAmmount;
OppPercentage = sum(CardResultMatrix(3,:))/RunAmmount;
% end
















