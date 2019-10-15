% function temp = PTpf(HH)

%variables
HH = gstemp;
gs = HH(:,:,1);
temp = zeros(1,8);
p = [3 4 5 6 1 2];
PTcheck = zeros(6,1);
ORt = [10 13 18 25 25 25]; %opening range - tight
ORa = [15 20 25 35 35 35]; %opening range - aggressive
PosBet = [3.5 3 3 2.5 2.5 2.5];

%Analysing input 'gs'
summary = gs{3,4};
MyCards = gs{3,1};
Cards = gs{4,1};

Limpers = summary{1,1};
BET = summary{2,1};
POT = summary{6,1};
RoundBet = summary{7,1};
Eq = summary{8,1};
CL = summary{12,1};
IsIn = summary{14,1};
AI = summary{15,1};

%New variables
AmIn = sum(IsIn) - 1; %Ammount of players In without Hero
CCp = WPm(Cards);

%Rotating variables to ease pre-flop analysis
gs = circshift(gs,[0 -2]);
Eq = circshift(Eq,[-2 0]);
AI = circshift(AI,[-2 0]);
IsIn = circshift(IsIn, [-2 0]);

%Hero
for i = 1:6
    if gs{1,i} == 1
        Hero = i;   
    end
end


%Checking if players have PT data
for i = 1:6
    if i == Hero || IsIn(i) == 0
        continue
    elseif size(gs{6,i},1) > 1
        PTcheck(i) = 1;
    end
end
AmPT = sum(PTcheck); %the sum of players for who we have the PT data
PTp = AmIn/AmPT; %percentage of people in with PT


%___________________________________________________________________________________________________________
                                %BRAKES NEED TO BE ADDED IF AmPT == 0 !!! 
%___________________________________________________________________________________________________________
                                                

%Differentiating the Players into classes
PP = zeros(6,3); %Player Profiles
PP2 = zeros(6,2);
for i = 1:6
    if gs{1,i} == 1 || gs{1,i} == 0 || IsIn(i) == 0
        continue
    end
    
    PP2(i,1) = gs{6,i}{2,1};
    PP2(i,2) = gs{6,i}{2,2};
    PT = gs{6,i};
    VPIP = PT{2,1};
    PFR = PT{2,2};
    factor = PFR/VPIP;
                
    if VPIP <= 12
        if factor >= 0.85
            %extrememely tight & extremely aggressive
            PP(i,1) = 1;
            PP(i,2) = 1;
        elseif factor >= 0.7
            %extremely tight & aggresive
            PP(i,1) = 1;
            PP(i,2) = 2;
        else
            %extremely tight and relatively passive
            PP(i,1) = 1;
            PP(i,2) = 3;
        end
    elseif VPIP <= 25
        if factor >= 0.85
            %Tight & extremely aggressive
            PP(i,1) = 2;
            PP(i,2) = 1;
        elseif factor >= 0.7
            %Tight & aggressive
            PP(i,1) = 2;
            PP(i,2) = 2;
        else
            %Tight & relatively passive
            PP(i,1) = 2;
            PP(i,2) = 3;
        end
    elseif VPIP <= 35
        if factor >= 0.85
            %Loose & extremely aggressive
            PP(i,1) = 3;
            PP(i,2) = 1;
        elseif factor >= 0.7
            %Loose & aggressive
            PP(i,1) = 3;
            PP(i,2) = 2;
        elseif factor >= 0.5
            %Loose & relatively passive
            PP(i,1) = 3;
            PP(i,2) = 3;
        else
            %Loose & passive
            PP(i,1) = 3;
            PP(i,2) = 4;
        end
    elseif VPIP <= 45
        if factor >= 0.5
            %extremely loose and aggressive
            PP(i,1) = 4;
            PP(i,2) = 3;
        else
            %extremely loose and passive
            PP(i,1) = 4;
            PP(i,2) = 4;
        end
    else
        %MANIAC! 
        PP(i,1) = 5;
        PP(i,2) = 3;
    end  
end


%first round
for i = 6:-1:1
    if all(PP2(i,:)==0)
        PP2(i,:) = [];
    end
end
AvgVPIP = mean(PP2(:,1));
AvgPFR  = mean(PP2(:,2));
factor = AvgPFR/AvgVPIP;

if round(AvgVPIP) >= 25
    if factor >= 0.75
        OR = ORt;
    else
        OR = ORa;
    end
else
    if factor >= 0.75
        OR = ORt;
    else
        OR = ORa;
    end
end


%____________________________________________________________________________________________________________________
                                        %Deciding the MOVE
quit = 0;
while quit == 0
    if BET == 1
        if Limpers > 0
            if Limpers == 1
                LimperStats = zeros(1,7);
                for i = 1:5
                    if IsIn(i) == 1
                        LimperStats(1,1) = gs{6,i}{7,p(i)}; %Limp in that position
                        LimperStats(1,2) = gs{6,i}{6,p(i)}; %OR in that position
                        LimperStats(1,3) = gs{6,i}{5,1}; %Limp overall
                        LimperStats(1,4) = gs{6,i}{2,5}; %Limp raise
                        LimperStats(1,5) = gs{6,i}{2,6}; %Limp call
                        LimperStats(1,6) = gs{6,i}{3,4}; %Flop Aggression Factor
                        LimperStats(1,7) = gs{6,i}{9,3}; %Fold to CBet
                        LimperPOS = i;
                        break
                    end
                end

                if Hero < 5 %considering ISO bet
                    
                else
                    
                    
                end




            else
                LimperStats = zeros(Limpers,7);
                j = 0;
                for i = 1:5
                    if IsIn == 1
                        j = j + 1;
                        LimperStats(j,1) = gs{6,i}{7,p(i)}; %Limp in that position
                        LimperStats(j,2) = gs{6,i}{6,p(i)}; %OR in that position
                        LimperStats(j,3) = gs{6,i}{5,1}; %Limp overall
                        LimperStats(j,4) = gs{6,i}{2,5}; %Limp raise
                        LimperStats(j,5) = gs{6,i}{2,6}; %Limp call
                        LimperStats(j,6) = gs{6,i}{3,4}; %Flop Aggression Factor
                        LimperStats(j,7) = gs{6,i}{9,3}; %Fold to CBet
                        if j == Limpers
                            break
                        end
                    end
                end
                

            end
            disp('limpers')
            quit = 1;
        else
            if OR(Position) >= CCp
                %make an opening raise
            end
            quit = 1;
        end    
            













    end
    quit = 1; 
end






















% end