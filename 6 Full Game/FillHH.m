function [HH,error] = FillHH(HH,street)
    
TH = HH(:,:,street); %constructing temporary HH for ease of processing
temp = zeros(1,8);
error = 0;

for i = 1:6
    if TH{1,i} == 1
        Hero = i;   
    end
end

%Creating a summary variable
if size(TH{3,4},1) == 1
    summary = cell(16,2);
    summary(1:size(summary,1),1) = {0};
    summary{1,2}  = 'Limpers';
    summary{2,2}  = 'BET';
    summary{3,2}  = 'Steal Bet';
    summary{4,2}  = 'Iso Bet';
    summary{5,2}  = 'Continuation Bet';
    summary{6,2}  = 'Pot Size';
    summary{7,2}  = 'Round Bet';
    summary{8,2}  = 'Equillibrium';
    summary{9,2}  = 'Last Raise';
    summary{10,2} = 'Raise Stop';
    summary{11,2} = 'In-Position Status';
    summary{12,2} = 'Current Line';
    summary{13,2} = 'Last Street';
    summary{14,2} = 'Is-In Status';
    summary{15,2} = 'All-in Status';
    summary{16,2} = 'Total Moneys In';
    
    SB = TH{3,3}(1);
    BB = TH{3,3}(2);
    
    Limpers = 0;   
    BET = 1;
    SBet = 0;
    IBet = 0;
    CBet = 0;
    ABet = 0;
    RoundBet = BB;
    Eq = uint8(zeros(6,1));
    LastRaise = 0;
    AIp = 0;
    CL = 7;
    TM = zeros(6,1);
    IsIn = uint8(zeros(6,1));
    AI = uint8(zeros(6,1));
    PlayersIn = TH{4,4};

    fresh = 1;
    LastStreetFilled = 1;
    
    %Sorting out who was in at the start of the hand
    for i = 1:6
        if TH{1,i} == 0
            continue
        elseif TH{4,3}(TH{1,i}) == 1
            IsIn(i) = 1;
        end        
    end
    
    %Working out the blinds
    if TH{1,1} ~= 0
        POT = SB + BB + TH{3,4};
        TH{5,1} = SB;
        TH{5,2} = BB;
    else
        POT = BB + TH{3,4};
        TH{5,2} = BB;
    end
    
    %Seeing if there's any dead money posted
    if Hero > 2
        for i = Hero:6
            if i == Hero
                if TH{5,i} > 0
                    POT = POT + TH{5,i};
                    TH(5,i) = TH(5,i);
                end
            elseif TH{7,i} > 0
                POT = POT + TH{7,i};
                TH(5,i) = TH(7,i);
            end
        end
    end
    
    TH{3,4} = [];
    
else
    summary = HH{3,4,1};
    
    Limpers = summary{1,1};   
    BET = summary{2,1};
    SBet = summary{3,1};
    IBet = summary{4,1};
    CBet = summary{5,1};
    POT = summary{6,1};
    RoundBet = summary{7,1}; 
    Eq = summary{8,1};
    LastRaise = summary{9,1};    
    AIp = summary{10,1}; 
    ABet = summary{10,1}; %The fact that this is currently an all-in for someone - (0/1)
    CL = summary{12,1};
    LastStreet = summary{13,1};
    IsIn = summary{14,1};
    AI = summary{15,1};
    TM = summary{16,1};
    SB = TH{3,3}(1);
    BB = TH{3,3}(2);
    fresh = 0;
    PlayersIn = TH{4,4};
    
    if LastStreet == street
        LastStreetFilled = 1;
    else
        LastStreetFilled = 0;
    end
end


%sorting out the variables
quit = 0;
itteration = 0;
ActualPot = TH{3,2};


while quit == 0
 
    %Filling previous strret as well
    if LastStreetFilled == 0
        if itteration == 0
            street = street - 1;
            TH = HH(:,:,street);
        end
        Eqt = Eq(Eq~=0);
        if all(Eqt == max(Eqt))
            LastStreetFilled = 1;
            street = street + 1;
            TH = HH(:,:,street);
            i = 0;
            
            %New street variables:
            BET = 0;
            RoundBet = 0;
            CL = 7;
            ABet = 0;
            fresh = 1;
            
            if CBet == 1
                CBet = 3;
            elseif CBet == 2;
                CBet = 3;
            elseif CBet == 3;
                CBet = 0;
            end      
        end
    end
    
    %work out position skipping the blinds
    if itteration == 0
        if fresh == 1;
            if street == 1
                i = 2;
            else
                i = 0;
            end
        else
            i = Hero - 1;
        end
        itteration = 1;
    end
    
    i = i + 1;
    if i > 6
        i = i - 6;
    end
    
    %skip empty seats
    if TH{1,i} == 0
        IsIn(i) = 0;
        continue
    end    
    
    %Check Status'
    if Hero ~= 6 && sum(IsIn((Hero+1):6)) == 0
        summary{11,1} = 1;
    end     

    if any(AI == 1)
        if sum(AI) == sum(IsIn) - 1
            AIp = 1;
        end
    end
    

    %Preparing for the action
    Size1 = size(TH{CL,i},2);
    if Size1 > 1
        CL = CL + 1;
        if CL > size(TH,1)
            TH{CL,1} = [];
            HH{CL,1} = [];
        end
    end
    
    
    %Getting the fold
    fold = 0;
    Size1 = size(TH{CL,i},2);
    if PlayersIn(TH{1,i}) == 0 && IsIn(i) == 1
        fold = 1;
    end

    
    %stop filling if it's 'hero's' turn
    if i == Hero && LastStreetFilled == 1
        if Hero <= 2 && street == 1 && fresh == 1 %was Hero == 2
            TH{CL,i} = [];
        end
        Size1 = size(TH{CL,i},2);
        if Size1 ~= 1
            summary{1,1}  = Limpers;
            summary{2,1}  = BET;
            summary{3,1}  = SBet;
            summary{4,1}  = IBet;
            summary{5,1}  = CBet;
            summary{6,1}  = POT;
            summary{7,1}  = RoundBet;
            summary{8,1}  = Eq;
            summary{9,1}  = LastRaise;
            summary{10,1} = AIp;
            summary{12,1} = CL;
            summary{13,1} = street;
            summary{14,1} = IsIn;
            summary{15,1} = AI;
            summary{16,1} = TM;
            TH{3,4} = summary;
            break
        end
    end
  
    if TH{2,i} == 0 && size(TH{CL,i},2) ~= 1
        continue
    elseif IsIn == 0
        continue
    end


    
%___________________________________________ DOING THE JOB _____________________________________________    
   

%             The New Way cube definitions is as follows:
%             
%  !!! First collumn defines the action taken where:
%        1 - fold
%        2 - call
%        3 - bet
%        4 - check
%  !!! Second collumn defines which BET level was reached AFTER the action was taken
%  !!! Third line defines the style of the action where:
%        1 - no limpers
%        2 - 1 limper
%        3 - 2+ limpers
%        4 - regular
%        5 - steal
%        6 - isolation
%        7 - 3Bet
%        8 - continuation
%        9 - steal re-raise
%        10 - continuation re-raise
%        11 - all in

    %CHECK
    if TH{CL,i} == RoundBet
        if street == 1 && BET == 1 && i == 2 || BET == 0
            temp(1) = 4;
            temp(2) = BET;
            temp(4) = 0;
            temp(5) = 0;
            temp(6) = RoundBet;
            temp(7) = POT;
            temp(8) = TH{2,i};        

            if street == 1
                if Limpers == 1
                    temp(3) = 2;
                else 
                    temp(3) = 3;
                end
            else
                if LastRaise == i && street == 2 && BET == 0
                    temp(3) = 8;
                elseif LastRaise == i && CBet == 3
                    temp(3) = 8;
                else
                    temp(3) = 4;
                end
            end
            TH{CL,i} = temp;
            TH{5,i} = RoundBet;
            Eq(i) = BET;
            continue
        end
    end

    
    %FOLD
    if fold == 1
        temp(1) = 1;
        temp(2) = BET;
        temp(4) = 0;
        temp(5) = RoundBet - TH{5,i};
        temp(6) = RoundBet;
        temp(7) = POT;
        temp(8) = TH{2,i};        
        
        if street == 1
            if CL == 7 && i > 2 && TH{7,i} ~= 0 %fold after posting BB/SB
                POT = POT + TH{7,i};
                POT = round(POT,2);
            end
            
            if BET == 1
                if Limpers == 0
                    temp(3) = 1;
                elseif Limpers == 1
                    temp(3) = 2;
                else 
                    temp(3) = 3;
                end
            elseif BET == 2 && SBet == 1 && i == 2
                temp(3) = 5;
            elseif BET > 1 && CL == 8
                temp2 = TH{7,i};
                if BET == 3 && temp2(1) == 3 && temp2(2) == 2
                    if temp2(3) == 5
                        temp(3) = 5;
                    else
                        temp(3) = 7;
                    end
                elseif BET == 2 && IBet == 1 && temp2(3) < 4 
                    temp(3) = 6;
                elseif ABet == 1
                    temp(3) = 11;
                else
                    temp(3) = 4;
                end
            elseif ABet == 1 && CL > 7
                temp(3) = 11;
            else
                temp(3) = 4;
            end
        else
            if CBet == 1
                temp(3) = 8;
            elseif ABet == 1
                temp(3) = 5;
            elseif BET == 2 && CBet == 2 && LastRaise == i
                temp(3) = 10;
            else
                temp(3) = 4;
            end
        end
        TH{CL,i} = temp;
        Eq(i) = 0;
        IsIn(i) = 0;
        continue
    end
    
    
    %CALL
    if TH{CL,i} <= RoundBet
        
        if CL > 7
            temp2 = TH{CL-1,i};
            if temp2(1) == 3
                PR = temp2(5);
            else
                PR = temp2(6); %Previous Round Moneyz
            end
        elseif CL == 7
            if i == 1
                PR = SB;
            elseif i == 2
                PR = BB;
            else
                PR = TH{5,i};
            end                
        end
                
        temp(1) = 2;
        temp(2) = BET;
        if TH{2,i} == 0
            temp(4) = 1;
            AI(i) = 1;
        else
            temp(4) = 0;
        end
        temp(5) = TH{CL,i} - PR;
        temp(6) = RoundBet;
        temp(7) = POT;
        temp(8) = TH{2,i} + temp(5);
        
        if street == 1
            if BET == 1
                if Limpers == 0
                    temp(3) = 1;
                elseif Limpers == 1
                    temp(3) = 2;
                else
                    temp(3) = 3;
                end
                Limpers = Limpers + 1;
            elseif BET == 2
                if SBet == 1 && i == 2
                    temp(3) = 5;
                elseif IBet == 1 && CL == 8
                    temp(3) = 6;
                else
                    temp(3) = 4;
                    IBet = 0;
                    SBet = 0;
                end
            elseif BET == 3
                if CL > 7
                    temp2 = TH{CL-1,i};
                    if temp2(1) == 3
                        temp(3) = 7;
                    else
                        temp(3) = 4;
                    end
                else
                    temp(3) = 4;
                end
            elseif ABet == 1 && CL > 7
                temp(3) = 11;
            else
                temp(3) = 4;
            end
        elseif BET == 1 && CBet == 1
            temp(3) = 8;
        else
            temp(3) = 4;
        end

        POT = POT + temp(5);
        TM(i) = TM(i) + temp(5);
        TH{5,i} = TH{CL,i};
        TH{CL,i} = temp;     
        Eq(i) = BET;
        continue
    end                    
    
    
    %BET
    if TH{CL,i} > RoundBet     
        
        BET = BET + 1;         
        if CL > 7
            temp2 = TH{CL-1,i};
            if temp2(1) == 3
                PR = temp2(5);
            else
                PR = temp2(6); %Previous Round Moneyz
            end
        elseif CL == 7
            if i == 1
                PR = SB;
            elseif i == 2
                PR = BB;
            else
                PR = TH{5,i};
            end                
        end
        
        temp(1) = 3;
        temp(2) = BET;
        
        if street == 1
            LastRaise = i;
            if BET == 2
                if Limpers == 0 && (i == 5 || i == 6 || i == 1)
                    temp(3) = 5;
                    SBet = 1;
                elseif Limpers == 1
                    temp(3) = 6;
                    IBet = 1;
                else
                    temp(3) = 4;
                end
            elseif BET == 3
                if i == 2 && SBet == 1
                    temp(3) = 5;
                else 
                    temp(3) = 7;
                end
                SBet = 0;
                IBet = 0;
            elseif ABet == 1
                temp(3) = 11;
            else                
                temp(3) = 4;
            end
        else
            if LastRaise == i && Round == 2
                temp(3) = 8;
                CBet = 1;
            elseif LastRaise == i && CBet == 3
                temp(3) = 8;
                CBet = 1;
            elseif CBet == 1 && BET == 2
                temp(3) = 10;
                CBet = 2;
            elseif ABet == 1
                temp(3) = 11;
            else
                temp(3) = 4;
            end
        end
        
        if ABet == 1;
            ABet = 0; 
        end
        if TH{2,i} == 0
            temp(4) = 1; 
            ABet = 1;
            AI(i) = 1;
        else
            temp(4) = 0;
        end
        temp(5) = TH{CL,i};
        temp(6) = RoundBet;
        temp(7) = POT;
        temp(8) = TH{2,i} + temp(5) - PR;            
        
        
        
        POT = POT + temp(5) - PR;
        TM(i) = TM(i) + temp(5) - PR;
        RoundBet = temp(5);
        TH{5,i} = RoundBet;
        TH{CL,i} = temp;  
        Eq(i) = BET;
    end
    
    
    %IS NOT EXECUTED IF CALLED/FOLDED/CHECKED!!!
    if PlayersIn(TH{1,i}) == 0 && IsIn(i) == 1
        IsIn(i) = 0;        
    end
end
HH(:,:,street) = TH;

%Catching any moneyz unaccounted for
if round(ActualPot,2) ~= round(POT,2)
%     disp('wrong pot count')
%     disp(['Calculated Pot : ',num2str(POT)]);
%     disp(['Scanned Pot : ',num2str(ActualPot)]);
    error = 1;
end
end