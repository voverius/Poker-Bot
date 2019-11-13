function BestHand = EvaluateCards(SevenCards)


% PREPERATION

%SevenCards = uint8([111 43 101 131 121 64 113]);
PlayedCards = SevenCards;
PlayedCards = sort(PlayedCards,'descend');
SuitlessCards = PlayedCards./10;
FlushCheck = rem(PlayedCards,10);
SuitCount = uint8(zeros(1,4));
FlushSuit = 0;
StraightPosition = 0;
PairCount = uint8(zeros(1,14));
BestHand = int8(zeros(1,6));
PairAmount = uint8(zeros(1,6)); % 1st - 4 of a kind, 2nd & 3rd - triple (higher one first), 4&5&6th - doubles.
DoubleCount = 0;
TripleCount = 0;
SFPosition = 0;


for i = 1:7
    PairCount(1,SuitlessCards(i)) = PairCount(1,SuitlessCards(i))+1;
end

StraightCheck = uint8(zeros(1,7));
j = 1;

for i= 14:-1:2
    if PairCount(i)>0
        StraightCheck(1,j) = i;
        j = j+1;    
    end
    if PairCount(i) == 4
        PairAmount(1,1) = i;
    elseif PairCount(i) == 3
        TripleCount = TripleCount + 1;
        PairAmount(1,1+TripleCount) = i;
    elseif PairCount(i) == 2
        DoubleCount = DoubleCount + 1;
        PairAmount(1,3+DoubleCount) = i;
    end
end
StraightCheck = StraightCheck(StraightCheck~=0);


% FLUSH

for i=1:4 %1 - hearts, 2 - diamonds, 3- clubs, 4- spades
    SuitCount(i)= sum(FlushCheck == i);
end
  
for i = 1:4 
    if SuitCount(i)>=5
        FlushSuit = i;
        SuitCheck = (FlushCheck==FlushSuit);
    end
end


% STRAIGHT
if size(StraightCheck,2) >= 5;
    
    for i = 1:(size(StraightCheck,2)-4);
        if StraightCheck(i) - 4 == StraightCheck(i+4)
            StraightPosition = i;
            break
        end
    end
    
    if StraightPosition == 0 && StraightCheck(1) == 14 && StraightCheck(size(StraightCheck,2)) == 2 && StraightCheck(size(StraightCheck,2)-3) == 5
        StraightPosition = 4;
    end
end


% STRAIGHT FLUSH
if FlushSuit > 0 && StraightPosition > 0
     SFCheck = SuitlessCards(SuitCheck);

    for i = 1:(size(SFCheck,2)-4);
         
        if SFCheck(i) - 4 == SFCheck(i+4)
            SFPosition = i;
        end
    end

    if SFPosition == 0 && SFCheck(1) == 14 && SFCheck(size(SFCheck,2)) == 2 && SFCheck(size(SFCheck,2)-3) == 5
        SFPosition = 4;
    end    
end
       

% DECIDING THE HAND
if SFPosition == 4 
    BestHand(1,1) = 9; % STRAIGHT FLUSH
    BestHand(2:6) = 5:-1:1;
    
elseif SFPosition > 0 
    BestHand(1,1) = 9; % STRAIGHT FLUSH
    BestHand(2:6) = SFCheck(SFPosition:(SFPosition + 4)); 
    
elseif FlushSuit == 0 && StraightPosition == 0 && sum(PairAmount >= 1) == 0
    BestHand(1,1) = 1; % HIGH CARD
    BestHand(1,2:6) = SuitlessCards(1,1:5);
    
elseif FlushSuit == 0 && StraightPosition == 0 && sum(PairAmount(1:3)+PairAmount(5) >= 1) == 0
    BestHand(1,1) = 2; % PAIR
    BestHand(1,2:3) = PairAmount(4);
    SuitlessCards = SuitlessCards(SuitlessCards~=PairAmount(4));
    BestHand(1,4:6) = SuitlessCards(1,1:3);
    
elseif FlushSuit == 0 && StraightPosition == 0 && PairAmount(4)> 0 && PairAmount(5) > 0 && sum(PairAmount(1:3) >= 1) == 0
    BestHand(1,1) = 3; % 2 PAIR
    BestHand(1,2:3) = PairAmount(4);
    BestHand(1,4:5) = PairAmount(5);
    SuitlessCards = SuitlessCards(SuitlessCards~=PairAmount(4));
    SuitlessCards = SuitlessCards(SuitlessCards~=PairAmount(5));
    BestHand(1,6) = SuitlessCards(1,1);    
    
elseif FlushSuit == 0 && StraightPosition == 0 && PairAmount(2)> 0 && sum(PairAmount(3:6)+PairAmount(1) >= 1) == 0
    BestHand(1,1) = 4; % 3 OF A KIND
    BestHand(1,2:4) = PairAmount(2);
    SuitlessCards = SuitlessCards(SuitlessCards~=PairAmount(2));
    BestHand(1,5:6) = SuitlessCards(1,1:2);  

elseif FlushSuit == 0 && StraightPosition == 4 
    BestHand(1,1) = 5; % STRAIGHT
    BestHand(1,2:6) = 5:-1:1;
    
    
elseif FlushSuit == 0 && StraightPosition >= 1 
    BestHand(1,1) = 5; % STRAIGHT
    BestHand(1,2:6) = StraightCheck(1,StraightPosition:(StraightPosition+4));
   
elseif FlushSuit >= 1
    BestHand(1,1) = 6; % FLUSH
    SuitlessCards = SuitlessCards(SuitCheck);
    BestHand(1,2:6) = SuitlessCards(1,1:5);
    
elseif PairAmount(2) > 0 && PairAmount(3) > 0
    BestHand(1,1) = 7; % FULL HOUSE
    BestHand(1,2:4) = PairAmount(2);
    BestHand(1,5:6) = PairAmount(3);
    
elseif PairAmount(2) > 0 && PairAmount(4) > 0 
    BestHand(1,1) = 7; % FULL HOUSE
    BestHand(1,2:4) = PairAmount(2);
    BestHand(1,5:6) = PairAmount(4);
    
elseif PairAmount(1) > 0 
    BestHand(1,1) = 8; % 4 OF A KIND
    BestHand(1,2:5) = PairAmount(1);
    SuitlessCards = SuitlessCards(SuitlessCards~=PairAmount(1));
    BestHand(1,6) = SuitlessCards(1,1);   
  
end

end

