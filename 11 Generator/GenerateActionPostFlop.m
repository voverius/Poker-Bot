% function [HH, error] = GenerateActionPostFlop(gs,version)
version = 1;


%_____________________________________________
%Creating a new HH from gs for further streets
for i = 1:size(gs,2)
    if gs{1,i,1} == 1
        Hero = i;
        break
    end
end

HH = cell(size(gs,1),size(gs,2),4);
HH(2,:,2) = gs(2,:);
HH(2,:,3:4) = {0};
HH(5,:,:) = {0};
HH(:,:,1) = gs;

for i = 2:4
   HH(1,:,i) = gs(1,:); 
end



%___________________________________________________________________________________________________________
                                                 %GAME VARIABLES

                                                 
summary = HH{6,i,1};
POT = summary{6};
IsIn = summary{14};
AI = summary{15};

CL = 7;
AIp = 0;
CBet = 0;
street = 2;
LastStreet = 1;
TM = zeros(6,1); %Total moneyz up-front
temp = zeros(1,8);
Eq = uint8(zeros(6,1));
%CC - matrix stores card percentile values


%Dealing the cards
BurntCard = AllCards(randi(size(AllCards,2)));
AllCards = AllCards(AllCards ~= BurntCard);
Board = uint8(zeros(3,1));
for i = 1:3
    Board(i) = AllCards(randi(size(AllCards,2)));
    AllCards = AllCards(AllCards ~= Board(i));
end


%___________________________________________________________________________________________________________
                                                   %GAME TIME


QuitLoop = 0;
while QuitLoop == 0
    for i = 1:6
        %skipping players who can't take action
        if IsIn(i) == 0
            continue    
        elseif  AI(i) == 1
            continue
        end     

        
        %New CurrentLine
        if size(HH{CL,i,street},2) == 8
            CL = CL + 1;
            HH{CL,i,street} = [];
        end

        
        %Check Status'
        if any(AI == 1)
            if sum(AI) == sum(IsIn) - 1
                AIp = 1;
            end
        end

        
        %Checking if player is in position
        if summary{11,1} == 0 && Hero ~= 6
            if sum(IsIn((Hero + 1):6)) == 0
                summary{11,1} = 1;
            end
        end        

%______________________________________________________________________________________________________________            
                                              %HERO





                                              
                                              



%______________________________________________________________________________________________________________            
                                             %ACTION      
























    end
    
    
    %Checking if betting equilibrium has been reached
    if all(Eq(logical(IsIn)) == max(Eq)) %add contingency if someone's all in
        LastStreet = street;
        if street == 4
            %The game has finished
            summary{2,1}  = BET;
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
            
            HH{6,Hero,1} = summary;
            quit = 1;            
            break
        else
            %moving on to the next street
            CL = 7;
            TM = zeros(6,1); 
            
            if CBet == 1;
                CBet = 3;
            elseif CBet == 2;
                CBet = 3;    
            elseif CBet == 3;
                CBet = 0;
            end     
            
            if ABet == 1;
                ABet = 0; 
            end
            
            Board(street+2) = AllCards(randi(size(AllCards,2)));
            AllCards = AllCards(AllCards ~= Board(street+2));
        end      
        street = street + 1;
    end
end

disp(HH);
% end