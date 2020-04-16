
%_______________________________ MAIN VARIABLES _____________________________________

Players = 6; %This will have to addapt to actual table size
HH = cell(6,Players,4); %Game cube!!!
PlayersTemp = cell(2,Players*2); %This is for sorting out the main cube
PlayersIn = cell(2,Players); %Matrix showing the players still in the game and their position
for a=1:Players
    PlayersIn{2,a} = a;
end     %Fills players positions



%___________________________________ BUTTON _________________________________________

Row = Text{CurrentLine};    %2nd Line to see what position the button is at
HashTag = strfind(Row, '#') + 1;   %Finding the hashtag next to the number
ButtonPosition = sscanf(Row(HashTag),'%f');
CurrentLine = CurrentLine + 1;



%__________________________________ POSITIONS _______________________________________

for a = 1:Players
    Row = Text{CurrentLine};                     
    if strcmp(' ',Row(size(Row,2))) == 1 %in case there's a space at the end of the line
        Row(size(Row,2)) = '';
    end
    
    if strfind(Row, 'Seat') == 1;
        spaces = strfind(Row, ' ');
        spacesSize = size(spaces);
        Name = Row((spaces(2)+ 1):(spaces((spacesSize(2)-2))-1));
        PlayersTemp(1,a) = {Name};
        PlayersTemp(1,a+Players) = {Name};
        Name = Row((spaces(size(spaces,2)-2)+3):(spaces(size(spaces,2)-1)-1));
        Name = sscanf(Name,'%f');
        PlayersTemp(2,a) = {Name};
        PlayersTemp(2,a+Players) = {Name};
        CurrentLine = CurrentLine + 1;
    else
        break
    end
end
    
    

%___________________________________ BLINDS _________________________________________

SB = 0;
BB = 0;
SBin = 0;
IsIn = zeros(6,1); % (1/0) depending if the player's in

for CurrentLine = CurrentLine:size(Text,1)
    Row = Text{CurrentLine};
    
    %SMALL BLIND
    if strfind(Row,': posts small b') > 0
        SBin = 1;
        for b = 1:Players
            if strfind(Row,PlayersTemp{1,b}) > 0
                if SB == 0
                    spaces = strfind(Row, ' ');
                    Name = Row((spaces(size(spaces,2))+2):end);
                    SB = sscanf(Name,'%f');
                end
                PlayersTemp(:,b+Players:size(PlayersTemp,2)) = [];
                PlayersTemp(:,1:b-1) = [];
                HH(1,1,1:4) = PlayersTemp(1,1);
                HH(2,1,1:4) = PlayersTemp(2,1);
                PlayersTemp(:,1) = [];
                IsIn(1) = 1;
                break
            end
        end
        CurrentLine = CurrentLine + 1; %#ok<FXSET>
        Row = Text{CurrentLine};
    end

    
    %BIG BLIND
    TEMP = strfind(Row,': posts big blind ');
    if TEMP > 0
        if BB == 0
            spaces = strfind(Row, ' ');
            if spaces(size(spaces,2)) <= TEMP + 19
                Name = Row((spaces(size(spaces,2))+2):end);
            else
                spaces = spaces(spaces >= TEMP + 19);
                Name = Row((TEMP+19):(spaces(1) - 1));
            end
            BB = sscanf(Name,'%f');
            for b = 1:size(PlayersTemp,2)
                if ~isempty(PlayersTemp{1,b})
                    PlayersTemp(:,1:b-1) = [];
                    HH(1,2,1:4) = PlayersTemp(1,1);
                    HH(2,2,1:4) = PlayersTemp(2,1);
                    PlayersTemp(:,1) = [];
                    IsIn(2) = 1;
                    break
                end
            end
        end
        break
    end   
end


%__________________________________ OTHER PLAYERS ______________________________________

 
flag = Players;
for a = size(PlayersTemp,2):-1:1
    if isnumeric(PlayersTemp{1,a}) == 1
        PlayersTemp(:,a) = [];
        continue
    else
        HH(1,flag,1:4) = PlayersTemp(1,a);
        HH(2,flag,1:4) = PlayersTemp(2,a); 
        IsIn(flag) = 1;
        flag = flag - 1;
    end    
end
   
HH(3,1:6,1:4) = {0};
PlayersIn(1,1:6) = HH(1,1:6);
for a = 6:-1:1
    if isempty(PlayersIn{1,a}) == 1
        PlayersIn(:,a) = [];
    end
end
    

%Working out how many players are in for rake purposes
if size(GameRakeMatrix,2) == 1 && GameRakeMatrix == 0
   for b = 1:size(Rakes,1)
      if Rakes(b,1) == BB
          GameRakeMatrix = Rakes(b,:);
          break
      end
   end

    PlayersForRake = 0;
    for a = 1:6
        if ~isempty(HH{1,a,1})
            PlayersForRake = PlayersForRake + 1;
        end
    end

    if PlayersForRake == 2
        %Do nothing
    elseif PlayersForRake < 5
        GameRakeMatrix(3) = GameRakeMatrix(4);
    else
        GameRakeMatrix(3) = GameRakeMatrix(5);
    end
    GameRakeMatrix = GameRakeMatrix(1,1:3);   
end






%___________________________________ SHIT PREFLOP _______________________________________

POT = 0; %total game pot
Ante = 0; %size of Ante

%S&B BLINDS
if SBin == 1
    Stack = HH{2,1,1} - SB;
    HH(2,1,1:4) = {Stack};
    HH{3,1,1} = SB;
    POT = SB;
end
 
Stack = HH{2,2,1} - BB;
HH(2,2,1:4) = {Stack};
POT = POT + BB;
HH{3,2,1} = BB;
    
for CurrentLine = CurrentLine:size(Text,1)
    Row = Text{CurrentLine};
    
    if strcmp(Row,'*** HOLE CARDS ***') == 1
        CurrentLine = CurrentLine + 1; %#ok<FXSET>
        break
    end
    
    if strfind(Row,': posts the ante') > 0
        spaces = strfind(Row, ' ');
        Name = Row((spaces(size(spaces,2))+2):size(Row, 2));
        Ante = sscanf(Name,'%f');
        
        Stack = HH{2,j,1} - Ante;
        HH(2,j,1:4) = {Stack};
        POT = POT + Ante;
        continue
    end
        
    if strfind(Row,': posts big b') > 0
        for b = 3:Players
            if strfind(Row,HH{1,b,1}) > 0
                Stack = HH{2,b,1} - BB;
                HH(2,b,1:4) = {Stack};
                POT = POT + BB;
                HH{3,b,1} = BB;
            end
        end
        continue
    end

    if strfind(Row,': posts small & big blinds') > 0
        for b = 3:Players
            if strfind(Row,HH{1,b,1}) > 0
                Stack = HH{2,b,1} - BB - SB;
                HH(2,b,1:4) = {Stack};
                POT = POT + BB + SB;
                HH{3,b,1} = BB + SB;
            end
        end
        continue
    end    
    
    if strfind(Row,': posts small b') > 0
        for b = 3:Players
            if strfind(Row,HH{1,b,1}) > 0
                Stack = HH{2,b,1} - SB;
                HH(2,b,1:4) = {Stack};
                POT = POT + SB;
                HH{3,b,1} = SB;
            end
        end
        continue
    end
 
end
   
    
%_______________________________________ CARDS ___________________________________________    
 
Row = Text{CurrentLine};
if strfind(Row,'Dealt to ') == 1    
    spaces = strfind(Row, ' ');
    Name = Row((spaces(size(spaces,2)-1)+2):(spaces(size(spaces,2))+2));
    MyName = Row((spaces(2)+1):(spaces(size(spaces,2)-1)-1));
    for b = 1:Players
        if strcmp(HH{1,b,1},MyName) == 1
            HH(4,b,1:4) = {Name};
            break
        end
    end
    CurrentLine = CurrentLine + 1;
end
    
    

%_______________________________________ BEAST ___________________________________________     
    
HHLine = 6; %line number in the cube, 6 is the first action
street = 1; %1 - pre-flop, 2 - flop, 3 - turn, 4 - river
RoundBet = BB; %what is the current bet in the Round
BET = 1; % which bet it is in the Round
CBet = 0; %0 - no CBet, 1 - live CBet, 2 - Reraised CBet, 3 - carry over CBet
SBet = 0; %Big blind steal bet
ABet = 0; %All-in bet
summary = cell(1,12); % 1 - position, 2 - POT, 3 - collected $, 4 - winner, 5 - winner #2 (split pot), 6 - BB, 7 -12 hole cards
showdown = cell(2,6); %first line checks if player went to showdown, second - ??
showdown(1,1:6) = {'N'};
LastRaise = 0; %who was the last one to raise pre-flop
SplitPot = 1; %This changes according to how many people win the pot
Limpers = 0;
IBet = 0; %Isolation bet
PotSummary = cell(1,2);
DoubleRun = 0;
spaces2 = 0; %temporary for double search
LineReader = ones(1,4); %Stops reading same lines after they've been executed
LineReader(1) = 0;
NN = 0; %variable Name turned to a number to save from multiple conversions   
temp = zeros(1,11); %where all information about an action is put
AI = 0; %Incase anyone goes all in (carry over)
UnrakedPot = 0; %This will calculate the unraked Pot besides the regular shown on the screen
RakeAmount = 0;
RakedPot = 0;
StreetTemp = zeros(1,6,4); %This will store all temp(1) for every street for every player
HeroIsIn = 0; % (1/0) depending if Hero's in, Hero Nick is defined in "UpdatePT"
InPosition = 0; % (1/0) depending if the player's in position
Squeeze = 0; 



%             The New Way cube definitions is as follows:
%             
%  !!! First position defines the action taken where:
%        1 - fold
%        2 - call
%        3 - bet
%        4 - check
%  !!! Second position defines which BET level was reached AFTER the action was taken
%  !!! Third position defines the style of the action where:
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
%        12 - Squeeze/Cold call
%  !!! Fourth position shows if the player is all-in or not
%  !!! Fifth position:
%        BET - how much is the new bet
%        CALL - how much did player have to call on top of the the money already up front
%        FOLD - how much player would have had to call
%  !!! Sixth position:
%        BET - previous roundbet
%        CALL - roundbet
%        FOLD - roundbet
%  !!! Seventh position shows the POT before taking the action
%  !!! Eighth position shows STACK prior to taking the action
%  !!! Ninth position shows if the player is in position (0/1)
%  !!! Tenth position shows if the Hero is in the game (0/1)
%  !!! Eleventh position shows the amount of players still in the hand

for a = 1:6
    if strcmp(HH{1,a,1},HeroName)
        HeroIsIn = 1;
        break
    end
end
    

for a = CurrentLine:size(Text,1)    
    StartLine = CurrentLine;
    Row = Text{CurrentLine};
    if size(Row,2) == 0
        continue
    elseif strcmp(' ',Row(size(Row,2))) == 1
        Row(size(Row,2)) = '';
    end
    
    for b = 1:size(PlayersIn,2)
        if strfind(Row , PlayersIn{1,b}) > 0;
            j = PlayersIn{2,b};
            
            if sum(IsIn(j:end)) == 1
                InPosition = 1;
            else
                InPosition = 0;
            end
            
            %ALL IN
            if strfind(Row ,'and is all-in') > 0
                if size(HH{HHLine,j,street}) > 0
                    HHLine = HHLine +1;
                end 
                spaces = strfind(Row, ' ');
                Name = Row((spaces(size(spaces,2)-3)+2):(spaces(size(spaces,2)-2)-1));
                NN = sscanf(Name,'%f');
                
                temp(4) = 1;
                temp(5) = NN;
                temp(6) = RoundBet;
                temp(7) = POT;
                temp(8) = HH{2,j,street};
                temp(9)  = InPosition;
                temp(10) = HeroIsIn;
                temp(11) = sum(IsIn) - 1;
                
                if strfind(Row ,': calls ') > 0
                    temp(1) = 2;
                    temp(2) = BET;

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
                            if SBet == 1 && j == 2
                                temp(3) = 5;
                            elseif IBet == 1 && HHLine == 7
                                temp(3) = 6;
                            else
                                temp(3) = 4;
                            end
                        elseif BET == 3
                            if HHLine > 6
                                temp2 = HH{6,j,1};
                                if temp2(1) == 3
                                    temp(3) = 7;
                                else
                                    temp(3) = 4;
                                end
                            else
                                temp(3) = 4;
                            end
                        else
                            temp(3) = 4;
                        end
                    elseif BET == 1 && CBet == 1
                        temp(3) = 8;
                    else
                        temp(3) = 4;
                    end
                    
                    StreetTemp((HHLine-5),j,street) = temp(1);
                    HH(2,j,street:4) = {0};
                    POT = POT + NN;
                    HH{3,j,street} = HH{3,j,street} + NN;
                    HH{HHLine,j,street} = temp;
                    CurrentLine = CurrentLine + 1;
                else
                    ABet = 1;
                    BET = BET + 1;
                    temp(1) = 3;
                    temp(2) = BET;
                    if street == 1
                        if Limpers == 0 && (j == 5 || j == 6)
                            temp(3) = 5;
                            SBet = 1;
                        elseif SBet == 1 && j == 2 && BET == 3
                            temp(3) = 5;
                        elseif BET == 2 && Limpers == 1
                            temp(3) = 6;
                            IBet = 1;                                
                        else
                            temp(3) = 4;
                        end
                    else
                        if CBet == 1 && BET == 2
                            temp(3) = 10;
                        elseif LastRaise == j && CBet == 3
                            temp(3) = 8;
                        else
                            temp(3) = 4;
                        end
                    end
                    
                    StreetTemp((HHLine-5),j,street) = temp(1);
                    HH(2,j,street:4) = {0};
                    POT = POT + NN - HH{3,j,street};            
                    RoundBet = NN;    
                    HH{3,j,street} = NN;
                    HH{HHLine,j,street} = temp;
                    LastRaise = j;
                    CurrentLine = CurrentLine + 1;
                end
                break
            end
            
            
            
            %FOLDS
            if strfind(Row ,': folds') > 0
                if size(HH{HHLine,j,street}) > 0
                    HHLine = HHLine + 1;
                end  
                temp(1)  = 1;
                temp(2)  = BET;
                temp(4)  = 0;
                temp(5)  = RoundBet - HH{3,j,street};
                temp(6)  = RoundBet;
                temp(7)  = POT;
                temp(8)  = HH{2,j,street};
                temp(9)  = InPosition;
                temp(10) = HeroIsIn;
                temp(11) = sum(IsIn) - 1;
                
                if street == 1
                    if BET == 1
                        if Limpers == 0
                            temp(3) = 1;
                        elseif Limpers == 1
                            temp(3) = 2;
                        else 
                            temp(3) = 3;
                        end
                    elseif BET == 2 
                        if Squeeze == 2
                            temp(3) = 12;
                        elseif SBet == 1 && j == 2
                            temp(3) = 5;
                        end
                    elseif BET > 1 && HHLine == 7
                        temp2 = HH{6,j,1};
                        if BET == 3 
                            if temp2(1) == 3 && temp2(2) == 2
                                if temp2(3) == 5
                                    temp(3) = 5;
                                end
                            elseif Squeeze == 2
                                temp(3) = 12;
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
                    elseif ABet == 1 && HHLine > 6
                        temp(3) = 11;
                    else
                        temp(3) = 4;
                    end
                else
                    if CBet == 1
                        temp(3) = 8;
                    elseif ABet == 1
                        temp(3) = 5;
                    elseif BET == 2 && CBet == 2 && LastRaise == j
                        temp(3) = 10;
                    else
                        temp(3) = 4;
                    end
                end
                
                if HeroIsIn == 1
                    if strcmp(HH{1,j,1},HeroName)
                        HeroIsIn = 0;
                    end
                end
                StreetTemp((HHLine-5),j,street) = temp(1);
                HH{HHLine,j,street} = temp;
                CurrentLine = CurrentLine + 1;
                PlayersIn(:,b) = [];
                break
            end
            
            
            
            %CHECKS            
            if strfind(Row ,': checks') > 0
                if size(HH{HHLine,j,street}) > 0
                    HHLine = HHLine +1;
                end   
                
                temp(1) = 4;
                temp(2) = BET;
                temp(4) = 0;
                temp(5) = HH{3,j,street};
                temp(6) = RoundBet;
                temp(7) = POT;
                temp(8) = HH{2,j,street};
                temp(9)  = InPosition;
                temp(10) = HeroIsIn;
                temp(11) = sum(IsIn) - 1;
                
                if street == 1
                    if Limpers == 1
                        temp(3) = 2;
                    else
                        temp(3) = 3;
                    end
                elseif LastRaise == j && street == 2 && BET == 0 %Check BET == 0 && Better way for flop CBET
                    temp(3) = 8;
                elseif LastRaise == j && CBet == 3
                    temp(3) = 8;
                else
                    temp(3) = 4;
                end
                
                StreetTemp((HHLine-5),j,street) = temp(1);
                HH{HHLine,j,street} = temp;
                CurrentLine = CurrentLine + 1;
                break
            end
              
            
            
            %RAISES           
            if strfind(Row ,': raises ') > 0
                if size(HH{HHLine,j,street}) > 0
                    HHLine = HHLine +1;
                end             
                spaces = strfind(Row, ' ');
                Name = Row((spaces(size(spaces,2))+2):size(Row, 2));
                NN = sscanf(Name,'%f');
                BET = BET + 1; 
                
                temp(1) = 3;
                temp(2) = BET;
                temp(4) = 0;
                temp(5) = NN;
                temp(6) = RoundBet;
                temp(7) = POT;
                temp(8) = HH{2,j,street};    
                temp(9)  = InPosition;
                temp(10) = HeroIsIn;
                temp(11) = sum(IsIn) - 1;
                
                if street == 1
                    LastRaise = j;
                    if BET > 3
                        Squeeze = 0;
                    elseif Squeeze == 0
                        Squeeze = 1;
                    elseif Squeeze == 1
                        Squeeze = 0;
                    end
                    if BET == 2
                        if Limpers == 0 && (j == 5 || j == 6 || j == 1)
                            temp(3) = 5;
                            SBet = 1;
                        elseif Limpers == 1
                            temp(3) = 6;
                            IBet = 1;
                        else
                            temp(3) = 4;
                        end
                    elseif BET == 3
                        if Squeeze == 2
                            temp(3) = 12;
                        elseif j == 2 && SBet == 1
                            temp(3) = 5;
                        else 
                            temp(3) = 7;
                        end
                        SBet = 0;
                        IBet = 0;
                    elseif ABet == 1
                        temp(3) = 11;
                    elseif Squeeze == 2
                        temp(3) = 12;
                    else
                        temp(3) = 4;
                    end
                else
                    if CBet == 1 && BET == 2
                        temp(3) = 10;
                        CBet = 2;
                    elseif ABet == 1
                        temp(3) = 11;
                    else
                        temp(3) = 4;
                    end
                end
                
                StreetTemp((HHLine-5),j,street) = temp(1);
                HH{HHLine,j,street} = temp;  
                Stack = HH{2,j,street} - NN + HH{3,j,street};
                HH(2,j,street:size(HH,3)) = {Stack}; 
                POT = POT + NN - HH{3,j,street};
                RoundBet = NN;
                HH{3,j,street} = NN;
                CurrentLine = CurrentLine + 1;
                if ABet == 1;
                    ABet = 0; 
                end  
                break
            end
                          
            
            
            %BETS
            if strfind(Row ,': bets ') > 0
                if size(HH{HHLine,j,street}) > 0
                    HHLine = HHLine +1;
                end             
                spaces = strfind(Row, ' ');
                Name = Row((spaces(size(spaces,2))+2):size(Row, 2));
                NN = sscanf(Name,'%f');           
                BET = 1;
                
                temp(1) = 3;
                temp(2) = BET;
                temp(4) = 0;
                temp(5) = NN;
                temp(6) = RoundBet;
                temp(7) = POT;
                temp(8) = HH{2,j,street};         
                temp(9)  = InPosition;
                temp(10) = HeroIsIn;
                temp(11) = sum(IsIn) - 1;
                
                if LastRaise == j && street == 2
                    temp(3) = 8;
                    CBet = 1;
                elseif LastRaise == j && CBet == 3
                    temp(3) = 8;
                    CBet = 1;
                else
                    temp(3) = 4;
                end
                
                StreetTemp((HHLine-5),j,street) = temp(1);
                HH{HHLine,j,street} = temp;
                Stack = HH{2,j,street} - NN + HH{3,j,street};
                HH(2,j,street:4) = {Stack}; 
                POT = POT + NN - HH{3,j,street};
                RoundBet = NN;
                HH{3,j,street} = NN;         
                CurrentLine = CurrentLine + 1;
                break
            end
                                        
            
            
            %CALLS 
            if strfind(Row ,': calls ') > 0
                if size(HH{HHLine,j,street}) > 0
                    HHLine = HHLine +1;
                end             
                spaces = strfind(Row, ' ');
                Name = Row((spaces(size(spaces,2))+2):size(Row, 2));
                NN = sscanf(Name,'%f');
                
                temp(1) = 2;
                temp(2) = BET;
                temp(4) = 0;
                temp(5) = NN;
                temp(6) = RoundBet;
                temp(7) = POT;
                temp(8) = HH{2,j,street};    
                temp(9)  = InPosition;
                temp(10) = HeroIsIn;
                temp(11) = sum(IsIn) - 1;
                
                if Squeeze == 1
                    Squeeze = 2;
                end
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
                        if Squeeze == 2
                            temp(3) = 12;
                        elseif SBet == 1 && j == 2
                            temp(3) = 5;
                        elseif IBet == 1 && HHLine == 7
                            temp(3) = 6;
                        else
                            temp(3) = 4;
                            IBet = 0;
                            SBet = 0;
                        end
                    elseif BET == 3
                        if Squeeze == 2
                            temp(3) = 12;
                        elseif HHLine > 6
                            temp2 = HH{6,j,1};
                            if temp2(1) == 3
                                temp(3) = 7;
                            else
                                temp(3) = 4;
                            end
                        else
                            temp(3) = 4;
                        end
                    elseif ABet == 1 && HHLine > 6
                        temp(3) = 11;
                    else
                        temp(3) = 4;
                    end
                elseif BET == 1 && CBet == 1
                    temp(3) = 8;
                else
                    temp(3) = 4;
                end
                
                StreetTemp((HHLine-5),j,street) = temp(1);
                HH{HHLine,j,street} = temp;
                Stack = HH{2,j,street} - NN;
                HH(2,j,street:4) = {Stack}; 
                POT = POT + NN;
                HH{3,j,street} = HH{3,j,street} + NN;         
                CurrentLine = CurrentLine + 1;
                break
            end                    
        end
    end
      
    
                            
%_______________________________________ STREETS ___________________________________________                
                
    %FLOP START   
    if LineReader(1) == 0 
        if strfind(Row , '*** FLOP ***') > 0
            Name = Row(size(Row, 2)-8:size(Row, 2)-7);
            summary{1,8} = Name;

            Name = Row(size(Row, 2)-5:size(Row, 2)-4);
            summary{1,9} = Name;

            Name = Row(size(Row, 2)-2:size(Row, 2)-1);
            summary{1,10} = Name;

            LineReader(1) = 1;
            LineReader(2) = 0;

            BET = 0;
            HHLine = 6;
            RoundBet = 0;
            street = street + 1;
            CurrentLine = CurrentLine + 1;
            
            UnrakedPot = POT;
            RakeAmount = UnrakedPot*GameRakeMatrix(2);
            RakeAmount = round(RakeAmount,2);
            if RakeAmount < GameRakeMatrix(3)
                POT = UnrakedPot - RakeAmount;            
            else
                POT = UnrakedPot - GameRakeMatrix(3);
            end
            RakedPot = POT;

            if CBet == 1;
                CBet = 3;
            elseif CBet == 2;
                CBet = 3;
            elseif CBet == 3;
                CBet = 0;
            end

            if ABet == 1;
                ABet = 0;
                AI = 1;
            end

        end
    end   



    %TURN START                        
    if LineReader(2) == 0 
        if strfind(Row , '*** TURN ***') > 0
            Name = Row(26:27);
            summary{1,11} = Name;

            LineReader(2) = 1;
            LineReader(3) = 0;


            BET = 0;
            HHLine = 6;
            RoundBet = 0;
            street = street + 1;
            CurrentLine = CurrentLine + 1;
            
            
            UnrakedPot = UnrakedPot + (POT - RakedPot);
            RakeAmount = UnrakedPot*GameRakeMatrix(2);
            RakeAmount = round(RakeAmount,2);
            if RakeAmount < GameRakeMatrix(3)
                POT = UnrakedPot - RakeAmount;            
            else
                POT = UnrakedPot - GameRakeMatrix(3);
            end
            RakedPot = POT;        
            

            if CBet == 1;
                CBet = 3;
            elseif CBet == 2;
                CBet = 3;    
            elseif CBet == 3;
                CBet = 0;
            end

            if ABet == 1;
                ABet = 0; 
                AI = 1;
            end
        end
    end



    %RIVER START        
    if LineReader(3) == 0
        if strfind(Row , '*** RIVER ***') > 0

            Name = Row(30:31);
            summary{1,12} = Name;


            BET = 0;
            HHLine = 6;
            RoundBet = 0;
            LineReader(3) = 1;
            street = street + 1;
            CurrentLine = CurrentLine + 1;
            

            UnrakedPot = UnrakedPot + (POT - RakedPot);
            RakeAmount = UnrakedPot*GameRakeMatrix(2);
            RakeAmount = round(RakeAmount,2);
            if RakeAmount < GameRakeMatrix(3)
                POT = UnrakedPot - RakeAmount;            
            else
                POT = UnrakedPot - GameRakeMatrix(3);
            end
            RakedPot = POT;   
            
            
            if CBet == 1;
                CBet = 3;
            elseif CBet == 2;
                CBet = 3;    
            elseif CBet == 3;
                CBet = 0;
            end

            if ABet == 1;
                ABet = 0;
                AI = 1;
            end
        end
    end     



    %DOUBLE RUN       

    if strfind(Row, '*** FIRST') > 0
        DoubleRun = 1;
    end

    if DoubleRun == 1
        if strfind(Row , '*** FIRST FLOP ***') > 0 
            CurrentLine = CurrentLine + 1;
        elseif strfind(Row , '*** SECOND FLOP ***') > 0
            CurrentLine = CurrentLine + 1;
        elseif strfind(Row , '*** FIRST TURN ***') > 0
            CurrentLine = CurrentLine + 1;
        elseif strfind(Row , '*** SECOND TURN ***') > 0
            CurrentLine = CurrentLine + 1;    
        elseif strfind(Row , '*** FIRST RIVER ***') > 0
            Name = Row(22:23);
            summary{1,8} = Name;

            Name = Row(25:26);
            summary{1,9} = Name;

            Name = Row(28:29);
            summary{1,10} = Name;

            Name = Row(31:32);
            summary{1,11} = Name;

            Name = Row(36:37);
            summary{1,12} = Name;
            CurrentLine = CurrentLine + 1; 
        elseif strfind(Row , '*** SECOND RIVER ***') > 0
            street = 4;
            Name = Row(23:24);
            summary{2,8} = Name;

            Name = Row(26:27);
            summary{2,9} = Name;

            Name = Row(29:30);
            summary{2,10} = Name;

            Name = Row(32:33);
            summary{2,11} = Name;

            Name = Row(37:38);
            summary{2,12} = Name;
            CurrentLine = CurrentLine + 1;
        elseif strfind(Row , '*** FIRST SHOW DOWN ***') > 0
            CurrentLine = CurrentLine + 1;
            break
        end
    end   
    
    
    
%____________________________________ USELESS SHIT ________________________________________    
    
    %CHATTING
    if strfind(Row,' said, "') > 0
       CurrentLine = CurrentLine + 1;
       continue
    end 

    
    %LEAVING TABLE
    if strfind(Row , ' leaves the table') > 0
        CurrentLine = CurrentLine + 1;
        continue
    end   


    %JOINS THE TABLE
    if strfind(Row , ' joins the table') > 0
        CurrentLine = CurrentLine + 1;
        continue
    end    


    %CONNECTED
    if strfind(Row , ' is connected') > 0
        CurrentLine = CurrentLine + 1;
        continue
    end


    %DISCONNECTED
    if strfind(Row , ' is disconnected') > 0
        CurrentLine = CurrentLine + 1;
        continue
    end


    %HAS TIMED OUT
    if strfind(Row , ' has timed out') > 0
        CurrentLine = CurrentLine + 1;
        continue
    end    

    
    %REMOVED FROM TABLE
    if strfind(Row , 'removed from the table') > 0
        CurrentLine = CurrentLine + 1;
        continue
    end    
    
    
    %SHOW DOWN START
    if strfind(Row,[') returned to ', HH{1,j,1}]) > 0
        spaces = strfind(Row, ' ');
        Name = Row((spaces(2)+3):(spaces(3)-2));
        NN = sscanf(Name,'%f');

        POT = POT - NN;
        HH(2,j,street:4) = {HH{2,j,street} + NN};
        HH{3,j,street} = HH{3,j,street} - NN;
        CurrentLine = CurrentLine + 1;
        if size(PlayersIn,2) == 1
            break
        end
    end  
    
    
    %SHOW DOWN START
    if strcmp(Row , '*** SHOW DOWN ***') == 1
        CurrentLine = CurrentLine + 1;
        break
    end    
     
    
    %IDIOT PROOFING
    if CurrentLine == StartLine && size(PlayersIn,2) == 1
        break
    end
    
    
    %UNREAD LINE MESSAGE    
    if CurrentLine == StartLine
        Name = ['Nothing has been read in line ',sprintf('%d', StartLine), ':'];
        disp(Name);
        disp(Text(CurrentLine));
        disp(HistoryFileName);
        CurrentLine = CurrentLine + 1;
    end         
end    
    
    

%______________________________________ SHOWDOWN __________________________________________    

for a = CurrentLine:size(Text,1)
    StartLine = CurrentLine;
    Row = Text{CurrentLine};
    if size(Row,2) == 0
        continue
    elseif strcmp(' ',Row(size(Row,2))) == 1
        Row(size(Row,2)) = '';
    end
    
    for b = 1:size(PlayersIn,2)
        if strfind(Row , PlayersIn{1,b}) > 0;
            j = PlayersIn{2,b};
            
            %SHOWS HAND   
            TEMP = strfind(Row , ': shows [');
            if TEMP > 0
                if length(HH{1,j,1})+ 12 < length(Row)
                    Name = Row((TEMP + 9):(TEMP + 13));
                    HH(4,j,1:4) = {Name};
                    showdown{1,j} = 'Y';
                elseif length(HH{1,j,1})+ 12 == length(Row)
                    showdown{1,j} = 'Y';
                end   
                CurrentLine = CurrentLine + 1;
                break
            end
    
            
            %MUCKS HAND    
            if strfind(Row , ' mucks hand') > 0
                showdown{1,j} = 'Y';
                CurrentLine = CurrentLine + 1;
            end  
            
            
            %COLLECTED MONEYZ
            if strfind(Row , ' collected $') > 0;
                if size(strfind(Row , HH{1,j,1}),1) > 0 
                    if DoubleRun == 0
                    PotSummary{SplitPot,1} = HH{1,j,1};
                    spaces = strfind(Row, ' ');
                        if (length(Row) == strfind(Row, ' from pot') + 8) 
                            PotSummary{SplitPot,2} = sscanf(Row((spaces(size(spaces,2)-2)+2):(spaces(size(spaces,2)-1)-1)),'%f');
                        elseif strfind(Row, ' from main pot') > 0
                            PotSummary{SplitPot,2} = sscanf(Row((spaces(size(spaces,2)-3)+2):(spaces(size(spaces,2)-2)-1)),'%f');
                        elseif strfind(Row, ' from side pot') > 0
                            PotSummary{SplitPot,2} = sscanf(Row((spaces(size(spaces,2)-3)+2):(spaces(size(spaces,2)-2)-1)),'%f');
                        end
                    end
                    CurrentLine = CurrentLine + 1;
                    SplitPot = SplitPot + 1;
                end
                break        
            end       
    
            
            %DOESN'T SHOW HAND
            if strfind(Row , 'show hand') > 0;
                CurrentLine = CurrentLine + 1;
            end    
    
            

        end
    end
    
    
    %SUMMARY START
    if strcmp(Row , '*** SUMMARY ***') == 1;
        if street == 1
            UnrakedPot = POT;
        else
            UnrakedPot = UnrakedPot + (POT - RakedPot);
            RakeAmount = UnrakedPot*GameRakeMatrix(2);
            RakeAmount = round(RakeAmount,2);
            if RakeAmount < GameRakeMatrix(3)
                POT = UnrakedPot - RakeAmount;            
            else
                POT = UnrakedPot - GameRakeMatrix(3);
            end
            RakedPot = POT;      
        end
        
        CurrentLine = CurrentLine + 1;
        break
    end    
    
    
    %SECOND SHOWDOWN
    if strfind(Row , '*** SECOND SHOW DOWN ***') > 0
        CurrentLine = CurrentLine + 1;    
    end      
    
    
    
%____________________________________ USELESS SHIT ________________________________________    
        
    %CHATTING
    if strfind(Row,' said, "') > 0
       CurrentLine = CurrentLine + 1;
       continue
    end 

    
    %LEAVING TABLE
    if strfind(Row , ' leaves the table') > 0
        CurrentLine = CurrentLine + 1;
        continue
    end   


    %JOINS THE TABLE
    if strfind(Row , ' joins the table') > 0
        CurrentLine = CurrentLine + 1;
        continue
    end    


    %CONNECTED
    if strfind(Row , ' is connected') > 0
        CurrentLine = CurrentLine + 1;
        continue
    end


    %DISCONNECTED
    if strfind(Row , ' is disconnected') > 0
        CurrentLine = CurrentLine + 1;
        continue
    end


    %HAS TIMED OUT
    if strfind(Row , ' has timed out') > 0
        CurrentLine = CurrentLine + 1;
        continue
    end         

    
    %UNREAD LINE MESSAGE    
    if CurrentLine == StartLine
        Name = ['Nothing has been read in line ',sprintf('%d', StartLine), ':'];
        disp(Name);
        disp(Text(CurrentLine));
        disp(HistoryFileName);
        CurrentLine = CurrentLine + 1;
    end       
end
     
    

%______________________________________ SUMMARY __________________________________________     

for a = CurrentLine:size(Text,1)
    StartLine = CurrentLine;
    Row = Text{CurrentLine};
    if size(Row,2) == 0
        continue
    elseif strcmp(' ',Row(size(Row,2))) == 1
        Row(size(Row,2)) = '';
    end
    
    %POT SIZE CHECK
    if strfind(Row , 'Total pot ') == 1;
        %Checking the unraked pot
        spaces = strfind(Row, ' ');
        TEMP = sscanf(Row((spaces(2)+2):(spaces(3)-1)),'%f') - UnrakedPot;
        TEMP = sscanf(sprintf('%0.2f',TEMP),'%f');
        if TEMP == -BB;
            TEMP = 0;
        elseif TEMP == SB;
            TEMP =0;
        end
        if TEMP ~= 0;
            disp('!!! Total Pot Count is wrong !!!');
            disp(HandNumber);
            disp(HistoryFileName);
        end
        
        
        %Checking the Rake
        TEMP = Row((spaces(size(spaces,2))+2):end);
        TEMP = sscanf(TEMP,'%f');
        
        if TEMP ~= RakeAmount
            if abs(TEMP - RakeAmount)  > 0.01
                disp('Rake calculations were wrong')
                disp(HandNumber);
                disp(HistoryFileName);
            end
        end
        CurrentLine = CurrentLine + 1;  
        continue
    end


    %RUN TWICE 
    if DoubleRun == 1 && strcmp(Row,'Hand was run twice') == 1
        CurrentLine = CurrentLine + 1;
        continue
    end  

    
    %BOARD
    if strfind(Row , 'Board [') == 1;
        CurrentLine = CurrentLine + 1;
        continue
    elseif strfind(Row , 'FIRST Board [') > 0
        CurrentLine = CurrentLine + 2;  %For Second board
        continue
%     elseif strfind(Row , 'SECOND Board [') > 0
%         CurrentLine = CurrentLine + 1;
    end

    
    %UNREAD LINE MESSAGE 
    if strfind(Row, 'Seat ') == 1
        break
    elseif CurrentLine == StartLine
            Name = ['Nothing has been read in line ',sprintf('%d', StartLine), ':'];
            disp(Name);
            disp(Text(CurrentLine));
            disp(HistoryFileName);
            CurrentLine = CurrentLine + 1;
    end
end
    
    
    
    
for a = CurrentLine:size(Text,1)
    StartLine = CurrentLine;
    Row = Text{CurrentLine};    
    
	for j = 1:Players %#ok<ALIGN>
        if strfind(Row , HH{1,j,1}) > 0;
            
            %MUCKED HAND
            TEMP = strfind(Row , ' mucked [');
            if TEMP > 0
                if strfind(Row , HH{1,j,1}) > 0;
                    if TEMP + 14 == length(Row)
                        Name = Row((TEMP + 9):(TEMP + 13));
                        CurrentLine = CurrentLine + 1;
                        HH(4,j,1:4) = {Name};
                    elseif TEMP + 11 == length(Row)
                        CurrentLine = CurrentLine + 1;
                    end
                end
                break        
            end 
  
            
            %SHOWED HAND
            TEMP = strfind(Row , ' showed [');
            if TEMP > 0;
                if DoubleRun == 1
                spaces2 = strfind(Row, ' and won (');
                spaces = strfind(Row, ' ');
                    if size(spaces2,2) == 1
                        for k = 1:size(spaces,2)
                            if spaces(k) == spaces2
                                Name = Row((spaces(k+2)+3):(spaces(k+3)-2));
                                PotSummary{SplitPot,1} = HH{1,j,1};
                                PotSummary{SplitPot,2} = sscanf(Name,'%f');
                                SplitPot = SplitPot + 1;
                                CurrentLine = CurrentLine + 1;
                                break
                            end
                        end
                    elseif size(spaces2,2) == 2
                        for k = 1:size(spaces,2)
                            if spaces(k) == spaces2(1)
                                Name = Row((spaces(k+2)+3):(spaces(k+3)-2));
                                PotSummary{1,1} = HH{1,j,1};
                                PotSummary{1,2} = sscanf(Name,'%f');
                            elseif spaces(k) == spaces2(2)
                                Name = Row((spaces(k+2)+3):(spaces(k+3)-2));
                                PotSummary{1,2} = PotSummary{1,2} + sscanf(Name,'%f');
                                CurrentLine = CurrentLine + 1;
                                break
                            end
                        end
                    elseif strfind(Row, ' and lost with ')
                    CurrentLine = CurrentLine + 1;
                    end
                else

                Name = Row((TEMP + 9):(TEMP + 13));
                CurrentLine = CurrentLine + 1;
                HH(4,j,1:4) = cellstr(Name);
                end
                break        
            end   


            %SUMMARY COLLECTED
            if strfind(Row , ' collected ($') > 0
                CurrentLine = CurrentLine + 1;
                break
            end  

            
            %FOLDED
            if strfind(Row ,' folded before ') > 0
                CurrentLine = CurrentLine + 1;
                break
            elseif strfind(Row ,'folded on the ') > 0
                CurrentLine = CurrentLine + 1;
                break
            end

            
            %MUCKED HAND
            if strfind(Row, ' mucked') == (length(Row) - 6)
                showdown{1,j} = 'Y';
                CurrentLine = CurrentLine + 1;
                break
            end     
        end
    end
    
 
    %LAST LINE IN THE FILE             
    if CurrentLine == size(Text,1) + 1
        break
    end
    
    
    %LAST LINE IN THE HAND           
    if size(Text{CurrentLine},1) == 0 
        break
    end    
    
    
    %UNREAD LINE MESSAGE    
    if CurrentLine == StartLine
        Name = ['Nothing has been read in line ',sprintf('%d', StartLine), ':'];
        disp(Name);
        disp(Text(CurrentLine));
        disp(HistoryFileName);
        CurrentLine = CurrentLine + 1;
    end     
end

            

%_____________________________________ EXTRA SUMMARY __________________________________________

HH(5,:,3) = {StreetTemp};
summary{1,2} = POT;
summary{1,6} = BB;
summary{1,7} = 'N';


for j=1:6;
    
    temp2 = summary;

    if strcmp(showdown{1,j},'Y') == 1;
       temp2{1,7} = 'Y';
    end
    HH{5,j,1} = temp2;
    HH{5,j,2} = PotSummary;
    
end



%_________________________________________ FIN _______________________________________________


