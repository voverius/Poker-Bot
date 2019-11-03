% function PlayTableV2

StatusMatrix = zeros(4,3,7);
%1 - current status
%2 - last scanned button
%3 - last scanned street
%4 - PlayersTemp Status (1/0)
%5 - History File name known (1/0)
%6 - Names status (1/0)
%7 - Start playting (1/0)


%UsedVariables
close all
HistoryFileNameMatrix = cell(4,3); %Stores History File Names 
CardsHistoryMatrix = cell(4,3,3); %Cards histories for extracting FileName
ActionStatusMatrix = cell(4,3); %this stores pot picture for instant re-action comparison
PlayersTempMatrix = cell(4,3); %contains the information about players at the start
ActionHistory = zeros(5,2); % #1 is the table last acted on & #5 is the 5th last 
TableMatrix = zeros(4,2,3); %4 rows of WT,WC,HMT for all 3 screens
TextMatrix = cell(4,3,14); %This will hold the information about every text line on the window
WindowMatrix = cell(4,3); %This will hold the figures(actual open window data)
BlindsMatrix = cell(4,3); %Stores all blinds for each table
CardsMatrix = cell(4,3); %Cards histories for extracting FileName
NamesMatrix = cell(4,3); %Stores Names matrix's for each table
NamesTemp = cell(6,3); %empty matrix to be used for each new table
HHMatrix = cell(4,3); %Stores everysingle HH for every table
FHMatrix = cell(4,3); %Stores FH's for every table
RHMatrix = cell(4,3); %Stores RH's for every table
QuitGame = 0; %Changes to 1 when the whole mission is to be aborted
run = 0; %Counts how many loops the beast has made

%Filling the variables
NamesTemp(:,3) = {0};
NamesMatrix(:,:) = {NamesTemp};

%Colors for the windows
Grey =[0.8 0.8 0.8];   % 'GREY'
Green = [0.2 0.8 0.2]; % 'BET'
Yellow = [1 1 0.4];    % 'CALL'/'CHECK'
Red = [0.8 0.2 0.2];   % 'FOLD'


%development: 

% TableMatrix(:,1,3) = 4;
% TableMatrix(:,2,3) = 1:4;
TableMatrix(1,:,3) = [2 1];
TableMatrix(2,:,3) = [2 2];
% Blinds = [0.01;0.02];

%___________________________________________________________________________________________________________
%___________________________________________________________________________________________________________
%                                         !! LETS RUMBLE !!
 


while QuitGame == 0
    
    run = run + 1;
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
                end
            end
        end
    end
    
    %________________________________________________________________
    %Before going into the program need to work out Current situation
    for i = 1:3
        for j = 1:4
            if TableMatrix(j,1,i) == 0
                continue
            end

            HMT = TableMatrix(j,1,i);
            WT  = TableMatrix(j,2,i);
            WC  = i;

            %StatusMatrix explanation:
            %1 - Hero has no cards
            %2 - Hero has cards and the initial players in have been scanned
            %3 - Situation was analysed and action put out, but the player is yet to act                                                                 
            %4 - Hero has just acted and moneyz have to be scanned
            %5 - It's hero's turn to act

            
            if GetMyFold(HMT, WT, WC) == 1
                StatusMatrix(j,i,1) = 1;
                StatusMatrix(j,i,2) = 0;
                StatusMatrix(j,i,3) = 0;
                StatusMatrix(j,i,4) = 0;
                StatusMatrix(j,i,6) = 0;
                StatusMatrix(j,i,7) = 1;
                
                TextMatrix{WT,WC,4}.BackgroundColor = Grey;
                TextMatrix{WT,WC,2}.BackgroundColor = Grey;
                TextMatrix{WT,WC,5}.BackgroundColor = Grey;
                TextMatrix{WT,WC,6}.String = ' '; %street
                TextMatrix{WT,WC,7}.String = 'W'; %wait
                TextMatrix{WT,WC,8}.String = '1'; %status
            elseif StatusMatrix(j,i,7) == 1
                if GetAction(HMT, WT, WC) == 1
                    if StatusMatrix(j,i,1) == 3 && CheckButton(HMT,WT,WC,StatusMatrix(j,i,2)) == 1
                        ActionStatus = GetNewAction(HMT,WT,WC);
                        if all(all(ActionStatus == 0))

                        else
                            Correlation = corr2(ActionStatus,ActionStatusMatrix{WT,WC});
                            if Correlation < 0.8
                                %This is in case of a instantanious action after 
                                %Hero has acted
                                StatusMatrix(j,i,1) = 5; 
                                ActionStatusMatrix{WT,WC} = ActionButton;
                                TextMatrix{WT,WC,2}.BackgroundColor = Grey;
                                TextMatrix{WT,WC,5}.BackgroundColor = Grey;
                            else
                                %Do nothing, action has already been analyzed and
                                %shown, index stays '3'
                            end
                        end
                    else
                        StatusMatrix(j,i,1) = 5; 
                        TextMatrix{WT,WC,8}.String = '5';
                        TextMatrix{WT,WC,2}.BackgroundColor = Grey;
                        TextMatrix{WT,WC,5}.BackgroundColor = Grey;
                        ActionStatusMatrix{WT,WC} = GetNewAction(HMT,WT,WC);
                    end
                else
                    if StatusMatrix(j,i,2) == 0 || CheckButton(HMT,WT,WC,StatusMatrix(j,i,2)) == 0
                        PlayersTempMatrix{WT,WC} = GetIsIn(HMT, WT, WC);
                        StatusMatrix(j,i,4) = 1; 
                        StatusMatrix(j,i,1) = 2;
                        StatusMatrix(j,i,2) = GetButton(HMT,WT,WC);
                    elseif StatusMatrix(j,i,1) == 3
                        StatusMatrix(j,i,1) = 4;
                    else
                        StatusMatrix(j,i,1) = 2;
                        TextMatrix{WT,WC,8}.String = '2';
                    end
                    TextMatrix{WT,WC,2}.BackgroundColor = Grey;
                    TextMatrix{WT,WC,5}.BackgroundColor = Grey;
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
    if MaxStatus == 5 
        
        HMT = TableMatrix(ActionMatrix(1),1,ActionMatrix(2));
        WT = ActionMatrix(1);
        WC = ActionMatrix(2);
        Button = GetButton(HMT, WT, WC);
        GoodToGo = 0;
        
        %In case brand new hand
        if StatusMatrix(WT,WC,2) ~= Button || StatusMatrix(WT,WC,3) == 0
            StatusMatrix(WT,WC,2) = Button;
            StatusMatrix(WT,WC,3) = 1;
            HH = cell(8,6,4);
            HH(2,:,1) = {0};
            
            %Checking if History File Name is known
            if StatusMatrix(WT,WC,5) == 1
                Blinds = BlindsMatrix{WT,WC};
            else
                Blinds = [0;0];
                if isempty(CardsHistoryMatrix{WT,WC,3}) == 0
                    HistoryFileName = ExtractHHFileName(CardsHistoryMatrix(WT,WC,:));
                    if isempty(HistoryFileName) == 0
                        HistoryFileNameMatrix{WT,WC} = HistoryFileName;
                        BlindsMatrix{WT,WC} = ExtractHHBlinds(HistoryFileNameMatrix{WT,WC});
                        Blinds = BlindsMatrix{WT,WC};
                        StatusMatrix(WT,WC,5) = 1;
                        
                        %development
                        TextMatrix{WT,WC,3}.BackgroundColor = Green;
                    end
                end
            end
            
            %Play
            try
                FailCount = 0;
                ErrorMatrix = cell(4,4);
                PlayPF
            catch
                %development:
                disp('caught a problem');
                ErrorMatrix{1,4} = PlayersTempMatrix{WT,WC};
                ErrorMatrix{2,1} = RHMatrix{WT,WC};
                ErrorMatrix{2,2} = FHMatrix{WT,WC};
                ErrorMatrix{2,3} = TH;
                ErrorMatrix{2,4} = FailCount;
                ErrorMatrix{3,1} = StatusMatrix;
                
                time = clock;
                code = [num2str(time(4)), num2str(time(5)), num2str(uint8(time(5)*10000))];
                FileName = ['D:\OneDrive\Poker\Europe\M Files\Listed\12 Errors\PlayTable\PlayTable',code,'.mat'];
                save(FileName,'ErrorMatrix');
            end
            
            
            GoodToGo = 1;
            HHMatrix{WT,WC} = HH;
            StatusMatrix(WT,WC,4) = 0;
            TextMatrix{WT,WC,6}.String = 'PF';
            TextMatrix{WT,WC,7}.String = 'A';
            
            %If needed saving the previous hands
            if StatusMatrix(WT,WC,5) == 0
                CardsHistoryMatrix(WT,WC,2:3) = CardsHistoryMatrix(WT,WC,1:2);
                CardsHistoryMatrix{WT,WC,1} = ConvertCards(HH{3,1});
            end
        else
            street = GetStreet(HMT, WT, WC);
            if street == 1
                HH = HHMatrix{WT,WC};
                
                %Play
                try
                    FailCount = 0;
                    ErrorMatrix = cell(4,4);
                    PlayPF
                catch
                    %development:
                    disp('caught a problem');
                    ErrorMatrix{1,4} = PlayersTempMatrix{WT,WC};
                    ErrorMatrix{2,1} = RHMatrix{WT,WC};
                    ErrorMatrix{2,2} = FHMatrix{WT,WC};
                    ErrorMatrix{2,3} = TH;
                    ErrorMatrix{2,4} = FailCount;
                    ErrorMatrix{3,1} = StatusMatrix;

                    time = clock;
                    code = [num2str(time(4)), num2str(time(5)), num2str(uint8(time(5)*10000))];
                    FileName = ['D:\OneDrive\Poker\Europe\M Files\Listed\12 Errors\PlayTable\PlayTable',code,'.mat'];
                    save(FileName,'ErrorMatrix');
                end
                
                GoodToGo = 1;
                HHMatrix{WT,WC} = HH;
                TextMatrix{WT,WC,7}.String = 'A';
            elseif street == 2
                StatusMatrix(WT,WC,3) = 2;
                TextMatrix{WT,WC,6}.String = 'F';
                HH = HHMatrix{WT,WC};
                
                if StatusMatrix(WT,WC,5) == 0
                    CardsHistoryMatrix(WT,WC,2:3) = CardsHistoryMatrix(WT,WC,1:2);
                    CardsHistoryMatrix{WT,WC,1} = ConvertCards(GetBoard(HMT, WT, WC, street));
                end                
            elseif street == 3
                StatusMatrix(WT,WC,3) = 3;
                TextMatrix{WT,WC,6}.String = 'T';
                HH = HHMatrix{WT,WC};
            elseif street == 4
                StatusMatrix(WT,WC,3) = 4;
                TextMatrix{WT,WC,6}.String = 'R';
                HH = HHMatrix{WT,WC};
            else
                %error
            end
        end
        
        
        %Output the action
        if GoodToGo == 1
            if temp(1) == 1
                TextMatrix{WT,WC,2}.BackgroundColor = Red;
                TextMatrix{WT,WC,5}.BackgroundColor = Red;
            elseif temp(1) == 2 || temp(1) == 4
                TextMatrix{WT,WC,2}.BackgroundColor = Yellow;
                TextMatrix{WT,WC,5}.BackgroundColor = Yellow;
            elseif temp(1) == 3 
                TextMatrix{WT,WC,2}.BackgroundColor = Green;
                TextMatrix{WT,WC,5}.BackgroundColor = Green;
            end
        end
        
        StatusMatrix(WT,WC,1) = 3;
        TextMatrix{WT,WC,8}.String = '3';
        
        
    %_____________________
    % Scan previous action
    elseif MaxStatus == 4
        
        
        
        
        
    %_______________________________
    % Check if action has been taken    
    elseif MaxStatus == 3
        HMT = TableMatrix(ActionMatrix(1),1,ActionMatrix(2));
        WT = ActionMatrix(1);
        WC = ActionMatrix(2);
        
        if GetAction(HMT, WT, WC) == 0
            StatusMatrix(WT,WC,1) = 4;
            TextMatrix{WT,WC,8}.String = '4';
            TextMatrix{WT,WC,7}.String = 'W';
        end
        
        
        
    %_________________________________________
    % Whilst with cards and waiting for action     
    elseif MaxStatus == 2
        HMT = TableMatrix(ActionMatrix(1),1,ActionMatrix(2));
        WT = ActionMatrix(1);
        WC = ActionMatrix(2);
        
        if StatusMatrix(WT,WC,4) == 1 && StatusMatrix(WT,WC,6) == 0
            StatusMatrix(WT,WC,6) = 1;
            PlayersIn = GetIsIn(HMT,WT,WC); 
            TextMatrix{WT,WC,4}.BackgroundColor = Green;
            NamesMatrix{WT,WC} = GetNames(HMT, WT, WC, NamesMatrix{WT,WC}, PlayersIn);
        end
    end
    
    
    
    
    
    
    
    
    
    
    
    
    
    
%     if run == 100
%         break
%     end
%     
%     
%     
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
end


























































% end