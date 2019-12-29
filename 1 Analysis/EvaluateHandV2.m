% function Output = EvaluateHandV2(Input)

%dev:
Input = uint8([81 91 32 122 32 103 114]);

%Sorting the cards out
CC = size(Input,2); %Card Count
Input(1:2) = sort(Input(1:2),'descend');
Input(3:CC) = sort(Input(3:CC),'descend');

%Used variables
Output = uint8(zeros(1,3));
PC = Input(1:2); %Player Cards
BC = Input(3:CC); %Board Cards
PSC = PC./10; %Suitless Player cards
BSC = BC./10; %Suitless Board Cards
SC = Input./10; %Suitless cards (all)
KT = [14 11 8]; %Kicker threshold
AB = EvaluateBoard(BC); %Analyzed Board
BoardCount = uint8(zeros(1,14));
PairCount = uint8(zeros(1,14));
SuitCount = uint8(zeros(1,4));
BFC = rem(BC,10); %Board Flush Check
PFC = rem(PC,10); %Player Flush Check
SFC = rem(Input,10); %Overall Flush Check m,
BF = uint8(zeros(1,4)); %Board Flush Count
PF = uint8(zeros(1,4)); %Player Flush Count

if PSC(1) == PSC(2)
    %Pocket pair
    PP = 1;
else
    PP = 0;
end


%________________________________________________________________________________________________________
%                                            NEW SYSTEM:




%   1st position - Made Hand Strength
%   0 - Nothing  - Playing the board - Air
%   1 - Trash    - Low strength
%   2 - Weak     - Connecting 1 card for a marginal strength
%   3 - Marginal - Connecting 1 card for a strong hand
%   4 - Strong   - Connecting both cards for a marginally strong hand
%   5 - Monster  - Connecting both cards for a very strong hands


%   2nd position - Board Negative Strength





%   3rd position - Possible draws (held)






%________________________________________________________________________________________________________
%                                             LET'S GO:





%Checking only the pairing of the board:
if PP == 1
    %Pocket Pairs:
    if AB(1) <= 1
        %The board is not paired
        if PSC(1) > max(BSC)
            %(QQ vs J87) || (QQ vs JTT)
            Output(1) = 4;  %Strong hand
        elseif any(BSC == PSC(1))
            %(QQ vs QJ7) || (QQ vs KKQ)
            Output(1) = 5;  %Monster hand
        elseif PSC(1) > max(BSC(BSC ~= max(BSC)))
            %(QQ vs AJ7) || (88 vs QQ7)
            Output(1) = 3; %Marginal hand
        else
            %(88 vs QJ7) || (88 vs AQQ)
            Output(1) = 1; %Weak hand
        end
    else
       %The board has paired 
        for i = 1:CC
            PairCount(1,SC(i)) = PairCount(SC(i))+1;
        end    
        for i = 3:CC
            BoardCount(1,SC(i)) = BoardCount(SC(i))+1;
        end          
        %   AnalyzeBoard Outputs:
        %   1 - One Pair
        %   2 - Two Pairs
        %   3 - Three of a kind
        %   4 - Full House
        %   5 - 4 of a kind
                    
        if AB(1) == 5
            %4 of a kind on board
            if PSC(1) == 14 || BoardCount(14) == 1 || PSC(1) == 13 && BoardCount(14) == 4
                %(AA vs 88889) || (KK vs 8888A) || (KK vs AAAA8)
                Output(1) = 5;
            elseif PSC(1) == 13 || PSC(1) == 12 && BoardCount(13) == 4
                %(KK vs 88889) || (QQ vs KKKK8)
                Output(1) = 2;
            else
                %(88 vs KKKK7)
                Output(1) = 0;
            end
        elseif AB(1) >= 3
            Trips = find(BoardCount == 3);
            Kickers = BSC(BSC ~= Trips);
            
            if size(Kickers,2) == 0
                %FLOP with trips
                if PSC (1) == 14 || PSC(1) == 13 && Trips == 14
                    %(AA vs 888) || (KK vs AAA)
                    Output(1) = 5;
                else
                    Output(1) = 4;
                end
            elseif AB(1) == 4
                %Full house on board
                pair = find(BoardCount == 2);
                if PSC(1) == pair
                    %Quads - (88 vs AAA88)
                    Output(1) = 5;
                elseif PSC(1) > pair
                    if Trips > pair
                        %(QQ vs AAA88)
                        Output(1) = 4;
                    else
                        %(QQ vs JJ888)
                        Output(1) = 3;                        
                    end
                else
                    %undercards - (22 vs AAAKK)
                    Output(1) = 0;
                end
            else
                %Trips on board
                if any(PSC(1) == Kickers)
                    if PSC(1) > Trips
                       %(KK vs 888K)
                       Output(1) = 5;
                    else
                       %(88 vs KKK8)
                       Output(1) = 3;                        
                    end
                elseif PSC (1) == 14 || PSC(1) > max(Kickers)
                    %(AA vs 888K) || (QQ vs 888J)
                    Output(1) = 4;
                elseif CC == 6 || (CC == 7 && PSC(1) > min(Kickers))
                    %(JJ vs KKKQ9)
                    Output(1) = 2;
                else
                    %(88 vs AAAJ9)
                    Output(1) = 0;
                end                
            end            
        else
            %two pairs on board
            pairs = find(BoardCount == 2); 
            Kicker = find(BoardCount == 1); 
            if any(PSC(1) == pairs)
                %(88 vs AA88)
                Output(1) = 5;
            elseif size(Kicker,2) == 0 
                if PSC(1) > max(pairs)
                    %(AA vs KK88)
                    Output(1) = 3;
                else
                    %(KK vs AA88)
                    Output(1) = 2;
                end
            else
                if PSC(1) == Kicker
                    if Kicker > max(pairs)
                        %(AA vs AKK88)
                        Output(1) = 5;
                    elseif Kicker > min(pairs)
                        %(QQ vs AAQJJ)
                        Output(1) = 3;
                    else
                        %(88 vs AAQQ8)
                        Output(1) = 2;
                    end                  
                else
                    if PSC(1) > max(pairs)
                        %(AA vs KKJJ8)
                        Output(1) = 3;
                    elseif PSC(1) > min(pairs)
                        %(QQ vs AATT8)
                        Output(1) = 2;
                    else
                        Output(1) = 0;
                    end
                end
            end
        end
    end
else
    if AB(1) == 0
        %The board is not paired
        if any(PSC(1) == BSC) && any(PSC(2) == BSC)
            %caught two pair
            if any(PSC == max(BSC)) && any(PSC == max(BSC(BSC ~= max(BSC))))
                %(AJ vs AJ7)
                Output(1) = 5;
            else
                %(A7 vs AJ7)
                Output(1) = 4;
            end
        elseif any(PSC == max(BSC))
            %top pair
            Kicker = PSC(PSC ~= max(BSC));
            if Kicker == 14 || (Kicker == 13 && any(BSC == 14))
                %top kicker - (AK vs AJ2)
                Output(1) = 4;
            else
                %low kicker - (AJ vs AK2)
                Output(1) = 3;
            end
        elseif any(PSC == max(BSC(BSC ~= max(BSC))))
            %2nd pair
            Kicker = PSC(PSC ~= max(BSC(BSC ~= max(BSC))));
            if Kicker == 14 || (Kicker == 13 && any(BSC == 14))
                %top kicker - (AJ vs KJ2)
                Output(1) = 3;
            else
                %low kicker - (JT vs KJ2)
                Output(1) = 2;
            end            
        elseif any(PSC(1) == BSC) || any(PSC(2) == BSC) 
            %low pair - (A6 - KT6)
            Output(1) = 2;
        elseif max(PSC) > max(BSC)
            %high card - (AK - QT9)
            Output(1) = 1;
        else
            %low cards - (87 vs A62)
            Output(1) = 0;
        end
    else
        %The board has paired
        for i = 3:CC
            BoardCount(1,SC(i)) = BoardCount(SC(i))+1;
        end          
        for i = 1:CC
            PairCount(1,SC(i)) = PairCount(SC(i))+1;
        end        
        %   AnalyzeBoard Outputs:
        %   1 - One Pair
        %   2 - Two Pairs
        %   3 - Three of a kind
        %   4 - Full House
        %   5 - 4 of a kind       
        
        if AB(1) == 5
            %4 of a kind on board
            if max(PSC) == 14 || BoardCount(14) == 1 || max(PSC) == 13 && BoardCount(14) == 4
                %(AK vs 88889) || (KQ vs 8888A) || (KQ vs AAAA8)
                Output(1) = 5;
            elseif max(PSC) == 13 || max(PSC) == 12 && BoardCount(13) == 4
                %(KQ vs 88889) || (QJ vs KKKK8)
                Output(1) = 2;
            else
                %(86 vs KKKK7)
                Output(1) = 0;
            end           
        elseif AB(1) == 4
            %full house on board
            Trips = find(BoardCount == 3);
            pair = find(BoardCount == 2);
            
            if any(PSC == Trips)
                %(AK vs AAA88)
                Output(1) = 5;
            elseif any(PSC == pair) && pair > Trips
                %(AK vs AA888)
                Output(1) = 5;
            else
                %(QJ vs AAAJJ) || (QJ vs AAAKK)
                Output(1) = 0;
            end
        elseif AB(1) == 3
            %trips on board
            Trips = find(BoardCount == 3);
            Kickers = BSC(BSC ~= Trips);            
            
            if any(PSC ==Trips)
                %(AK vs AAA87)
                Output(1) = 5;
            elseif size(Kickers,2) == 0
                if max(PSC) == 14 || Trips == 14 && max(PSC) == 13
                    %(AK vs 888) || (KQ vs AAA)
                    Output(1) = 2;
                else
                    %(89 vs KKK)
                    Output(1) = 1;
                end
            elseif any(PSC == max(Kickers))
                %(AK vs 888AQ)
                Output(1) = 4;
            elseif any(PSC == min(Kickers))
                %(89 vs AAAK8)
                Output(1) = 2;
            elseif CC == 6 || (CC == 7 && (max(PSC) > min(Kickers)))
                %(87 vs AAAK) || (A7 vs 888K)
                Output(1) = 1;
            else
                %(87 vs AAAKJ)
                Output(1) = 0;                
            end
        elseif AB(1) == 2
            %two pairs on board
            pairs = find(BoardCount == 2); 
            Kicker = find(BoardCount == 1); 
        
            if any(PSC(1) == pairs) || any(PSC(2) == pairs)
                if any(PSC == max(pairs))
                    %(AK vs AAQQ7)
                    Output(1) = 5;
                else
                    %(87 vs AA886)
                    Output(1) = 4;
                end
            elseif size(Kicker,2) == 0
                if max(PSC) > max(pairs)
                    %(AK vs 8877)
                    Output(1) = 1;
                else
                    %(87 vs AAKK)
                    Output(1) = 0;
                end
            elseif any(PSC == Kicker)
                if Kicker > max(pairs)
                    %(AK vs A9988)
                    Output(1) = 2;
                elseif Kicker > min(pairs) || max(PSC) > Kicker
                    %(87 vs AA228)
                    Output(1) = 1;
                else
                    %(87 vs AAKK8)
                    Output(1) = 0;
                end        
            elseif any(PSC > Kicker)
                if max(PSC) == 14 || (max(PSC) == 13 && any(pairs == 14))
                    %(A8 vs KKQQ9)
                    Output(1) = 1;
                else
                    %(87 vs KKQQ6)
                    Output(1) = 0;
                end
            else
                %(87 vs AAKK9)
                Output(1) = 0;
            end
        else
            %One pair on board
            pairs = find(BoardCount == 2); 
            Kickers = find(BoardCount == 1); %Board Kickers
            
            if any(PSC == pairs)
                kicker = PSC(PSC ~= pairs); %player kicker
                %connected for trips
                if any(kicker == Kickers)
                    %full house - (AK vs AAK)
                    Output(1) = 5; 
                else
                    %trips
                    if kicker == 14 || pairs == 14 && kicker == 13
                        %(AK vs KKQ) || (AK vs AAQ)
                        Output(1) = 5;
                    else
                        %(A2 vs AAQ)
                        Output(1) = 4;
                    end
                end
            elseif any(PSC(1) == Kickers) && any(PSC(2) == Kickers)
                %caught extra two pairs
                if max(PSC) > pairs
                    if max(PSC) == max(Kickers)
                        %(AK vs AK88)
                        Output(1) = 3;
                    else
                        %(KQ vs AKQ88)
                        Output(1) = 2;
                    end
                else
                    if max(PSC) > max(Kickers)
                        %(87 vs AA872)
                        Output(1) = 2;                        
                    else
                        %(87 vs AAK87)
                        Output(1) = 1;
                    end
                end
            elseif any(PSC == max(Kickers))
                if max(Kickers) > pairs || pairs == 14 && max(Kickers) == 13
                    %(AQ vs A88) || (KQ vs AAK)
                    Output(1) = 3;
                else
                    %(87 vs AA8)
                    Output(1) = 2;
                end
            elseif (CC == 6 && any(PSC == Kickers(1))) || (CC == 7 && any(PSC == Kickers(2)))
                %caught second top pair
                Output(1) = 2;
                if CC == 6
                    if Kickers(1) > pairs 
                        %(KQ vs AK88)
                        Output(1) = 2;
                    else
                        %(Q8 vs AKK8)
                        Output(1) = 1;
                    end
                elseif CC == 7
                    if Kickers(2) > pairs
                        %(KQ vs AK887)
                        Output(1) = 2;
                    else
                        %(Q8 vs AKK87)
                        Output(1) = 1;
                    end
                end
            else
                %did not catch any pairs/bottom pair
                if any(PSC == 14) || any(BSC == 14) && any(PSC == 13) || any(PSC(1) == Kickers) || any(PSC(2) == Kickers) 
                    %(A7 vs 88K) || (KQ vs A88) || (87 vs AAKQ8)
                    Output(1) = 1;
                else
                    %(87 vs AAKQ9)
                    Output(1) = 0;
                end
            end
        end
    end
end




%________________________________________________________________________________________________________
%Checking for straights & flushes
if any(PairCount == 4) || sum(PairCount == 3) == 2 || (any(PairCount == 3) && any(PairCount == 2))
    %full house or above
    
    %Maybe consider draws to a better full house? 
else
    draws = zeros(1,3); %1st - Overcards, 2nd - Flush, 3rd - Straight
    
    %_________
    %OVERCARDS
    if Output(1) <= 1
        if PSC(1) > max(BSC)
            if PSC(2) > max(BSC)
                draws(1) = 2;
            else
                draws(1) = 1;
            end
        elseif PSC(2) > max(BSC)
            draws(1) = 1;
        end
    end
    
    
    %_____
    %FLUSH
    for i = 1:4
        BF(i)= sum(BFC == i);
        PF(i)= sum(PFC == i);
        SuitCount(i)= sum(SFC == i);
    end    
    Flush = 0;
    
    if max(SuitCount) >= 5
        %flush is already made
        FlushSuit = find(SuitCount == max(SuitCount));
        Flush = 1;
        SFflag = 0; %straight flush flag
        Output(3) = 0; %no room to improve more
        
        tBFC = BSC(BFC == FlushSuit); %temp Suitless flushed Board cards
        tPFC = PSC(PFC == FlushSuit);
        tSFC =  SC(SFC == FlushSuit);
        tSFC = sort(tSFC,'descend');
        if any(tSFC == 14)
            tSFC(size(tSFC,2)+1) = 1;
        end
        
        for i = 1:(size(tSFC,2)-4)
            if tSFC(i) - 4 == tSFC(i+4)
                %Straight Flush
                SFflag = 1;
                if tSFC(i+4) <= tPFC(1) && tPFC(1) <= tSFC(i) ||...
                   PF(FlushSuit) == 2 && tSFC(i+4) <= tPFC(2) && tPFC(2) <= tSFC(i) ||...
                   tSFC(i+4) == 1 && tPFC(1) == 14

                    %Player has the card to contribute
                    Output(1) = 5;
                    Output(2) = 0;
                else
                    %playing the board
                    Output(1) = 0;
                    Output(2) = 5; 
                end
                break
            end
        end
        
        if SFflag == 0
            if PF(FlushSuit) > 0
                if PF(FlushSuit) == 2 && BF(FlushSuit) == 3
                    %(hh vs hhhcd)
                    if AB(1) == 0
                        %no pairs
                        Output(1) = 5;
                        Output(2) = 0;
                    elseif AB(1) == 1
                        %one pair
                        Output(1) = 5;
                        Output(2) = 2;
                    else
                        %two pair/trips on board
                        Output(1) = 3;
                        Output(2) = 5;
                    end
                else
                    %(hc vs hhhhd) || (hh vs hhhhd)
                    if max(tPFC) == 14 || (tPFC == 15 - find(tSFC == max(tPFC)))
                        %top kicker for nuts
                        Output(1) = 5;
                        if AB(1) == 0
                            Output(2) = 0;
                        else
                            Output(2) = 1;
                        end
                    elseif tPFC == 13 || (tPFC == 14 - find(tSFC == max(tPFC)))
                        %2nd kicker
                        Output(1) = 4;
                        if AB(1) == 0
                            Output(2) = 0;
                        else
                            Output(2) = 1;
                        end
                    else
                        %3rd kicker and below
                        Output(1) = 2;
                        Output(2) = 3;
                    end
                end
            else
                %Playing the board - (cc vs hhhhh)
                Output(1) = 0;
                Output(2) = 5; %max danger
                Output(3) = 0; %no escape
            end
        end
    elseif CC ~= 7
        %Checking draws pre-river
        FlushSuit = find(SuitCount == max(SuitCount));
        if size(FlushSuit,2) > 1
            %no flush is possible for hero!
            %flop - (hh vs ccd) -> (hh vs ccdhh)
            %turn - (hh vs ccdd) -> (hh vs ccddh) || (hh vs hccc) -> (hh vs hccch)
            %This can only mean that hero should beware of others getting a flush!
            
            if any(BF == 3)
                %(hh vs ccch)
                Output(2) = 3;
            elseif sum(BF == 2) == 2
                %(hh vs ccdd)
                Output(2) = 2;
            else
                %(hh vs ccds)
                Output(2) = 1;
            end
        else
            tBFC = BSC(BFC == FlushSuit); %temp Suitless flushed Board cards
            tPFC = PSC(PFC == FlushSuit);
            tSFC =  SC(SFC == FlushSuit);
            tSFC = sort(tSFC,'descend');            

            if max(SuitCount) == 4
            %one card to flush
        
                if PF(FlushSuit) == 2
                    %player has two cards
                    if CC == 5 || tPFC(1) == 14 || (tPFC(1) == 15 - find(tSFC == tPFC(1)))
                        %drawing to the nuts - (hh vs hhcc)
                        draws(2) = 4;
                    else
                        %drawing low - (87 vs AK2)(hh vs hhc)
                        draws(2) = 3;
                    end

                    %Evaluating the board situation
                    if AB(1) == 0
                        %Board not paired
                        Output(2) = 0;
                    elseif AB(1) == 1
                        %board is paired
                        Output(2) = 2;
                    else
                        if Output(1) > 2
                            %board texture actually helps the hand
                            Output(2) = 0;
                        else
                            %sitting with low pair, need the flush, board's bad
                            Output(2) = 5;
                        end
                    end
                elseif PF(FlushSuit) == 1
                    %player has one card
                    if tPFC(1) == 14 || (tPFC == 15 - find(tSFC == tPFC(1)))
                        %drawing to the nuts - (hc vs hhhc)
                        draws(2) = 3;
                    else
                        %drawing low - (77 vs AK2)(hc vs hhh)
                        draws(2) = 2;
                    end

                    %Evaluating the board situation
                    if AB(1) == 0
                        Output(2) = 0;
                    else
                        %as the board has to have 3 cards, it can only have 1 pair                  
                        Output(2) = 1;
                    end
                else
                    %4 flush cards on board - (hh vs ccccd)
                    draws(2) = 0;
                    Output(2) = 5;
                end
            elseif max(SuitCount) == 3
                %runner runner
                if CC == 5 && PF(FlushSuit) == 2
                    draws(2) = 1;  
                elseif CC == 5 && PF(FlushSuit) == 1
                    %(hd vs hhd)
                    if tPFC(1) == 14 || (tPFC == 15 - find(tSFC == tPFC(1)))
                        draws(2) = 1;
                    end
                    Output(2) = 2; %possible flush draw
                elseif BF(FlushSuit) == 3
                    %no draw - (hh vs cccd)
                    Output(2) = 3;
                else
                    %turn
                    if BF(FlushSuit) == 2
                        %(hd vs hhcs)
                        Output(2) = 2;
                    else
                        %(hh vs hdcs)
                        Output(2) = 0;
                    end
                end
            end
        end
    else
        %Checking river situation
        if max(BF) >= 3
           %flush is possible
           if max(BF) == 4
               Output(2) = 5;
           else
               Output(2) = 3;
           end
        else
            %no flush is possible
            Output(2) = 0;
        end
    end

    
    %______________________
    %STRAIGHT OUTTA CAMPTON 
    StraightCheck = zeros(1,14);
    if Flush == 0
        PSC = sort(PSC,'descend'); %suitless player cards
        BSC = sort(BSC,'descend'); %suitless board cards
        SC  = sort( SC,'descend'); %all cards suitless
        
        
        %Sorting player cards
        PS = zeros(1,3); %unique player cards (includes both 14 & 1)
        if PP == 0
            PS(1:2) = PSC(1:2);
        else
            PS(1) = PSC(1);
        end
        if PS(1) == 14
            PS(3) = 1;
        end
        PS = PS(PS~=0);
        
        
        %Sorting the board
        BS = zeros(1,CC-1); %unique board cards (includes both 14 & 1)
        BS(1) = BSC(1);
        temp = 2;
        for i = 2:(CC-2)
            if BSC(i) ~= BS(temp-1) 
                BS(temp) = BSC(i);
                temp = temp + 1;
            end
        end
        if BS(1) == 14
            BS(CC-1) = 1;
        end
        BS = BS(BS~=0);
        
        
        %Sorting the board
        SS = zeros(1,CC+1); %all unique cards (includes both 14 & 1)
        SS(1) = SC(1);
        temp = 2;
        for i = 2:(CC)
            if SC(i) ~= SS(temp-1)
                SS(temp) = SC(i);
                temp = temp + 1;
            end
        end
        if SS(1) == 14
            SS(CC+1) = 1;
        end
        SS = SS(SS~=0);        
        Size1 = size(SS,2);
        
        
        %CHECK WHAT WE"VE GOT
        if CC ~= 7 %flop & turn situation
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
        else %river
            
            %checking if the player has a straight made
            if Size1 >= 5
                for i = 1:(Size1-4)
                    if SS(i) - 4 == SS(i+4)
                        %straight is made
                        
                        
                        
                        
                        
                        break
                    end
                end
                
                
                
            else
                
                
               
                
                
            end
            
            
            
            
            
            
            
            
            
            
            
            
            
            
        end
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        

        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    end
end
disp(Output)
% end