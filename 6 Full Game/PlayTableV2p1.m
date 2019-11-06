% function PlayTableV2

StatusMatrix = zeros(4,3,9);
%1 - current status
%2 - last scanned button
%3 - last scanned street
%4 - PlayersTemp Status (1/0)
%5 - History File name known (1/0)
%6 - Names status (1/0)
%7 - Start playing (1/0)
%8 - Table's open (1/0)
%9 - Windows needs updating (1/0)


%UsedVariables
close all

HistoryFileNameMatrix = cell(4,3); %Stores History File Names 
CardsHistoryMatrix = cell(4,3,3); %Cards histories for extracting FileName
ActionStatusMatrix = cell(4,3); %this stores pot picture for instant re-action comparison
TextColorMatrix = cell(4,3,20); %Stores all colors for the window
PlayersTempMatrix = cell(4,3); %contains the information about players at the start
ActionHistory = zeros(5,2); % #1 is the table last acted on & #5 is the 5th last 
TableMatrix = zeros(4,2,3); %4 rows of WT,WC,HMT for all 3 screens
TextMatrix = cell(4,3,20); %This will hold the information about every text line on the window
WindowMatrix = cell(4,3); %This will hold the figures(actual open window data)
BlindsMatrix = cell(4,3); %Stores all blinds for each table
CardsMatrix = cell(4,3); %Cards histories for extracting FileName
NamesMatrix = cell(4,3); %Stores Names matrix's for each table
tempMatrix = cell(4,3); %Stores all temp outputs for each table
NamesTemp = cell(6,3); %empty matrix to be used for each new table
HHMatrix = cell(4,3); %Stores everysingle HH for every table
QuitGame = 0; %Changes to 1 when the whole mission is to be aborted
run = 0; %Counts how many loops the beast has made

%Filling the variables
NamesTemp(:,3) = {0};
NamesMatrix(:,:) = {NamesTemp};

%Colors for the windows
Grey =[0.8 0.8 0.8];   % 'GREY'
Red = [0.8 0.2 0.2];   % 'FOLD'
Yellow = [1 1 0.4];    % 'CALL'/'CHECK'
Green = [0.2 0.8 0.2]; % 'BET'



%development: 
% TableMatrix(1,:,2) = [1 1];
% TableMatrix(1,:,3) = [1 1];

% TableMatrix(1,:,3) = [2 1];
% TableMatrix(2,:,3) = [2 2];
% TableMatrix(1,:,2) = [2 1];
% TableMatrix(2,:,2) = [2 2];

TableMatrix(1,:,2) = [4 1];
TableMatrix(2,:,2) = [4 2];
TableMatrix(3,:,2) = [4 3];
TableMatrix(4,:,2) = [4 4];

% TableMatrix(1,:,3) = [4 1];
% TableMatrix(2,:,3) = [4 2];
% TableMatrix(3,:,3) = [4 3];
% TableMatrix(4,:,3) = [4 4];

%___________________________________________________________________________________________________________
%                                            !! START !!
while QuitGame == 0
    run = run + 1;

    
    %____________________________________________________________
    %Checking if the table's open, if not - skip any action on it
%     StatusMatrix(:,:,8) = 0;
    for i = 1:3
        for j = 1:4
            if TableMatrix(j,1,i) == 0
                continue
            end
            
            HMT = TableMatrix(j,1,i);
            WT  = TableMatrix(j,2,i);
            WC  = i;
            if CheckTable(HMT, WT, WC) == 1
                if StatusMatrix(j,i,8) == 0
                    StatusMatrix(j,i,8) = 1;
                    StatusMatrix(j,i,9) = 1;
                    TextColorMatrix{j,i,13} = 3;
                end
            else
                if StatusMatrix(j,i,8) == 1
                    StatusMatrix(j,i,8) = 0; 
                    StatusMatrix(j,i,9) = 1;
                    TextColorMatrix{j,i,13} = 1;
                end
            end
        end
    end

    
    %_________________________________________________________________
    %Creating or bringing up the pop-up windows for every table played
    for i = 1:3
        for j = 1:4
            if TableMatrix(j,1,i) == 0
                continue
            end
            
            HMT = TableMatrix(j,1,i);
            WT  = TableMatrix(j,2,i);
            WC  = i;
            
            if size(WindowMatrix{j,i},1) == 0 %creates a new window
                [WindowMatrix{j,i}, TextMatrix] = CreateWindow(HMT, WT, WC, TextMatrix);
                WinOnTop(WindowMatrix{j,i});
            else
                try 
                    WindowMatrix{j,i}.Number;
                    drawnow
                catch
                    [WindowMatrix{j,i}, TextMatrix] = CreateWindow(HMT, WT, WC, TextMatrix);
                    WinOnTop(WindowMatrix{j,i});
                    StatusMatrix(j,i,9) = 1;
                    if StatusMatrix(j,i,8) == 1 %Table is open and active
                        TextColorMatrix{j,i,13} = 3;
                    end
                    if StatusMatrix(j,i,8) == 0 %Table is closed and active
                        TextColorMatrix{j,i,13} = 1;
                    end
                    if StatusMatrix(j,i,5) == 1 %File name is known
                        TextColorMatrix{j,i,15} = 3;
                    end
                end
            end
            
            if StatusMatrix(j,i,9) == 1
                for k = 1:size(TextColorMatrix,3)
                    if isempty(TextColorMatrix{j,i,k}) 
                        %empty
                        continue
                    elseif isnumeric(TextColorMatrix{j,i,k}) 
                        %number for a color
                        if TextColorMatrix{j,i,k} == 0
                            TextMatrix{j,i,k}.BackgroundColor = Grey;
                        elseif TextColorMatrix{j,i,k} == 1
                            TextMatrix{j,i,k}.BackgroundColor = Red;
                        elseif TextColorMatrix{j,i,k} == 2
                            TextMatrix{j,i,k}.BackgroundColor = Yellow;
                        elseif TextColorMatrix{j,i,k} == 3
                            TextMatrix{j,i,k}.BackgroundColor = Green;
                        end
                    else
                        %string
                        TextMatrix{j,i,k}.String = TextColorMatrix{j,i,k};
                    end
                end
                WinOnTop(WindowMatrix{j,i},logical(0)); %#ok<*LOGL>
                WinOnTop(WindowMatrix{j,i},logical(1));
                TextColorMatrix(j,i,:) = {[]};
                StatusMatrix(j,i,9) = 0;
            end
        end
    end


    %________________________________________________________________
    %Before going into the program need to work out Current situation
    for i = 1:3
        for j = 1:4
            if TableMatrix(j,1,i) == 0 || StatusMatrix(j,i,8) == 0
                continue
            end

            HMT = TableMatrix(j,1,i);
            WT  = TableMatrix(j,2,i);
            WC  = i;

            %StatusMatrix explanation:
            %1 - Hero has no cards
            %2 - Hero has cards and the initial players in have been scanned
            %3 - Situation was analysed and action put out, but the player is yet to act                                                                 
            %4 - EMPTY
            %5 - It's hero's turn to act

            
            if GetMyFold(HMT, WT, WC) == 1 ||...
               (StatusMatrix(j,i,2) > 0 && CheckButton(HMT,WT,WC,StatusMatrix(j,i,2)) == 0)
                %Player has no Cards
                
                StatusMatrix(j,i,1) = 1; %Main Status
                StatusMatrix(j,i,2) = 0; %Last Button
                StatusMatrix(j,i,3) = 0; %last Street
                StatusMatrix(j,i,4) = 0; %PlayersTemp
                StatusMatrix(j,i,6) = 0; %Names Status
                StatusMatrix(j,i,7) = 1; %Start Playing
                StatusMatrix(j,i,9) = 1; %Print the following:
                
                TextColorMatrix{j,i,1}  = 0; %Main Output
                TextColorMatrix{j,i,2}  = 0; %General Output
                TextColorMatrix{j,i,3}  = 0; %PT Output
                TextColorMatrix{j,i,4}  = 0; %Nash Output
                TextColorMatrix{j,i,5}  = ' '; %Street
                TextColorMatrix{j,i,6}  = 'W'; %Waiting Status
                TextColorMatrix{j,i,7}  = '1'; %Main Status
                TextColorMatrix{j,i,14} = 0; %Player Name Location
                TextColorMatrix{j,i,16} = ' '; %Cards
                TextColorMatrix{j,i,17} = ' '; %POT
                TextColorMatrix{j,i,19} = ' '; %1st temp half
                TextColorMatrix{j,i,20} = ' '; %2nd temp half
            elseif StatusMatrix(j,i,7) == 1
                %Hero Has Cards
                
                if GetAction(HMT, WT, WC) == 1
                    %Action is on hero
                    
                    if StatusMatrix(j,i,2) ~= 0 && StatusMatrix(j,i,1) == 3 &&...
                       CheckButton(HMT,WT,WC,StatusMatrix(j,i,2)) == 1
                        %Action has been put out for Hero
                        
                        ActionStatus = CheckPot(HMT,WT,WC);
                        Correlation = corr2(ActionStatus,ActionStatusMatrix{WT,WC});
                        if Correlation < 0.8
                            %This is in case of a instantanious action after 
                            %Hero has acted
                            
                            StatusMatrix(j,i,1) = 5; 
                            ActionStatusMatrix{WT,WC} = ActionStatus;
                        end
                    else
                        %New Action on Hero
                        StatusMatrix(j,i,1) = 5; 
                        ActionStatusMatrix{WT,WC} = CheckPot(HMT,WT,WC);
                    end
                    
                    if StatusMatrix(j,i,1) == 5
                        %Updating the window
                        
                        StatusMatrix(j,i,9) = 1; %Print the following:
                        TextColorMatrix{j,i,1} = 0; %Main Output
                        TextColorMatrix{j,i,2} = 0; %General Output
                        TextColorMatrix{j,i,7} = '5'; %Main Status
                    end
                else
                    %Hero has cards, but it's not action time
                    if StatusMatrix(j,i,2) == 0 || CheckButton(HMT,WT,WC,StatusMatrix(j,i,2)) == 0
                        %New hand:
                        
                        PlayersTempMatrix{WT,WC} = GetIsIn(HMT, WT, WC);
                        StatusMatrix(j,i,4) = 1; %PlayersTemp
                        StatusMatrix(j,i,1) = 2; %Main Status
                        StatusMatrix(j,i,2) = GetButton(HMT,WT,WC); %Button
                    else
                        StatusMatrix(j,i,1) = 2;
                    end
                    
                    if StatusMatrix(j,i,1) == 2
                        %Updating the window
                        
                        StatusMatrix(j,i,9) = 1; %Print the following:
                        TextColorMatrix{j,i,1} = 0; %Main Output
                        TextColorMatrix{j,i,2} = 0; %General Output
                        TextColorMatrix{j,i,7} = '2'; %Main Status
                    end
                end
            end
        end
    end 

    

    %______________________________________________________
    %Working out which table to act on by urgency principle
    clear ActionMatrix
    MaxStatus = max(max(StatusMatrix(:,:,1)));
    [ActionMatrix(:,1),ActionMatrix(:,2)] = find(StatusMatrix(:,:,1) == MaxStatus);
    ActionSize = size(ActionMatrix,1);
    if ActionSize > 1
        for i = 1:size(ActionHistory,1)
            if size(ActionMatrix,1) == 1
                break
            end
            ActionComparison = not(all(bsxfun(@eq, ActionHistory(i,:), ActionMatrix),2));
            ActionMatrix = ActionMatrix(ActionComparison,:);
        end    
        if size(ActionMatrix,1) > 1 
            ActionMatrix = ActionMatrix(1,:);
        end
    end
    ActionHistory(2:5,:) = ActionHistory(1:4,:);
    ActionHistory(1,:) = ActionMatrix(1,:);
    
    
%_________________________________________________________________________________________________________
                                    %Time to shine MotherFucker!!!    
    
    HMT = TableMatrix(ActionMatrix(1),1,ActionMatrix(2));
    WT = ActionMatrix(1);
    WC = ActionMatrix(2);                                
                                    
    if MaxStatus == 5 
        Button = GetButton(HMT, WT, WC);
        tempMatrix{WT,WC} = [];
        GoodToGo = 0;
        
        if StatusMatrix(WT,WC,3) == 0 || StatusMatrix(WT,WC,2) ~= Button
            %Brand New Hand
            
            StatusMatrix(WT,WC,2) = Button;
            StatusMatrix(WT,WC,3) = 1;
            HH = cell(8,6,4);
            HH(2,:,:) = {0};
            HH(5,:,:) = {0};
            street = 1;
        
            %Checking if History File Name is known
            if StatusMatrix(WT,WC,5) == 1
                %FileName is known
                Blinds = BlindsMatrix{WT,WC};
            else
                %FileName is unknown
                Blinds = [0;0];
                if isempty(CardsHistoryMatrix{WT,WC,3}) == 0
                    %Have at least 3 seen hands
                    HistoryFileName = ExtractHHFileName(CardsHistoryMatrix(WT,WC,:));
                    if isempty(HistoryFileName) == 0
                        %FileName is known
                        BlindsMatrix{WT,WC} = ExtractHHBlinds(HistoryFileName);
                        HistoryFileNameMatrix{WT,WC} = HistoryFileName;
                        Blinds = BlindsMatrix{WT,WC};
                        TextColorMatrix{WT,WC,15} = 3; 
                        StatusMatrix(WT,WC,5) = 1;
                    end
                end
            end        
        
            %________________________
            %Play the motherfucker!!!
            PlayPFV2
            
            %Development
            if StatusMatrix(WT,WC,1) == 1
                %went into a wrong street
                
                %Hero does not have cards anymore
                
            elseif StatusMatrix(WT,WC,1) == 5
                GoodToGo = 1;
                HHMatrix{WT,WC} = HH;
                StatusMatrix(WT,WC,4) = 0;
                StatusMatrix(WT,WC,9) = 1;
                TextColorMatrix{WT,WC,5} = 'PF'; 
                            
                if StatusMatrix(WT,WC,5) == 0
                    %If needed saving the previous hands
                    CardsHistoryMatrix(WT,WC,2:3) = CardsHistoryMatrix(WT,WC,1:2);
                    CardsHistoryMatrix{WT,WC,1} = ConvertCards(HH{3,1});
                end
            end
        else
            %Continue to play the hand
            street = GetStreet(HMT, WT, WC);
            
            if street >= StatusMatrix(WT,WC,3)
                if street == 1 
                    %Pre-Flop
                    HH = HHMatrix{WT,WC};
                    %________________________
                    %Play the motherfucker!!!
                    PlayPFV2

                    if StatusMatrix(WT,WC,1) == 5
                        GoodToGo = 1;
                        HHMatrix{WT,WC} = HH;
                    end
                elseif street == 2
                    %Flop
                    HH = HHMatrix{WT,WC};
                    if StatusMatrix(WT,WC,1) == 5
                        HHMatrix{WT,WC} = HH;
                        StatusMatrix(WT,WC,9) = 1;
                        TextColorMatrix{WT,WC,5} = 'F';
                    end           
                    if StatusMatrix(WT,WC,5) == 0
                        %If still need to work out the History FileName
                        CardsHistoryMatrix(WT,WC,2:3) = CardsHistoryMatrix(WT,WC,1:2);
                        CardsHistoryMatrix{WT,WC,1} = ConvertCards(GetBoard(HMT, WT, WC, street));
                    end  
                elseif street == 3
                    %Turn
                    HH = HHMatrix{WT,WC};
                    if StatusMatrix(WT,WC,1) == 5
                        HHMatrix{WT,WC} = HH;
                        StatusMatrix(WT,WC,9) = 1;
                        TextColorMatrix{WT,WC,5} = 'T';
                    end                 
                elseif street == 4
                    %River
                    HH = HHMatrix{WT,WC};
                    if StatusMatrix(WT,WC,1) == 5
                        HHMatrix{WT,WC} = HH;
                        StatusMatrix(WT,WC,9) = 1;
                        TextColorMatrix{WT,WC,5} = 'R';
                    end 
                end
            else
                %in case of an error where wrong street has been scanned
                %Possibly due to the fact that cards are dealt slower
                %The loop should re-start and inputs re-checked                
            end
            StatusMatrix(WT,WC,3) = street;
        end
        
        if GoodToGo == 1 && isempty(tempMatrix{WT,WC}) == 0
            temp = tempMatrix{WT,WC};
            if temp(1) == 4
                TextColorMatrix{WT,WC,1} = 2;
                TextColorMatrix{WT,WC,2} = 2;
            else
                TextColorMatrix{WT,WC,1} = temp(1);
                TextColorMatrix{WT,WC,2} = temp(1);
            end
            TextColorMatrix{WT,WC,6} = 'A'; %Waiting Status
            TextColorMatrix{WT,WC,7} = '3'; %Main Status
            TextColorMatrix(WT,WC,16) = HHMatrix{WT,WC}(4,1); %Cards
            TextColorMatrix{WT,WC,17} = num2str(HHMatrix{WT,WC}{3,2}); %POT
            TextColorMatrix{WT,WC,19} = num2str(temp(1:4)); %temp
            TextColorMatrix{WT,WC,20} = num2str(temp(5:7)); %temp
        end
        StatusMatrix(WT,WC,1) = 3;
        
    
    
    %_______________________________
    % Check if action has been taken    
    elseif MaxStatus == 3
         if GetAction(HMT, WT, WC) == 0
            TextColorMatrix{WT,WC,6} = 'W'; %Waiting Status
         end   
    
        
        
        
        
    
    %_________________________________________
    % Whilst with cards and waiting for action     
    elseif MaxStatus == 2
        
        if StatusMatrix(WT,WC,4) == 1 && StatusMatrix(WT,WC,6) == 0
            StatusMatrix(WT,WC,6) = 1;
            PlayersIn = GetIsIn(HMT,WT,WC); 
            TextColorMatrix{WT,WC,14} = 3; %Player names extracted before PlayPF
            NamesMatrix{WT,WC} = GetNames(HMT, WT, WC, NamesMatrix{WT,WC}, PlayersIn);
        end    
    
    
    %___________________________
    %No Cards waiting for action
    elseif MaxStatus == 1
        
        

    end
end
