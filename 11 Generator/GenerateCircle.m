%function = GenerateCircle(HMP)

HMP = 1000000; %How many plays
error = 0;
gs = cell(8,6);
Blinds = [0.5 1];
MoneySummary = zeros(1,6);
FinalSummary = cell(6,2);
FinalSummary(1:6,2) = {(zeros(13,13))};


%___________________________________________________________________________________________________________
                                                %FILLING NAMES
                                                
Hero = randi(6); % Gives a random position to the Hero
jump = Hero - 1;

for i = 1:6
    gs{1,i} = i - jump;
    if gs{1,i} < 1
        gs{1,i} = gs{1,i} + 6;
    end
end


%___________________________________________________________________________________________________________
                                               %FILLING PLAYERS
                                                
gs = FillInPT(gs,10000);
gs(2,:) = {Blinds(2)*100}; 

%___________________________________________________________________________________________________________
                                                  %THE BEAST



for run = 1:HMP  
    if rem(run,1000) == 0
        disp(run)
    end
    
    %Changing the players
    if rem(run,100000) == 0
        for j = 1:6
            if gs{1,j} == 1
                continue
            else
                FinalSummary(gs{1,j},1) = gs(6,j);
            end
        end
        FinalSummary{1,1} = MoneySummary;
        
%         %Saving this badboy
%         time = clock;
%         code = [num2str(time(4)), num2str(time(5)), num2str(uint8(time(5)*10000))];
%         FileName = ['D:\OneDrive\Poker\Europe\M Files\Listed\13 Development\CircleResults ',code,'.mat'];
%         save(FileName,'FinalSummary');
        
        %making a new matrix
        FinalSummary(1:6,2) = {(zeros(13,13))};
        gs(2,:) = {Blinds(2)*100};
        MoneySummary = zeros(1,6);
        
        %Replacing the players
        gs = FillInPT(gs,10000);
    end
        
    %CLEAN-UP
    gstemp = cell(8,6);
    gstemp(1:2,:) = gs(1:2,:);
    gstemp(6,:) = gs(6,:);
    gstemp(5,:) = {0};
    %circshift
    gs = gstemp;
    gs(:,1:5) = gstemp(:,2:6);
    gs(:,6) = gstemp(:,1);
    
    %CARDS
    AllCards = uint8([21 22 23 24 31 32 33 34 41 42 43 44 51 52 53 54 61 62 63 64 71 72 73 74 81 82 83 84 91 92 93 94 101 102 103 104 111 112 113 114 121 122 123 124 131 132 133 134 141 142 143 144]);
    for j = 1:2
        for k = 1:6
            DealtCard = AllCards(randi(size(AllCards,2)));
            AllCards = AllCards(AllCards ~= DealtCard);
            
            CH = gs{3,k};
            CH(1,j) = DealtCard;
            gs{3,k} = CH;
        end
    end
    
    for j = 1:6
        CHs = CtR(gs{3,j});
        gs{4,j} = CHs;
    end    
    
    %BLINDS
    gs{5,1} = Blinds(1);
    gs{2,1} = gs{2,1} - Blinds(1);

    gs{5,2} = Blinds(2);
    gs{2,2} = gs{2,2} - Blinds(2);
    
    
    %saving gs for development
    OriginalGS = gs;
    

    %TIME TO PLAY THE GAME!!!
    GenerateActionPreFlop;
%     if sum(IsIn) > 1 && sum(IsIn) ~= sum(AI)
%        GenerateActionPostFlop 
%     end
%     
    
    
    
    
    %Find out the winner
%     gs = EvaluateTable(gs,AllCards);
%     EvaluateTable;
%     FinalSummary = HandProfitability(gs, OriginalGS, FinalSummary);

    %Development stops
    if error == 1
        time = clock;
        code = [num2str(time(4)), num2str(time(5)), num2str(uint16(time(6)))];
        FileName = ['D:\OneDrive\Poker\Europe\M Files\Listed\12 Errors\GenerateCircle\GenerateAction',code,'.mat'];
        save(FileName,'OriginalGS');
        error = 0;
    end

    
    sum1 = 0; % before play
    sum2 = 0; % after play
    sum3 = sum(MoneySummary);
    
    %STACK-UP
    for j = 1:6
        if gs{2,j} <= 20*Blinds(2)
            MoneySummary(gs{1,j}) = MoneySummary(gs{1,j}) - Blinds(2)*100 + gs{2,j};
            gs{2,j} = Blinds(2)*100;
        elseif gs{2,j} >= 200*Blinds(2)
            MoneySummary(gs{1,j}) = MoneySummary(gs{1,j}) - Blinds(2)*100 + gs{2,j};
            gs{2,j} = Blinds(2)*100;
        end
        
        %fault finding 
        sum1 = sum1 + OriginalGS{2,j};
        sum2 = sum2 + gs{2,j};
    end
    
    difference = (sum2 + sum(MoneySummary)) - (sum1 + sum3);
    if difference > Blinds(2)
        break
    end
end
