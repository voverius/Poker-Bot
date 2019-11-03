% function PlayTable(HMT, WT, WC)
HMT = 1;
WT = 1;
WC = 3;

%HMC - How Many Tables
%WT - Which Table
%WC - Which Screen
%HH - Hand History Matrix
%This will determine from which area a screenshot of what size will be taken



%Shitload of Variables
CurrentButton = GetButton(HMT, WT, WC);
QuitGame = 0; %if changed to '1' quits playing this table
HH = cell(8,6,4); %first game matrix
HH(2,:,1) = {0}; % fills stacks as zeros, so to know if first betting round or not
PlayersTemp = ones(6,1); % stors playersIn before the action is available, to sort out folds
flag = 0; % turns to 1 if action is to be taken
street = GetStreet(HMT, WT, WC); %says what street it is
CardsMatrix = cell(3,1);  %stores last 3 hole cards
QuitCardMatrix = 0; %Changes to 1 once the 'HistoryFileName' is known
NamesIMGMatrix = cell(6,3); %Stores nickname photos and verifications
NamesIMGMatrix(:,3) = {0}; % 0 - Nicknames have not been yet verified, 1 - verified
QuitBlinds = 0; %Stops trying to extract SB & BB sizes from HH file
Blinds = zeros(2,1); %Stores the size of SB & BB


while QuitGame == 0
    Fold = GetMyFold(HMT, WT, WC);
    while Fold == 0

        Fold = GetMyFold(HMT, WT, WC);
        if Fold == 1
            break
        end

        Button = GetButton(HMT, WT, WC);
        if Button ~= CurrentButton
            PlayersTemp = GetIsIn(HMT, WT, WC);
            flag = 1;
        end

        CurrentStreet = GetStreet(HMT, WT, WC);
        if CurrentStreet ~= street
            PlayersTemp = GetIsIn(HMT, WT, WC);
            flag = 1;
        end    
        
        while flag == 1
            if GetAction(HMT, WT, WC) == 1
                street = GetStreet(HMT, WT, WC);
                Button = GetButton(HMT, WT, WC);

                %PRE-FLOP
                if street == 1

                    if Button ~= CurrentButton %first pre-flop action
                        HH = cell(8,6,4);
                        HH(2,:,1) = {0};
                        CurrentButton = Button;
                        
                        PlayersIn = GetIsIn(HMT,WT,WC);
                        NamesIMGMatrix = GetNames(HMT, WT, WC, NamesIMGMatrix, PlayersIn);
                        if QuitCardMatrix == 1
                            NamesMatrix = ExtractHHNames(HistoryFileName);
                            for i = 2:6
                                if NamesIMGMatrix{i,3} == 1
                                    HH(6,i,1) = NamesMatrix(i);
                                end
                            end
                        end
                       
                        if QuitBlinds == 0 && QuitCardMatrix == 1
                            Blinds = ExtractHHBlinds(HistoryFileName);
                            QuitBlinds = 1;
                        end
                            
%                         HH = PlayPF(HMT, WT, WC, HH, Button, PlayersTemp, PlayersIn, Blinds);
                        PlayPF
                        
                        if QuitCardMatrix == 0
                            if isnumeric(CardsMatrix{1}) == 0
                                HistoryFileName = ExtractHHFileName(CardsMatrix);
                                if isempty(HistoryFileName) == 0
                                    QuitCardMatrix = 1;
                                end
                            end
                            CardsMatrix(1:2) = CardsMatrix(2:3);
                            CardsMatrix{3} = ConvertCards(HH{3,1}); 
                        end 
                        
                        %Fills my action value for future HH construction
                        

                        flag = 0;
%                         HH = GetMyMove(HMT, WT, WC, HH, street);

                    else %later pre-flop action
%                         HH = PlayPF(HMT, WT, WC, HH, Button);
                        disp('second action')
                        PlayPF
                        disp(HH(:,:,1));
                        flag = 0;
                    end



                %FLOP    
                elseif street == 2
                    flag = 0;
                    disp('FLOP');


                %TURN    
                elseif street == 3
                    flag = 0;
                    disp('TURN');


                %RIVER    
                elseif street == 4
                    flag = 0;
                    disp('RIVER');


                end
            end
        end 
    end
end
































% end
































