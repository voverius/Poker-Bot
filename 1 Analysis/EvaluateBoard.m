function Output = EvaluateBoard(Input)

%dev:
% Input = uint8([141 142 101 102 81]);
% Input = uint8([131 22 92]);


%Used variables
Output = uint8(zeros(1,4));
SC = Input./10; %Suitless cards
CC = size(Input,2); %Card Count
SuitCount = uint8(zeros(1,4));
FlushCheck = rem(Input,10);
StraightCheck = uint8(zeros(1,14));
StraightCheck2 = uint8(zeros(1,10));


%________________________________________________________________________________________________________

%   OUTPUT SYSTEM:

%   1st position - Pair Count:
%   1 - One Pair
%   2 - Two Pairs
%   3 - Three of a kind
%   4 - Full House
%   5 - 4 of a kind

%   2nd position - Ace check (1/0)

%   3rd position - Flush check
%   1 - 2 cards (h h c)
%   2 - 2 pairs (h h c c)
%   3 - three cards (h h h c)
%   4 - 4 cards (h h h h c)
%   On the river it stays either 0,3 or 4!

%   4th position
%   1 - Gut shot possible (1 0 0 0 1)
%   2 - OESD possible (1 1 0 0 0)
%   3 - straight is possible (1 1 0 1 0)
%   4 - 4 cards on the table (1 1 0 1 1)


%_______________________
%Pair Check on the board
PairCount = uint8(zeros(1,14));
for i = 1:CC
    PairCount(1,SC(i)) = PairCount(1,SC(i))+1;
end

if any(PairCount == 4)
    %4 of a kind on the board
    Output(1) = 5;
elseif any(PairCount == 3) 
    if any(PairCount == 2)
        %full house on board
        Output(1) = 4;
    else
        %three of a kind on the board
        Output(1) = 3;
    end
elseif sum(PairCount == 2) == 2
    %2 pair on the board
    Output(1) = 2;
elseif sum(PairCount == 2) == 1
    %paired board
    Output(1) = 1;
end
   

%______________________
%Ace Check on the board
if PairCount(14) == 1;
    Output(2) = 1;
    PairCount(1) = 1; %This is for straight
end


%________________________
%Flush Check on the board
for i = 1:4 %1 - hearts, 2 - diamonds, 3- clubs, 4- spades
    SuitCount(i)= sum(FlushCheck == i);
end
  
if max(SuitCount) >= 4
    Output(3) = 4;
elseif max(SuitCount) == 3
    Output(3) = 3;
elseif CC ~= 5
    if sum(SuitCount == 2) == 2
        Output(3) = 2;
    elseif max(SuitCount) == 2
        Output(3) = 1;
    end
end


%___________________________
%Straight Check on the board
for i = 1:14
    if PairCount(i) > 0
        StraightCheck(i) = 1;
        continue
    end
end

for i = 1:10
    StraightCheck2(i) = sum(StraightCheck(i:i+4));
end

MaxStraight = max(StraightCheck2);
if MaxStraight >= 4
    Output(4) = 4;
elseif MaxStraight >= 3
    Output(4) = 3;
elseif MaxStraight >= 2
    MaxPos = find(MaxStraight == StraightCheck2);
    Size1 = size(MaxPos,2);
    flag = 0;
    for i = 1:Size1
        if (MaxPos(i) == 1 || MaxPos(i) == 10)
            if flag == 0
                Output(4) = 1;
            end
        else
            if (StraightCheck2(MaxPos(i) - 1) == MaxStraight) || (StraightCheck2(MaxPos(i) + 1) == MaxStraight)
                Output(4) = 2;
                flag = 1;
            else
                Output(4) = 1;
            end
        end
    end
end


%_________________________
%Cleaning up for the river
if CC == 5
   if Output(3) < 3
       Output(3) = 0;
   end
   if Output(4) < 3
       Output(4) = 0;
   end
end
disp(Output)
end