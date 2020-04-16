%Used variables:
ErrorType = 1;
FailCount = 0;
TH = HH(:,:,1);

%TH 3rd row:
%1st: Cards in numbers
%2nd: Scanned Pot
%3rd: Blinds
%4th: Dead Moneyz / Summary

%TH 4th row:
%1st: Cards (e.g. A7o)
%2nd: 
%3rd: PlayersTemp
%4th: PlayersIn


%For recording errors:
ErrorMatrix = cell(6,4);
ErrorMatrix{5,2} = [HMT,WT,WC];
ErrorMatrix{5,3} = StatusMatrix;
ErrorMatrix{6,1} = GetFullTable(HMT,WT,WC);
ErrorMatrix{6,3} = Button;

%   1st & 2nd:
%1st Column: Players In
%2nd: Moneyz
%3rd: Stacks
%4th: Names

%   3rd & 4th:
%1st: RH & FH
%2nd: Cards
%3rd: Pot
%4th: Dead $

%   5th:
%1st: TH
%2nd: HMT,WT,WC
%3rd: StatusMatrix
%4th: FailCount

%   6th:
%1st: Full table image
%2nd: PlayersTemp
%3rd: Button

try
    if isempty(TH{3,1}) == 1
        %Brand new run   
        
        
        %Names moved to first position as they take the longest and thus
        %will allow other features to settle:
        
        %1 - Getting Player Names
        FailCount = FailCount + 1;
        if StatusMatrix(WT,WC,6) == 1
            %in case already photographed the names
            StatusMatrix(WT,WC,6) = 0;
        else
            TextColorMatrix{WT,WC,14} = 2; %GetName Position
            [NamesMatrix{WT,WC},ErrorMatrix{1,4}] = GetNames(HMT, WT, WC, NamesMatrix{WT,WC}, PlayersIn);
            ErrorMatrix{2,4} = NamesMatrix{WT,WC};
        end    
    
    
        %2 - Extracting Player Names
        FailCount = FailCount + 1;
        if StatusMatrix(WT,WC,5) == 1
            ExtractedNames = ExtractHHNames(HistoryFileNameMatrix{WT,WC});
            if isnumeric(ExtractedNames) == 0
                for i = 2:6
                   if NamesMatrix{WT,WC}{i,3} == 1
                       TH(6,i) = ExtractedNames(i);
                       TextColorMatrix{WT,WC,(i+6)} = 3;
                   else
                       TextColorMatrix{WT,WC,(i+6)} = 0;
                   end
                end
            end
        end           
        
        
        %3 - PlayersIn & Moneyz
        FailCount = FailCount + 1;
        [PlayersIn,ErrorMatrix{1,1}] = GetIsIn(HMT,WT,WC);
        [Moneyz,ErrorMatrix{1,2}] = GetMoneyz(HMT,WT,WC,1);       
        ErrorMatrix{2,1} = PlayersIn;
        ErrorMatrix{2,2} = Moneyz;
        
        %4 - Recovering PlayersTemp
        FailCount = FailCount + 1;   
        if StatusMatrix(WT,WC,4) == 0
            PlayersTemp = PlayersIn;
        else
            PlayersTemp = PlayersTempMatrix{WT,WC};
            ErrorMatrix{6,2} = PlayersTemp;
        end
         
        
        %5 - Filling players in and moneyz
        FailCount = FailCount + 1;
        
        for i = 1:6
            if i == 1 %hero
                TH{1,i} = i;
                if Moneyz(i) == 0
                    continue
                else %in case already posted moneyz
                    TH{5,i} = Moneyz(i);
                    TH{7,i} = Moneyz(i);
                end
            elseif PlayersTemp(i) == 1
                TH{1,i} = i;
                TH{7,i} = Moneyz(i);
                TH{8,i} = Moneyz(i);
            else
                TH{1,i} = 0;
                TH{7,i} = 0;
            end
        end
  
        
        %6 - Stacks
        FailCount = FailCount + 1;
        [Stacks,ErrorMatrix{1,3}]  = GetStacks(HMT, WT, WC, PlayersIn);
        ErrorMatrix{2,3} = Stacks;
        for i = 1:6
            TH{2,i} = Stacks(i);
        end            
        
        
        %7 - Rearranging
        FailCount = FailCount + 1;
        ErrorMatrix{3,1} = TH;
        TH = RearrangeHH(TH,Button,Blinds);    
        for i = 1:6
            HH(1,i,:) = TH(1,i); %#ok<*SAGROW>
        end
        
        
        %8 - My Cards
        FailCount = FailCount + 1;
        MyCardsFlag = 0;
        while MyCardsFlag < 3
            [MyCards,ErrorMatrix{3,2}] = GetMyCards(HMT, WT, WC);
            ErrorMatrix{4,2} = MyCards;
            if all(MyCards > 0)
                %all good
                TH{3,1} = MyCards;
                TH{4,1} = CtR(MyCards);
                break
            elseif GetMyFold(HMT, WT, WC) == 1
                %Player doesn't have cards anymore
                ErrorType = 2;
                error %#ok<*LTARG>
                break
            else
                %3 errors in a row
                MyCardsFlag = MyCardsFlag + 1;
                if MyCardsFlag == 3
                    ErrorType = 3;
                    error
                end
            end
        end
        
        
        %9 - Pot & Dead Moneyz
        FailCount = FailCount + 1;
        [TH{3,2},ErrorMatrix{3,3}] = GetPotSize(HMT, WT, WC);
        [TH{3,4},ErrorMatrix{3,4}] = GetDeadMoneyz(HMT, WT, WC);
        ErrorMatrix{4,3} = TH{3,2};
        ErrorMatrix{4,4} = TH{3,4};
        
        
        %10 - Filling HH
        FailCount = FailCount + 1;
        TH{4,3} = PlayersTemp;
        TH{4,4} = PlayersIn;
        ErrorMatrix{4,1} = TH;
        [TH,FillHHError] = FillHH(TH,1);
        ErrorMatrix{5,1} = TH;
        if FillHHError == 1
        %saving if FH has a problem
            
            PotDifference = TH{3,2} - TH{3,4}{6};
            MoneyzUpFront = GetMoneyz(HMT,WT,WC,2);  
            
            if PotDifference == MoneyzUpFront
                %in case acted before processing was finished
            else
                disp('FillHH error saved');
                time = clock;
                code = [num2str(time(4)), num2str(time(5)), num2str(uint16(time(6)))];
                FileName = ['D:\OneDrive\Poker\Europe\M Files\Listed\12 Errors\FillHH\FillHH_',code,'.mat'];
                save(FileName,'ErrorMatrix');         
            end
        end
        
        
        
        %11 - Output
        FailCount = FailCount + 1;
        tempMatrix{WT,WC} = GpfV2(TH);
        disp('______________________________________________________________________________________')
        disp(tempMatrix{WT,WC})        
        
        
    else
        %Any further run
        
        %1 - Recovering variables
        FailCount = FailCount + 1;
        PlayersTemp = TH{3,4}{14};   
        ErrorMatrix{3,1} = TH;
        
        
        %2 - PlayersIn & Moneyz
        FailCount = FailCount + 1;
        [PlayersIn,ErrorMatrix{1,1}] = GetIsIn(HMT,WT,WC);
        [Moneyz,ErrorMatrix{1,2}] = GetMoneyz(HMT,WT,WC,1);       
        ErrorMatrix{2,1} = PlayersIn;
        ErrorMatrix{2,2} = Moneyz;        
        TH{4,4} = PlayersIn;
         
        
        %3 - Filling players in and moneyz
        FailCount = FailCount + 1;
        QuitLoop = 0;
        i = 2;
        while QuitLoop == 0
            i = i + 1;
            if i == 2
                QuitLoop = 1;
            elseif i > 6
                i = i - 6;
            end
            
            if PlayersTemp(i) == 0
                continue
            end
            Size1 = size(TH,1);
            for j = 7:Size1
               if isempty(TH{j,i}) == 1 || size(TH{j,i},2) == 1
                   TH{j,i} = Moneyz(TH{1,i});
                   break
               elseif j == Size1
                    TH{j+1,1} = [];
                    HH{j+1,1,1} = [];
                    TH{j+1,i} = Moneyz(TH{1,i});                  
                    break
               end
            end
        end     
        
        
        %4 - Stacks
        FailCount = FailCount + 1;
        [Stacks,ErrorMatrix{1,3}]  = GetStacks(HMT, WT, WC, PlayersIn);
        ErrorMatrix{2,3} = Stacks;
        for i = 1:6
            if TH{1,i} == 0 || PlayersIn(TH{1,i}) == 0
                continue
            else
                TH{2,i} = Stacks(TH{1,i});
            end
        end            
        
        
        %5 - Pot 
        FailCount = FailCount + 1;
        [TH{3,2},ErrorMatrix{3,3}] = GetPotSize(HMT, WT, WC);
        ErrorMatrix(4,3) = TH(3,2);
            
        
        
        %6 - Filling HH
        FailCount = FailCount + 1;
        ErrorMatrix{4,1} = TH;
        [TH,FillHHError] = FillHH(TH,1);
        ErrorMatrix{5,1} = TH;
        if FillHHError == 1
        %saving if FH has a problem
            
            PotDifference = TH{3,2} - TH{3,4}{6};
            MoneyzUpFront = GetMoneyz(HMT,WT,WC,2);  
            
            if PotDifference == MoneyzUpFront
                %in case acted before processing was finished
            else
                disp('FillHH error saved');
                time = clock;
                code = [num2str(time(4)), num2str(time(5)), num2str(uint16(time(6)))];
                FileName = ['D:\OneDrive\Poker\Europe\M Files\Listed\12 Errors\FillHH\FillHH_',code,'.mat'];
                save(FileName,'ErrorMatrix');         
            end          
        end        
        
        
        
        %7 - Output
        FailCount = FailCount + 1;
        tempMatrix{WT,WC} = GpfV2(TH);
        disp(tempMatrix{WT,WC})   
        
    end
    
    %Placing TH back in HH
    if size(TH,1) ~= size(HH,1)
        HH(size(TH,1),1,1) = [];        
    end
    HH(:,:,1) = TH;
    
catch
    %Development:
    
    street = GetStreet(HMT, WT, WC);
    if street ~= 1
        StatusMatrix(WT,WC,1) = 1;
    else
        ErrorMatrix{5,4} = FailCount;
        if ErrorType == 1
            %Regular problem
            disp('caught a problem on PlayPFV2');
            time = clock;
            code = [num2str(time(4)), num2str(time(5)), num2str(uint16(time(6)))];
            FileName = ['D:\OneDrive\Poker\Europe\M Files\Listed\12 Errors\PlayTable\PlayPFV2_',code,'.mat'];
            save(FileName,'ErrorMatrix');    
        elseif ErrorType == 2
            %Cards have been folded and this loop should not have started
            StatusMatrix(WT,WC,1) = 1;
        elseif ErrorType == 3
            %Cannot scan Cards
            disp('Cannot Recognize the Cards');
            time = clock;
            code = [num2str(time(4)), num2str(time(5)), num2str(uint16(time(6)))];
            FileName = ['D:\OneDrive\Poker\Europe\M Files\Listed\12 Errors\PlayTable\PlayPFV2_',code,'.mat'];
            save(FileName,'ErrorMatrix');            
        end
    end
end