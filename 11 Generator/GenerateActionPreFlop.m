% function [gs, error] = GenerateActionPreFlop(gs,version)
version = 2;

for i = 1:size(gs,2)
    if gs{1,i,1} == 1
        Hero = i;
    end
end

Blinds(1) = gs{5,1};
Blinds(2) = gs{5,2};

%___________________________________________________________________________________________________________
                                                 %GAME VARIABLES
                                                                                        
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

Limpers = 0;
BET = 1;
SBet = 0;
IBet = 0;
CBet = 0;
ABet = 0;
POT = sum(Blinds);
RoundBet = Blinds(2);
Eq = uint8(zeros(6,1));
LastRaise = 0;
TM = zeros(6,1);
AI = uint8(zeros(6,1));
IsIn = uint8(ones(6,1));
CL = 7;
LastStreet = 1;
AIp = 0;
street = 1;
itteration = 0;
temp = zeros(1,8);
CC = zeros(6,1);

TM(1) = gs{5,1};
TM(2) = gs{5,2};

for i = 1:6
    CC(i) = WPmV2(gs{3,i});
end

quit = 0;
while quit == 0
    for i = 1:6
        
        %skipping the blinds
        if itteration == 0
            if i == 3
                itteration = 1;
            else
                continue
            end
        end
        
        %skipping players who can't take action
        if Eq(i) == BET || (i == 2 && BET == 1 && all(Eq == 0))
            %uncalled bet
            if any(AI == 1)
                if sum(TM == max(TM)) == 1
                    maxValue = max(TM);
                    medValue = max(TM(TM<max(TM)));
                    maxPos = find(TM == maxValue);
                    
                    TM(maxPos) = medValue;
                    gs{5,maxPos} = medValue;
                    gs{2,maxPos} = gs{2,maxPos} - medValue + maxValue;
                    POT = POT - maxValue + medValue;
                end
            end
            
            
            %saving the summary variable
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
            summary{13,1} = LastStreet;
            summary{14,1} = IsIn;
            summary{15,1} = AI;
            summary{16,1} = TM;
            
            gs{6,Hero} = summary;
            quit = 1;
            break
        elseif IsIn(i) == 0
            continue    
        elseif  AI(i) == 1
            continue
        end     
        
        %new current line
        if size(gs{CL,i},2) == 8
            CL = CL + 1;
            gs{CL,i} = [];
        end
        
        %Check Status'
        if any(AI == 1)
            if sum(AI) == sum(IsIn) - 1
                AIp = 1;
            end
        end

        %checking if player is in position
        if summary{11,1} == 0 && Hero ~= 6
            if sum(IsIn((Hero + 1):6)) == 0
                summary{11,1} = 1;
            end
        end
        
%______________________________________________________________________________________________________________           
%______________________________________________________________________________________________________________            
                                              %HERO
        
        if Hero == i
            gstemp = gs;
            gstemp(3:4,:) = {[]};
            gstemp(3:4,1) = gs(3:4,Hero);
            gstemp{3,2} = POT;
            gstemp{3,3} = Blinds;
            gstemp{4,4} = zeros(6,1);
            for j = 1:6
                if IsIn(j) == 1
                    gstemp{4,4}(gs{1,j}) = 1;
                end
            end
            
            if version == 1
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
                summary{13,1} = LastStreet;
                summary{14,1} = IsIn;
                summary{15,1} = AI;
                summary{16,1} = TM;
                gstemp{3,4} = summary;
                
                temp = GpfV2(gstemp);
            elseif version == 2
                if CL > 7
%                     gstemp{CL-1,Hero} = gs{5,Hero};
                    gstemp{3,4} = TempSummary;
                    gstemp(5,:) = TempMoneyz;
                else
                    gstemp{3,4} = 0;
                    gstemp{4,3} = ones(6,1);
                    gstemp(5,:) = {0};
                    gstemp{5,1} = Blinds(1);
                    gstemp{5,2} = Blinds(2);
                    if i ~= 2
                        gstemp{7,1} = Blinds(1);
                    end
                    gstemp{7,2} = Blinds(2);
                end
                MR = gstemp; %to review ModifyRandom input
                gstemp = ModifyRandomPreFlop(gstemp);
                FH = gstemp; %to review FillHH input
                [gstemp,error] = FillHH(gstemp,street);
                TempSummary = gstemp{3,4};
                TempMoneyz = gstemp(5,:);
                
                
%                 if i == 2 && IsIn(1) == 1 && BET > 2
%                     quit = 1;
%                     error = 1;
%                     break
%                 end

                temp = GpfV2(gstemp);
                
                
                %temporary for development
%                 PTpf;
%                 error = 1;
%                 quit = 1;
%                 break
               
                
                
                SizeGStemp = size(gstemp,1);
                SizeGS = size(gs,1);
                
                if SizeGStemp > SizeGS
                    gs{SizeGStemp,1} = [];
                end

                %for FillHH development
                for j = 1:6
                    try
                        if all(gs{CL,j} == gstemp{CL,j})
                            %do nothing
                        else
                            disp('gs is different to FillHH (tried)');
                            quit = 1;
                            error = 1;
                            disp(gs{CL,j});
                            disp(gstemp{CL,j});
                            break
                        end
                    catch
                        disp('gs is different to FillHH (caught)');
                        quit = 1;
                        error = 1;
                        disp(gs{CL,j});
                        disp(gstemp{CL,j});
                    end
                end
                if quit == 1
                    break
                end
            end
            
            
            %FOLD
            if temp(1) == 1
                IsIn(i) = 0;
                
            %CALL    
            elseif temp(1) == 2
                gs{2,i} = gs{2,i} - temp(5); %#ok<*SAGROW> %Stack
                TM(i) = TM(i) + temp(5);
                POT = POT + temp(5);
                if temp(4) == 1
                    AI(i) = 1;
                    gs{5,i} = gs{5,i} + temp(5);
                else
                    gs{5,i} = RoundBet; %Money In Front
                end
                Eq(i) = BET;
                
                if street == 1
                    if BET == 1 && temp(3) < 4
                        Limpers = Limpers + 1;
                    elseif BET == 2
                        if temp(3) == 4
                            SBet = 0;
                            IBet = 0;
                        end
                    end
                end
                    
            %BET    
            elseif temp(1) == 3
                if ABet == 1
                    ABet = 0;
                end
                RoundBet = temp(5);
                gs{2,i} = gs{2,i} - RoundBet + gs{5,i}; %Stack
                POT = POT + RoundBet - gs{5,i};
                TM(i) = TM(i) + RoundBet - gs{5,i};
                gs{5,i} = RoundBet; %Money In Front
                BET = BET + 1;
                Eq(i) = BET;
                LastRaise = i;
                
                if street == 1 && BET == 2
                    if temp(3) == 5
                        SBet = 1;
                    elseif temp(3) == 6
                        IBet = 1;
                    end
                else
                    SBet = 0;
                    IBet = 0;
                end
                if temp(4) == 1
                    AI(i) = 1;
                    ABet = 1;
                end
                
            %CHECK    
            elseif temp(1) == 4
                gs{5,i} = RoundBet; %Money In Front
                Eq(i) = BET;
                
            %ERROR    
            else
                error = 1;
                disp('GpfV2 Output Wrong');
                disp(temp);
            end
                           
            gs{CL,Hero} = temp;
            continue
        end                                  
%______________________________________________________________________________________________________________            
                                             %ACTION            
                                             
        %Before we start to fill in the action
        PT = gs{6,i};
        CCp = CC(i);

        
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



            
        if BET == 1
%______________________________________________________________________________________________________________            
                                             %1 Limper               
            if Limpers == 0

                %STEAL BET
                if PT{2,3} > CCp && (i >= 5 || i == 1)
                    temp(1) = 3;
                    temp(2) = 2;
                    temp(3) = 5;
                    temp(4) = 0;
                    temp(5) = 3*RoundBet;
                    temp(6) = RoundBet;
                    temp(7) = POT;
                    temp(8) = gs{2,i,street};
                    gs{CL,i} = temp;

                    RoundBet = temp(5);
                    gs{2,i} = gs{2,i} - RoundBet + gs{5,i}; %Stack
                    POT = POT + RoundBet - gs{5,i};
                    TM(i) = TM(i) + RoundBet - gs{5,i};
                    gs{5,i} = RoundBet; %Money In Front
                    BET = BET + 1;
                    Eq(i) = BET;
                    SBet = 1;
                    LastRaise = i;
                    continue

                %2BET    
                elseif PT{6,i} > CCp
                    temp(1) = 3;
                    temp(2) = 2;
                    if (i >= 5 || i == 1)
                        temp(3) = 5;
                    else
                        temp(3) = 4;
                    end
                    temp(4) = 0;
                    temp(5) = 3*RoundBet;
                    temp(6) = RoundBet;
                    temp(7) = POT;
                    temp(8) = gs{2,i,street};
                    gs{CL,i} = temp;

                    RoundBet = temp(5);
                    gs{2,i} = gs{2,i} - RoundBet + gs{5,i}; %Stack
                    POT = POT + RoundBet - gs{5,i};
                    TM(i) = TM(i) + RoundBet - gs{5,i};
                    gs{5,i} = RoundBet; %Money In Front
                    BET = BET + 1;
                    Eq(i) = BET;
                    LastRaise = i;
                    continue                        

                %Open Limp
                elseif (PT{6,i} + PT{7,i}) > CCp 
                    temp(1) = 2;
                    temp(2) = 1;
                    temp(3) = 1;
                    temp(4) = 0;
                    temp(5) = RoundBet - gs{5,i};
                    temp(6) = RoundBet;
                    temp(7) = POT;
                    temp(8) = gs{2,i,street};
                    gs{CL,i} = temp;

                    gs{2,i} = gs{2,i} - temp(5); %Stack
                    TM(i) = TM(i) + temp(5);
                    POT = POT + temp(5);
                    gs{5,i} = RoundBet; %Money In Front
                    Limpers = Limpers + 1;
                    Eq(i) = BET;
                    continue

                %Open Fold    
                else
                    temp(1) = 1;
                    temp(2) = 1;
                    temp(3) = 1;
                    temp(4) = 0;
                    temp(5) = RoundBet - gs{5,i};
                    temp(6) = RoundBet;
                    temp(7) = POT;
                    temp(8) = gs{2,i,street};
                    gs{CL,i} = temp;

                    IsIn(i) = 0;
                end

%______________________________________________________________________________________________________________            
                                             %2 Limpers                        
            elseif Limpers == 1

                %ISOLATION BET
                if PT{5,3} > CCp
                    temp(1) = 3;
                    temp(2) = 2;
                    temp(3) = 6;
                    temp(4) = 0;
                    temp(5) = 3*RoundBet;
                    temp(6) = RoundBet;
                    temp(7) = POT;
                    temp(8) = gs{2,i,street};
                    gs{CL,i} = temp;

                    RoundBet = temp(5);
                    gs{2,i} = gs{2,i} - RoundBet + gs{5,i}; %Stack
                    TM(i) = TM(i) + RoundBet - gs{5,i};
                    POT = POT + RoundBet - gs{5,i};
                    gs{5,i} = RoundBet; %Money In Front
                    BET = BET + 1;
                    Eq(i) = BET;
                    IBet = 1;
                    LastRaise = i;
                    continue

                %Limp with posibility to ISO
                elseif (PT{6,i} + PT{7,i}) > CCp
                    if gs{5,i} == RoundBet %BB check
                        temp(1) = 4;
                        temp(5) = RoundBet;
                        temp(7) = POT;
                        temp(8) = gs{2,i,street};
                    else
                        temp(1) = 2; %Limp
                        temp(5) = RoundBet - gs{5,i};
                        temp(7) = POT;
                        temp(8) = gs{2,i,street};
                        gs{2,i} = gs{2,i} - temp(5); %Stack
                        POT = POT + temp(5);
                    end
                    temp(2) = 1;
                    temp(3) = 2;
                    temp(4) = 0;
                    temp(6) = RoundBet;
                    gs{CL,i} = temp;

                    gs{5,i} = RoundBet; %Money In Front
                    TM(i) = TM(i) + temp(5);
                    Limpers = Limpers + 1;
                    Eq(i) = BET;
                    continue

                %Open Fold    
                else
                    temp(1) = 1;
                    temp(2) = 1;
                    temp(3) = 2;
                    temp(4) = 0;
                    temp(5) = RoundBet - gs{5,i};
                    temp(6) = RoundBet;
                    temp(7) = POT;
                    temp(8) = gs{2,i,street};
                    gs{CL,i} = temp;

                    IsIn(i) = 0;
                    continue
                end

%______________________________________________________________________________________________________________            
                                             %More Limpers                
            else 
                %2BET
                if PT{6,i} > CCp
                    temp(1) = 3;
                    temp(2) = 2;
                    temp(3) = 4;
                    temp(4) = 0;
                    temp(5) = 3*RoundBet;
                    temp(6) = RoundBet;
                    temp(7) = POT;
                    temp(8) = gs{2,i,street};
                    gs{CL,i} = temp;

                    RoundBet = temp(5);
                    gs{2,i} = gs{2,i} - RoundBet + gs{5,i}; %Stack
                    TM(i) = TM(i) + RoundBet - gs{5,i};
                    POT = POT + RoundBet - gs{5,i};
                    gs{5,i} = RoundBet; %Money In Front
                    BET = BET + 1;
                    Eq(i) = BET;
                    LastRaise = i;
                    continue                        

                %Limp with 2 or more limpers behind
                elseif (PT{6,i} + PT{7,i}) > CCp
                    if gs{5,i} == Blinds(2)
                        temp(1) = 4;
                        temp(5) = RoundBet;
                        temp(7) = POT;
                        temp(8) = gs{2,i,street};
                    else
                        temp(1) = 2;
                        temp(5) = RoundBet - gs{5,i};
                        temp(7) = POT;
                        temp(8) = gs{2,i,street};
                        gs{2,i} = gs{2,i} - temp(5); %Stack
                        POT = POT + temp(5);
                    end
                    temp(2) = 1;
                    temp(3) = 3;
                    temp(4) = 0;
                    temp(6) = RoundBet;
                    gs{CL,i} = temp;

                    gs{5,i} = RoundBet; %Money In Front
                    TM(i) = TM(i) + temp(5);
                    Limpers = Limpers + 1;
                    Eq(i) = BET;

                %Open Fold    
                else
                    temp(1) = 1;
                    temp(2) = 1;
                    temp(3) = 3;
                    temp(4) = 0;
                    temp(5) = RoundBet - gs{5,i};
                    temp(6) = RoundBet;
                    temp(7) = POT;
                    temp(8) = gs{2,i,street};
                    gs{CL,i} = temp;

                    IsIn(i) = 0;
                end
            end
%______________________________________________________________________________________________________________            
                                             %BET == 2                 
        elseif BET == 2
            %Steal Reraise
            if i == 2 && SBet == 1 && (PT{3,1} > CCp || PT{4,2} >= CCp)
                    temp(1) = 3;
                    temp(2) = 3;
                    temp(3) = 9;
                    temp(4) = 0;
                    temp(5) = 3*RoundBet;
                    temp(6) = RoundBet;
                    temp(7) = POT;
                    temp(8) = gs{2,i,street};
                    gs{CL,i} = temp;

                    RoundBet = temp(5);
                    gs{2,i} = gs{2,i} - RoundBet + gs{5,i}; %Stack
                    TM(i) = TM(i) + RoundBet - gs{5,i};
                    POT = POT + RoundBet - gs{5,i};
                    gs{5,i} = RoundBet; %Money In Front
                    BET = BET + 1;
                    Eq(i) = BET;
                    LastRaise = i;
                    SBet = 0;
                    continue
            %3BET        
            elseif PT{3,1} >= CCp ||... 
               (CL > 7 && gs{7,i}(3) < 4 && ((PT{6,i}+PT{7,i})*(PT{2,5}/100)) >= CCp) 
                    temp(1) = 3;
                    temp(2) = 3;
                    temp(3) = 7;
                    temp(4) = 0;
                    temp(5) = 3*RoundBet;
                    temp(6) = RoundBet;
                    temp(7) = POT;
                    temp(8) = gs{2,i,street};
                    gs{CL,i} = temp;

                    RoundBet = temp(5);
                    gs{2,i} = gs{2,i} - RoundBet + gs{5,i}; %Stack
                    TM(i) = TM(i) + RoundBet - gs{5,i};
                    POT = POT + RoundBet - gs{5,i};
                    gs{5,i} = RoundBet; %Money In Front
                    BET = BET + 1;
                    Eq(i) = BET;
                    LastRaise = i;
                    SBet = 0;
                    IBet = 0;
                    continue
            end

            if CL == 7
                %STEAL CALL
                if SBet == 1 && i == 2 && ((100 - PT{2,4}) >= CCp || (PT{3,1} + PT{8,i}) >= CCp)

                    temp(1) = 2;
                    temp(2) = 2;
                    temp(3) = 5;
                    temp(4) = 0;
                    temp(5) = RoundBet - gs{5,i};
                    temp(6) = RoundBet;
                    temp(7) = POT;
                    temp(8) = gs{2,i,street};
                    gs{CL,i} = temp;

                    gs{2,i} = gs{2,i} - temp(5); %Stack
                    TM(i) = TM(i) + temp(5);
                    POT = POT + temp(5);
                    gs{5,i} = RoundBet; %Money In Front
                    Eq(i) = BET;
                    SBet = 0;
                    continue
                %2CALL    
                elseif (PT{3,1} + PT{8,i}) >= CCp %|| PT{5,2} >= CCp
                    temp(1) = 2;
                    temp(2) = 2;
                    temp(3) = 4;
                    temp(4) = 0;
                    temp(5) = RoundBet - gs{5,i};
                    temp(6) = RoundBet;
                    temp(7) = POT;
                    temp(8) = gs{2,i,street};
                    gs{CL,i} = temp;

                    gs{2,i} = gs{2,i} - temp(5); %Stack
                    TM(i) = TM(i) + temp(5);
                    POT = POT + temp(5);
                    gs{5,i} = RoundBet; %Money In Front
                    Eq(i) = BET;
                    SBet = 0;
                    IBet = 0;
                    continue
                %Steal Fold    
                elseif SBet == 1 && i == 2
                    temp(1) = 1;
                    temp(2) = 2;
                    temp(3) = 5;
                    temp(4) = 0;
                    temp(5) = RoundBet - gs{5,i};
                    temp(6) = RoundBet;
                    temp(7) = POT;
                    temp(8) = gs{2,i,street};
                    gs{CL,i} = temp;

                    IsIn(i) = 0;
                %2Fold    
                else
                    temp(1) = 1;
                    temp(2) = 2;
                    temp(3) = 4;
                    temp(4) = 0;
                    temp(5) = RoundBet - gs{5,i};
                    temp(6) = RoundBet;
                    temp(7) = POT;
                    temp(8) = gs{2,i,street};
                    gs{CL,i} = temp;

                    IsIn(i) = 0;
                end

            %Second Round Of Action    
            else
                %Isolation Call
                if gs{7,i}(1) == 2 && gs{7,i}(3) < 4 && ((PT{6,i} + PT{7,i})*(PT{2,6}/100)) >= CCp
                    temp(1) = 2;
                    temp(2) = 2;
                    if IBet == 1 && gs{7,i}(3) == 2
                        temp(3) = 6;
                    else
                        temp(3) = 4;
                    end
                    temp(4) = 0;
                    temp(5) = RoundBet - gs{5,i};
                    temp(6) = RoundBet;
                    temp(7) = POT;
                    temp(8) = gs{2,i,street};
                    gs{CL,i} = temp;

                    gs{2,i} = gs{2,i} - temp(5); %Stack
                    TM(i) = TM(i) + temp(5);
                    POT = POT + temp(5);
                    gs{5,i} = RoundBet; %Money In Front
                    Eq(i) = BET;
                    IBet = 0;
                    continue
                %2 Call    
                elseif (PT{3,1} + PT{4,1}) > CCp || PT{5,2} >= CCp
                    temp(1) = 2;
                    temp(2) = 2;
                    temp(3) = 4;
                    temp(4) = 0;
                    temp(5) = RoundBet - gs{5,i};
                    temp(6) = RoundBet;
                    temp(7) = POT;
                    temp(8) = gs{2,i,street};
                    gs{CL,i} = temp;

                    gs{2,i} = gs{2,i} - temp(5); %Stack
                    TM(i) = TM(i) + temp(5);
                    POT = POT + temp(5);
                    gs{5,i} = RoundBet; %Money In Front
                    Eq(i) = BET;
                    SBet = 0;
                    IBet = 0;
                    continue  
                %Isolation Fold    
                elseif IBet == 1 && gs{7,i}(1) == 2 && gs{7,i}(3) == 2
                    temp(1) = 1;
                    temp(2) = 2;
                    temp(3) = 6;
                    temp(4) = 0;
                    temp(5) = RoundBet - gs{5,i};
                    temp(6) = RoundBet;
                    temp(7) = POT;
                    temp(8) = gs{2,i,street};
                    gs{CL,i} = temp;

                    IsIn(i) = 0;
                %2Fold    
                else
                    temp(1) = 1;
                    temp(2) = 2;
                    temp(3) = 4;
                    temp(4) = 0;
                    temp(5) = RoundBet - gs{5,i};
                    temp(6) = RoundBet;
                    temp(7) = POT;
                    temp(8) = gs{2,i,street};
                    gs{CL,i} = temp;

                    IsIn(i) = 0;                        
                end
            end

%______________________________________________________________________________________________________________            
                                             %BET == 3                     
        elseif BET == 3
            %4BET
            if AIp == 0 && (PT{2,2}*(PT{4,4}/100) >= CCp || (PT{3,1} / 2) >= CCp) %Special case - 4BET with half 3BET range
                temp(1) = 3;
                temp(2) = 4;
                if ABet == 1
                    temp(3) = 11;
                else
                    temp(3) = 4;
                end                   
                if ABet == 1
                    ABet = 0;
                end                      
                if POT >= gs{2,i}*0.8 || 3*RoundBet >= 0.8*gs{2,i}
                    temp(4) = 1;
                    temp(5) = gs{2,i} + gs{5,i};
                    ABet = 1;
                    AI(i) = 1;
                else
                    temp(4) = 0;
                    temp(5) = 3*RoundBet;
                end
                temp(6) = RoundBet;
                temp(7) = POT;
                temp(8) = gs{2,i,street};
                gs{CL,i} = temp;

                RoundBet = temp(5);
                gs{2,i} = gs{2,i} - RoundBet + gs{5,i}; %Stack
                TM(i) = TM(i) + RoundBet - gs{5,i};
                POT = POT + RoundBet - gs{5,i};
                gs{5,i} = RoundBet; %Money In Front
                BET = BET + 1;
                Eq(i) = BET;
                LastRaise = i;                  
                continue   

            %3Bet Call        
            elseif PT{5,2}*((100 - PT{4,3})/100) > CCp || PT{3,1} >= CCp
                temp(1) = 2;
                temp(2) = 3;
                if CL > 7 && gs{(CL-1),i}(1) == 3
                    temp(3) = 7;
                else
                    temp(3) = 4;
                end
                temp(4) = 0;
                temp(5) = RoundBet - gs{5,i};
                temp(6) = RoundBet;
                temp(7) = POT;
                temp(8) = gs{2,i,street};
                gs{CL,i} = temp;

                gs{2,i} = gs{2,i} - temp(5); %Stack
                TM(i) = TM(i) + temp(5);
                POT = POT + temp(5);
                gs{5,i} = RoundBet; %Money In Front
                Eq(i) = BET;
                continue       
            elseif CL > 7 && gs{(CL-1),i}(1) == 3 && PT{5,2}*((100 - PT{3,2})/100) >= CCp
                temp(1) = 2;
                temp(2) = 3;
                temp(3) = 7;
                temp(4) = 0;
                temp(5) = RoundBet - gs{5,i};
                temp(6) = RoundBet;
                temp(7) = POT;
                temp(8) = gs{2,i,street};
                gs{CL,i} = temp;

                gs{2,i} = gs{2,i} - temp(5); %Stack
                TM(i) = TM(i) + temp(5);
                POT = POT + temp(5);
                gs{5,i} = RoundBet; %Money In Front
                Eq(i) = BET;
                continue  
            elseif CL > 7 && gs{(CL-1),i}(1) == 2 &&...
                   (PT{5,1}*((100-PT{5,5})/100) >=CCp || PT{5,2}*((100-PT{5,5})/100))  %#ok<BDLOG>
                temp(1) = 2;
                temp(2) = 3;
                temp(3) = 4;
                temp(4) = 0;
                temp(5) = RoundBet - gs{5,i};
                temp(6) = RoundBet;
                temp(7) = POT;
                temp(8) = gs{2,i,street};
                gs{CL,i} = temp;

                gs{2,i} = gs{2,i} - temp(5); %Stack
                TM(i) = TM(i) + temp(5);
                POT = POT + temp(5);
                gs{5,i} = RoundBet; %Money In Front
                Eq(i) = BET;
                continue
            %3Bet Folds
            else
                temp(1) = 1;
                temp(2) = 3;
                if CL > 7 && gs{(CL-1),i}(1) == 3
                    if gs{(CL-1),i}(3) == 5
                        temp(3) = 5;
                    else
                        temp(3) = 7;
                    end
                else
                    temp(3) = 4;
                end
                temp(4) = 0;
                temp(5) = RoundBet - gs{5,i};
                temp(6) = RoundBet;
                temp(7) = POT;
                temp(8) = gs{2,i,street};
                gs{CL,i} = temp;

                IsIn(i) = 0;                   
            end
%______________________________________________________________________________________________________________            
                                             %Further Bets                    
        else
            %4+ Bet
            if AIp == 0 && RoundBet < gs{2,i} + gs{5,i} && ((PT{3,1}*((100 - PT{4,6})/100)) > CCp ||...
               (PT{3,1} / 2) >= CCp) %Last one is for 4BET range 

                BET = BET + 1;         
                temp(1) = 3;
                temp(2) = BET;
                if ABet == 1
                    temp(3) = 11;
                else
                    temp(3) = 4;
                end                    
                if ABet == 1
                    ABet = 0;
                end
                if POT >= gs{2,i}*0.8 || 3*RoundBet >= 0.8*gs{2,i}
                    temp(4) = 1;
                    temp(5) = gs{2,i} + gs{5,i};
                    ABet = 1;
                    AI(i) = 1;
                else
                    temp(4) = 0;
                    temp(5) = 2.5*RoundBet;
                end

                temp(6) = RoundBet;
                temp(7) = POT;
                temp(8) = gs{2,i,street};
                gs{CL,i} = temp;

                RoundBet = temp(5);
                gs{2,i} = gs{2,i} - RoundBet + gs{5,i}; %Stack
                TM(i) = TM(i) + RoundBet - gs{5,i};
                POT = POT + RoundBet - gs{5,i};
                gs{5,i} = RoundBet; %Money In Front
                Eq(i) = BET;
                LastRaise = i;

                continue

            %4+ Call    
            elseif (PT{3,1}*((100 - PT{4,6})/100)) > CCp || (PT{3,1} / 2) >= CCp %Last one is for 4BET range 
                if RoundBet >= gs{2,i} + gs{5,i}
                    temp(4) = 1;
                    temp(5) = gs{2,i};
                    AI(i) = 1;
                else
                    temp(4) = 0;
                    temp(5) = RoundBet - gs{5,i};
                end
                temp(1) = 2;
                temp(2) = BET;
                if CL > 7 && ABet == 1
                    temp(3) = 11;
                else
                    temp(3) = 4;
                end
                temp(6) = RoundBet;
                temp(7) = POT;
                temp(8) = gs{2,i,street};
                gs{CL,i} = temp;

                gs{2,i} = gs{2,i} - temp(5); %Stack
                TM(i) = TM(i) + temp(5);
                POT = POT + temp(5);
                gs{5,i} = gs{5,i} + temp(5); %Money In Front
                Eq(i) = BET;
                continue                    
            else
                temp(1) = 1;
                temp(2) = BET;
                if ABet == 1 && CL > 7
                    temp(3) = 11;
                else
                    temp(3) = 4;
                end
                temp(4) = 0;
                temp(5) = RoundBet - gs{5,i};
                temp(6) = RoundBet;
                temp(7) = POT;
                temp(8) = gs{2,i,street};
                gs{CL,i} = temp;

                IsIn(i) = 0;                      
                continue
            end
        end
    end
end
% end