% function [HH,Output] = EvaluateTable(HH,AllCards)
HH = gs;
%loading variables 
for i = 1:6
    if HH{1,i,1} == 1
        Hero = i;
        break
    end
end
summary = HH{6,Hero,1};
IsIn = summary{14,1};
AmIn = sum(IsIn);
POT = summary{6,1};
TM = summary{16,1};
Output = cell(3,1);
Position = 1;
Chopped = 0;               %in case the pot will be chopped


if AmIn == 1
    Ranks = IsIn;
else
    %Dealing the rest of the cards
    SevenCards = uint8(zeros(1,7));
    for j = 3:7
        SevenCards(j) = AllCards(randi(size(AllCards,2)));
        AllCards = AllCards(AllCards ~= SevenCards(j));
    end
    Output{2,1} = SevenCards(3:7);
    
    %Evaluating the hand of each player
    Results = uint8(zeros(AmIn,7));
    for j = 1:6
        if IsIn(j) == 0
            continue
        else
            SevenCards(1:2) = HH{3,j,1};
        end
        Results(Position,1:6) = EvaluateCards(SevenCards);
        Results(Position,7) = j;
        Position = Position + 1;         
    end
    Output{1,1} = Results;
    
    %Ranking the hands              BEASTIALITY MODE
    
    Ranks = zeros(6,1);     %matrix position stores corresponding players ranking
    SplitWinners = 0;       %in case of double tie (2 vs 2) saves which group is ahead
    SplitLosers = 0;        %in case of triple tie (2 vs 2 vs 2) saves which group is behind
    quit = 0;               %stops checking current column in results
    run = 0;                %stops checking for double winners (2 vs 2)
    flag = 0;               %no more results to be checked
    front = 1;              %best results position
    back = AmIn;            %worst results position
    OneWinner = 0;          %in case one person covers all the others (money wise)
    for j = 1:6
        while quit == 0
            if size(Results,1) == 0
                flag = 1;
                break
            end
            MaxResult = max(Results(:,j));
            MaxPosition = find(Results(:,j) == MaxResult);
            SizeMax = size(MaxPosition,1);
            MinResult = min(Results(:,j));
            MinPosition = find(Results(:,j) == MinResult);
            SizeMin = size(MinPosition,1);
            
            %this is to find single top player
            if SizeMax == 1
                if run == 1 
                    if any(SplitWinners == MaxPosition)
                        Ranks(Results(MaxPosition,7)) = front;
                        if size(SplitWinners,1) == 1 && TM(Results(MaxPosition,7)) == max(TM)
                            if front == 1 %to stop further winners from entering the loop
                                OneWinner = 1;
                            end
                            flag = 1;
                            break
                        end
                        SplitWinners = (1:(size(SplitWinners,1)-1))';
                        Results(MaxPosition,:) = [];
                        front = front + 1;
                    else
                        Ranks(Results(MaxPosition,7)) = splitfront;
                        Results(MaxPosition,:) = [];
                        splitfront = splitfront + 1;
                    end
                else
                    Ranks(Results(MaxPosition,7)) = front;
                    if TM(Results(MaxPosition,7)) == max(TM) %in case this player has everyone covered
                        if front == 1 %to stop further winners from entering the loop
                            OneWinner = 1;
                        end
                        flag = 1;
                        break
                    end
                    Results(MaxPosition,:) = [];
                    front = front + 1;
                end

            %to remove single losers from the main matrix    
            elseif SizeMin == 1
                if run == 1
                    if any(SplitWinners == MinPosition)
                        Ranks(Results(MinPosition,7)) = size(SplitWinners,1);
                        SplitWinners = (1:(size(SplitWinners,1)-1))';
                        Results(MinPosition,:) = [];
                    else
                        Ranks(Results(MinPosition,7)) = back;
                        Results(MinPosition,:) = [];
                        back = back - 1;
                    end
                else
                    Ranks(Results(MinPosition,7)) = back;
                    Results(MinPosition,:) = [];
                    back = back - 1;
                end
                
            %in case of the multiple tie situation    
            elseif run == 0 && SizeMax < size(Results,1)
                SplitWinners = MaxPosition;
                if sum(summary{15,1}) == 0 || any(TM(SplitWinners) == max(TM))
                    Results = Results(MaxPosition,:);
                else
                    tempResults = Results;
                    Results = Results(SplitWinners,:);
                    tempResults(SplitWinners,:) = [];
                    Results = [Results;tempResults]; %#ok<AGROW>
                    SplitWinners = (1:size(SplitWinners,1))';
                    splitfront = size(SplitWinners,1) + 1;
                    run = 1;
                    if size(Results,1) == 6 && 6 > SizeMax + SizeMin
                        SplitLosers = MinPosition;
                    end
                end

            %for a massive pot
            elseif run == 1 && size(SplitWinners,1) < size(Results,1)
                tempResults = Results;
                tempResults(SplitWinners,:) = [];
                
                MaxResult = max(tempResults(:,j));
                MaxPosition = find(tempResults(:,j) == MaxResult);
                SizeMax = size(MaxPosition,1);
                MinResult = min(tempResults(:,j));
                MinPosition = find(tempResults(:,j) == MinResult);
                SizeMin = size(MinPosition,1);
                
                if SizeMax == 1
                    Ranks(tempResults(MaxPosition,7)) = splitfront;
                    tempResults(MaxPosition,:) = [];
                    splitfront = splitfront + 1;
                elseif SizeMin == 1
                    Ranks(tempResults(MinPosition,7)) = back;
                    tempResults(MinPosition,:) = [];
                    back = back - 1;
                else
                    break
                end
                
                Results = Results(SplitWinners,:);
                Results = [Results;tempResults]; %#ok<AGROW>
                SplitWinners = (1:size(SplitWinners,1))';
                
            %for the final column analysis    
            elseif j == 6
                %chopping time
                if size(Results,1) < 4
                    for k = 1:size(Results,1)
                        Ranks(Results(k,7)) = front;
                    end
                    Chopped = front;
                else
                    if SplitWinners == 0
                        for k = 1:size(Results,1)
                            Ranks(Results(k,7)) = front;
                        end
                    else %IN CASE OF MASSIVE MULTIWAY
                        Size1 = size(SplitWinners,1);
                        for k = 1:Size1
                            Ranks(Results(SplitWinners(k),7)) = front;
                        end
                        
                        if SplitLosers == 0
                            front = front + 1;
                            for k = 1:size(Results,1)
                                Ranks(Results(k,7)) = front;
                            end
                        else
                            front = front + 2;
                            for k = 1:size(SplitLosers,1)
                                Ranks(Results(SplitLosers(k),7)) = front;
                            end
                            Splits = [SplitWinners; SplitLosers];
                            Results(Splits,:) = [];
                            front = front - 1;
                            for k = 1:size(Results,1)
                                Ranks(Results(k,7)) = front;
                            end
                        end
                    end
                    Chopped = front;
                end
                flag = 1;
                break
            else
                break               
            end
        end
        if flag == 1
            Output{3,1} = Ranks;
            break
        end
    end     
end



%___________________________________________CASHIER______________________________________________________

%simple case of single winner
if sum(summary{15,1}) == 0 || OneWinner == 1
    if Chopped > 0 
        winner = find(Ranks == 1);
        Size1 = size(winner,1);
        for i = 1:Size1
             HH{2,winner(i),1} = HH{2,winner(i),1} + round((POT/Size1),2);
        end
    else
        winner = find(Ranks == 1);
        HH{2,winner,1} = HH{2,winner,1} + POT; %to be developed for further streets
    end
    
%in case someone went all in, and the smaller pot contender was ahead of the rest     
else
    for i = 1:max(Ranks)
        if all(TM == 0)
            break
        end
        winner = find(Ranks == i);
        Size1 = size(winner,1);
        
        
        %if there'e no people with this rank
        if Size1 == 0
            continue
                    
        %if there's only one winner for that position
        elseif Size1 == 1
            WinnersShare = TM(winner); %how much money has the player put in the POT
            SidePot = 0;
            for j = 1:6
                if TM(j) >= WinnersShare
                    SidePot = SidePot + WinnersShare;
                    TM(j) = TM(j) - WinnersShare;
                elseif TM(j) == 0
                    continue
                else
                    SidePot = SidePot + TM(j);
                    TM(j) = 0;
                end
            end
            HH{2,winner,1} = HH{2,winner,1} + SidePot; 
            continue
        
        %this is for special rare case when there's chopped pot    
        else
            %working out Side pot entitlements
            SidePot = zeros(Size1,1);
            SPcheck = zeros(Size1,1); %checking who has the smallest entitlement
            for j = 1:Size1
                SPcheck(j) = TM(winner(j));
            end
            [~,idx] = sort(SPcheck,1);
            winner = winner(idx,:);
            for j = 1:Size1
                WinnersShare = TM(winner(j));
                if WinnersShare == max(TM)
                    SidePot(j) = sum(TM);
                else
                    for k = 1:6
                        if TM(k) >= WinnersShare
                            SidePot(j) = SidePot(j) + WinnersShare;
                        elseif TM(j) == 0
                            continue
                        else
                            SidePot(j) = SidePot(j) + TM(k);
                        end
                    end
                end
            end
            
            
            %if all side pots are of the same size
            if all(SidePot == max(SidePot))
                for j = 1:Size1
                    HH{2,winner(j),1} = HH{2,winner(j),1} + round((SidePot(1)/Size1),2);
                end
                if sum(TM) == SidePot(1)
                    TM = zeros(6,1);
                else
                    WinnersShare = max(TM(winner));
                    for j = 1:6
                        if TM(j) >= WinnersShare
                            TM(j) = TM(j) - WinnersShare;
                        else
                            TM(j) = 0;
                        end
                    end
                end
                continue
                
            %if one of the sidepots is different to the other    
            else
                tempwinner = winner;
                tempsidepot = SidePot;
                for j = 1:Size1
                    Size2 = size(winner,1);
                    if Size2 == 0
                        break
                    end
                    for k = 1:Size2
                        HH{2,winner(k),1} = HH{2,winner(k),1} + round((min(SidePot)/Size2),2);
                    end
                    if Size2 == 1
                        break
                    end
                    SidePot = SidePot - min(SidePot);
                    SidePot = SidePot(SidePot ~= 0);
                    remove = find(TM == min(TM(winner)));
                    for k = 1:size(remove,1)
                        winner = winner(winner ~= remove(k));
                    end
                end
                
                %sorting out TM's in case of further players
                winner = tempwinner;
                SidePot = tempsidepot;
                if sum(TM) == max(SidePot)
                    TM = zeros(6,1);
                else
                    WinnersShare = max(TM(winner));
                    for j = 1:6
                        if TM(j) >= WinnersShare
                            TM(j) = TM(j) - WinnersShare;
                        else
                            TM(j) = 0;
                        end
                    end
                end
            end
        end
    end
end

%Delete this line when this is transformed into a function
gs(2,:) = HH(2,:);
% end