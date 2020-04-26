% function Output = EvaluateHand(Input)

%dev:
Input = uint8([140 30 140 130 130]);



%Used variables
Output = uint8(zeros(1,10));
PC = Input(1:2); %Player Cards
SC = Input./10; %Suitless cards
tempSC = SC; %this is to recover from modified SC
PSC = PC./10; %Suitless player cards
tempPSC = PSC;
Fch = rem(Input,10); %Flush check
CC = size(Input,2); %Card Count
Board = Input(3:CC);
BSC = Board./10; %Suitless Board Cards
tempBSC = BSC;
PairCount = uint8(zeros(1,14));
AnalBoard = EvaluateBoard(Board);
PCs = uint8(zeros(1,14)); %Player Cards scattered
KT = [14 11 8]; %Kicker threshold
if SC(1) == SC(2)
    %Pocket pair
    PP = 1;
else
    PP = 0;
end


%________________________________________________________________________________________________________
%                                          NEW SYSTEM:

%   1 - HIGH CARD:




%   2 - ONE PAIR:




%________________
%   3 - TWO PAIR:
    %2nd column:
    %1 - Overpair
    %2 - Top pair
    %3 - Second pair
    %4 - Two overs
    %5 - Board
    
    %3rd column
    %1 - Ace kicker
    %2 - Above J
    %3 - Above 8
    %4 - The rest
    %5 - Board


%_______________________
%   4 - THREE OF A KIND:
    %2nd column:
    %1 - set
    %2 - 2 on board
    %3 - 3 on board
    
    %3rd column:
    %1 - top kicker
    %2 - 2nd kicker
    %3 - the rest
    

%   5 - STRAIGHT:





%   6 - FLUSH:




%__________________
%   7 - FULL HOUSE:
    %2nd column:
    %0 - Full house is on the board
    %1 - Player's card only contributed to the secondary set
    %2 - Player's card only contributed to the main set
    %3 - Player's cards contributed to both sets
    
    %3rd column:
    %0 - Full house is on the board
    %1 - Top possible set/pair
    %2 - 2nd top possible set/pair
    %3 - lower possible set/pair

%______________________
%   8 - FOUR OF A KIND:
    %2nd column:
    %1 - made with pocket pair
    %2 - made with 3 on board
    %3 - made with 4 on board
    
    %3rd column:
    %1 - top kicker/pocket pair/3 on board
    %2:4 - kicker
    
%   9 - STRAIGHT FLUSH:









%_____________________________
%Checking for made/board pairs

for i = 1:CC
    PairCount(1,SC(i)) = PairCount(SC(i))+1;
end
for i = 1:2
    if PCs(PSC(i)) == 0
        PCs(PSC(i)) = 1;
    end
end
if PCs(14) == 1
    PCs(1) = 1;
end

if any(PairCount == 4)
    %4 of a kind
    Output(1) = 8;
    
    if AnalBoard(1) == 5
        %4 cards on board
        Output(2) = 3;
        Output(3) = 5;
        BSC = BSC(BSC ~= find(PairCount == 4));
        if any(max(PSC) > BSC)
            %player has a kicker
            for i = 1:3
                if any(max(PSC) >= KT(i))
                    Output(3) = i;
                    Output(4) = 1;
                    break
                end
            end
        end
    elseif PP == 1
        %2 cards on board
        Output(2) = 1; 
        Output(3) = 1;    
        Output(4) = 2; 
    else
        %3 cards on board
        Output(2) = 2;
        Output(3) = 1;
        Output(4) = 2; 
    end
elseif any(PairCount == 3)
    if any(PairCount == 2) || sum(PairCount == 3) == 2
        %full house
        Output(1) = 7;
        MainCard = find(PairCount == 3);
        SecondaryCard = find(PairCount == 2);
        if size(MainCard,2) == 2
            %2 sets of 3 of a kind (3 3)
            if any(PSC == MainCard(2))
                Output(2) = 2;
                Output(3) = 1;
                Output(4) = 1;
            else
                if AnalBoard(1) == 3
                    %no full house on board (3 1)
                    Output(2) = 1;
                    Output(3) = 2;
                    Output(4) = 1;
                    BSC = BSC(BSC ~= find(PairCount == 3));
                    if any(max(PSC) > BSC)
                        Output(3) = 1;
                    end
                else
                    %full house already on the board (3 2)
                    Output(2) = 0;
                    Output(3) = 0;
                    Output(4) = 0;
                end
            end          
        else
            %regular full house
            if PP == 1
                if AnalBoard(1) == 1
                    %one pair on board (2 1)
                    if MainCard > SecondaryCard
                        Output(2) = 2;
                    else
                        Output(2) = 1;
                    end
                    Output(3) = 3; %hand is the weakest unless proved otherwise
                    Output(4) = 2;
                    BSC = BSC(BSC ~= find(PairCount == 2));
                    BSC = BSC(BSC ~= PSC(1));
                    if size(BSC,2) > 0
                        if any(PSC(1) > max(BSC))
                            %top set
                            Output(3) = 1;
                        elseif size(BSC,2) > 1
                            if any(PSC(1) > max(BSC(BSC ~= max(BSC))))
                                %2nd set
                                Output(3) = 2;
                            end             
                        else
                            Output(3) = 2;
                        end
                    else
                        Output(3) = 1;
                    end
                elseif AnalBoard(1) == 2
                    %for a rare 3x2x2 situation (3 2 2)
                    BSC = BSC(BSC ~= PSC(1));
                    if MainCard > max(SecondaryCard)
                        Output(2) = 2;
                    else
                        Output(2) = 1;
                    end
                    Output(3) = 3;
                    Output(4) = 2;
                    if any(PSC(1) > BSC)
                        Output(3) = 1;
                    elseif size(BSC,2) > 1 && any(PSC(1) > max(BSC(BSC ~= max(BSC))))
                        Output(3) = 2;
                    end
                else
                    %three of a kind on baord (3 1)
                    BSC = BSC(BSC ~= find(PairCount == 3));
                    Output(2) = 1;
                    Output(3) = 3;
                    Output(4) = 2;
                    if size(BSC,2) > 0
                        if PSC(1) > max(BSC)
                            Output(3) = 1;
                        elseif size(BSC,2) > 1 && any(PSC(1) > max(BSC(BSC ~= max(BSC))))
                            Output(3) = 2;
                        end
                    else
                       Output(3) = 1;
                    end  
                end
            elseif any(PSC == MainCard)
                if AnalBoard(1) == 2
                    %two pairs on board (2 2)
                    Output(2) = 2;
                    Output(4) = 1;
                    if MainCard > max(SecondaryCard)
                        Output(3) = 1;
                    else
                        Output(3) = 2;
                    end                    
                else
                    %One Pair on board (2 1)
                    Output(2) = 2;
                    Output(4) = 2;
                    BSC = BSC(BSC ~= find(PairCount == 3));
                    PSC = PSC(PSC ~= find(PairCount == 3));
                    if PSC == max(BSC)
                        Output(3) = 1;
                    else
                        Output(3) = 2;
                    end                    
                end
            elseif any(PSC == SecondaryCard)
                %Three of a kind on board (3 1)
                Output(2) = 1;
                Output(4) = 1;
                BSC = BSC(BSC ~= find(PairCount == 3));
                if any(PSC == max(BSC))
                    Output(3) = 1;
                else
                    Output(2) = 2;
                end                
            else
                %Full house is already on the board
                Output(2) = 0;
                Output(3) = 0;
                Output(4) = 0;
            end
        end
    else
        %Three of a kind
        Output(1) = 4;
        
        if PP == 1
            %set
            Output(2) = 1;
            Output(4) = 2;
            BSC = BSC(BSC ~= find(PairCount == 3));
            if PSC(1) == max(BSC)
                Output(3) = 1;
            elseif any(PSC(1) > max(BSC(BSC ~= max(BSC))))
                Output(3) = 2;
            else
                Output(3) = 3;
            end
        else
            if AnalBoard(1) ~= 3
                %2 on board
                Output(2) = 2;
                Output(4) = 1;
                BSC = BSC(BSC ~= find(PairCount == 3));
                PSC = PSC(PSC ~= find(PairCount == 3));
                if PSC > max(BSC)
                    Output(3) = 1;
                    Output(4) = 2;
                elseif any(PSC > max(BSC(BSC ~= max(BSC))))
                    Output(3) = 2;
                    Output(4) = 2;
                else
                    Output(3) = 3;
                end                    
            else
                %3 on board
                Output(2) = 3;
                Output(4) = 1;
                BSC = BSC(BSC ~= find(PairCount == 3));
                if max(PSC) > max(BSC)
                    Output(3) = 1;
                elseif any(max(PSC) > max(BSC(BSC ~= max(BSC))))
                    Output(3) = 2;
                else
                    Output(3) = 3;
                end 
            end            
        end
    end
elseif sum(PairCount == 2) > 1
    %2 pairs
    Output(1) = 3;
    Pairs = find(PairCount == 2);
    NonPairs = find(PairCount == 1);
    NonPairs = NonPairs(NonPairs ~= PSC(1));
    NonPairs = NonPairs(NonPairs ~= PSC(2));
    if size(NonPairs,1) == 0
       NonPairs = 0; 
    end
    
    if size(Pairs,2) > 2
        %rare situation of three pairs - (2 2 2)
        if any(PSC == Pairs(3))
            %player holds top pair
            if max(PSC) > find(PairCount == 1)
                Output(2) = 2;
            else
                Output(2) = 3;
            end            
            if any(PSC == Pairs(2))
                %player has second pair as well
                Output(3) = 5;
                Output(4) = 2;  
            else
                if PP == 1
                    %overpair
                    if PSC(1) > find(PairCount == 1)
                        Output(2) = 1;
                    end
                    Output(3) = 5;
                    Output(4) = 2;
                else
                   %player has all three pairs (paired with bottom or not)
                   PSC = PSC(PSC ~= Pairs(3));
                   if PSC == Pairs(1)
                       %player has bottom pair as well
                       Output(3) = 5;
                       Output(4) = 1;
                   else
                       %player holds the kicker
                       if PSC > Pairs(1)
                           Output(4) = 2;
                           for i = 1:3
                              if PSC >= KT(i)
                                  Output(3) = i;
                                  break
                              end
                           end
                       else
                           Output(3) = 5;
                           Output(4) = 1;
                       end
                   end                   
                end                
            end            
        else
            %player does not hold top pair
            if max(PSC) > find(PairCount == 1)
                Output(2) = 3;
            else
                Output(2) = 4;
            end
            
            if PP == 1
                if PSC(1) == Pairs(2)
                    %player has mid pair
                    Output(3) = 5;
                    Output(4) = 2;                    
                else
                    %player has bottom pair and so plays the board
                    if Output(2) == 3
                       for i = 1:3
                          if PSC(1) >= KT(i)
                              Output(3) = i;
                              break
                          end
                       end   
                    else
                        Output(3) = 5;
                    end
                        
                    Output(2) = 5;
                    Output(4) = 0;                    
                end
            else
                if any(PSC == Pairs(2))
                    %players hit second pair
                    PSC = PSC(PSC ~= Pairs(2));
                    BSC = BSC(BSC ~= Pairs(2));
                    BSC = BSC(BSC ~= Pairs(3));
                    if size(BSC,2) > 0
                        if any(PSC > BSC)
                           for i = 1:3
                              if PSC >= KT(i)
                                  Output(3) = i;
                                  break
                              end
                           end                           
                        else
                           Output(3) = 5;
                           Output(4) = 1;
                        end                        
                    else
                        Output(3) = 5;
                        Output(4) = 2;                        
                    end
                else
                    %players only got third pair
                    Output(2) = 5;
                    PSC = PSC(PSC ~= Pairs(1));
                    BSC = find(PairCount == 1);
                    if PSC > BSC
                       for i = 1:3
                          if PSC >= KT(i)
                              Output(3) = i;
                              Output(4) = 2;
                              break
                          end
                       end                           
                    else
                        %playing the board
                        Output(3) = 4;
                        Output(4) = 0;
                    end           
                end
            end
        end
    else
        %simple two pair - (2 2)
        if PP == 1
            Output(4) = 2;
            if PSC(1) == Pairs(2)
                %Overpair
                Output(2) = 1;
                Output(3) = 5;
            else
                %Underpair
                if PSC(1) > max(NonPairs)
                    Output(2) = 3; 
                    Output(3) = 5;
                else
                    Output(2) = 4;
                    Output(3) = 5;
                end
            end            
        elseif any(PSC == Pairs(2))
            %has the top pair
            if Pairs(2) > NonPairs(size(NonPairs,2))
                Output(2) = 2;
            elseif size(NonPairs,2) > 1 && (Pairs(2) > NonPairs(size(NonPairs,2) - 1))
                Output(2) = 3;
            else
                Output(2) = 4;
            end
            
            if any(PSC == Pairs(1))
                %has bottom pair as well
                Output(3) = 5;
                Output(4) = 2;
            else
                %has only the top pair
                Output(4) = 2;
                PSC = PSC(PSC ~= Pairs(2));
                if PSC == 14 || any(NonPairs == 14)
                    %Ace kicker
                    Output(3) = 1;
                elseif PSC > max(NonPairs)
                    %any other kicker
                    Output(3) = 4;
                    for i = 1:3
                       if PSC >= KT(i)
                           Output(3) = i;
                           break
                       end
                    end                            
                else
                    %board
                    Output(3) = 5;
                    Output(4) = 1;
                end
            end
        elseif any(PSC == Pairs(1))
            %Has the bottom pair
            if Pairs(1) > NonPairs(size(NonPairs,2))
                Output(2) = 3;
            else
                Output(2) = 4;
            end           
            
            PSC = PSC(PSC ~= Pairs(1));
            if PSC > max(NonPairs)
                %Looking for kicker
                Output(3) = 4;
                Output(4) = 2;
                for i = 1:3
                   if PSC >= KT(i)
                       Output(3) = i;
                       break
                   end
                end                   
            else
                %Board is the kicker
                Output(3) = 5;     
                Output(4) = 1;
            end
        else
            %plays the board
            Output(2) = 5;
            if max(PSC) > max(NonPairs)
                Output(3) = 4;
                Output(4) = 1;
                for i = 1:3
                   if max(PSC) >= KT(i)
                       Output(3) = i;
                       break
                   end
                end                  
            else
               Output(3) = 5; 
            end
        end
    end
elseif sum(PairCount == 2) == 1
    %One Pair
    Output(1) = 2;
    Pairs = find(PairCount == 2);
    NonPairs = find(PairCount == 1);
    NonPairs = NonPairs(NonPairs ~= PSC(1));
    NonPairs = NonPairs(NonPairs ~= PSC(2));    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
end
























disp(Output)


% end