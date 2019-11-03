% function PlayPF

%Variables:
TH = HH(:,:,1);



%______________________________________________________________________________________________________________            
                                               %The ShaBANG!!!
%Brand new run                                                 
if size(TH{3,1},2) == 0
    
    %this is important!
    TH(5,:) = {0};
    
    %PlayersIn & Moneyz
    FailCount = FailCount + 1; % #1
    [PlayersIn,ErrorMatrix{1,1}] = GetIsIn(HMT,WT,WC);
    [Moneyz,ErrorMatrix{1,2}] = GetMoneyz(HMT,WT,WC,1);
    
    %Recovering PlayersTemp
    if StatusMatrix(WT,WC,4) == 0
        PlayersTemp = PlayersIn;
    else
        PlayersTemp = PlayersTempMatrix{WT,WC};
    end
    FailCount = FailCount + 1; % #2
    
    for i = 1:6
        if i == 1 %hero
            TH{1,i} = i;
            if Moneyz(i) == 0
                continue
            else %in case already posted moneyz
                TH{5,i} = Moneyz(i);
                TH{7,i} = Moneyz(i);
            end
        elseif PlayersIn(i) == 1 %player's in
            TH{1,i} = i;
            TH{7,i} = Moneyz(i);
            TH{8,i} = Moneyz(i);
        elseif PlayersTemp(i) == 1 %player's folded   
            if Moneyz(i) == 0 %with no money in front
                TH{1,i} = i;
                TH{7,i} = 0;
                TH{8,i} = 0;
            else              %having posted some moneyz  
                TH{1,i} = i;
                TH{5,i} = Moneyz(i);
                TH{7,i} = Moneyz(i);
                TH{8,i} = 0;
            end
        else %open seat/sitting out
            TH{1,i} = 0;
            TH{7,i} = 0; 
        end
    end
    
    FailCount = FailCount + 1; % #3
    %Stacks
    [Stacks,ErrorMatrix{1,3}]  = GetStacks(HMT, WT, WC, PlayersIn);
    TH(2,:) = {0};
    for i = 1:6
        TH{2,i} = Stacks(i);
    end    
    FailCount = FailCount + 1; % #4
    
    %Getting Player Names
    if StatusMatrix(WT,WC,6) == 1
        StatusMatrix(WT,WC,6) = 0;
    else
        TextMatrix{WT,WC,4}.BackgroundColor = Yellow;
        [NamesMatrix{WT,WC},ErrorMatrix{3,2}] = GetNames(HMT, WT, WC, NamesMatrix{WT,WC}, PlayersIn);
    end
    FailCount = FailCount + 1; % #5
    
    %Extracting Player Names
    if StatusMatrix(WT,WC,5) == 1
        ExtractedNames = ExtractHHNames(HistoryFileNameMatrix{WT,WC});
        for i = 2:6
           if NamesMatrix{WT,WC}{i,3} == 1
               TH(6,i) = ExtractedNames(i);
               TextMatrix{WT,WC,(i+8)}.BackgroundColor = Green;
           else
               TextMatrix{WT,WC,(i+8)}.BackgroundColor = Grey;
           end
        end
    end
    
    FailCount = FailCount + 1; % #6
    %Rearranging
    RHMatrix{WT,WC} = TH;
    TH = RearrangeHH(TH,Button,Blinds);
    FailCount = FailCount + 1; % #7
    
    %MyCards
    flag = 0;
    while flag == 0
        [MyCards,ErrorMatrix{3,2}] = GetMyCards(HMT, WT, WC);
        if all(MyCards > 0)
            TH{3,1} = MyCards;
            TH{4,1} = CtR(MyCards);   
            break
        elseif GetMyFold(HMT, WT, WC) == 1
            %QUIT PlayPF
        end            
    end
    FailCount = FailCount + 1; % #8
    
    %Pot & Dead Moneyz
    TH{3,2} = GetPotSize(HMT, WT, WC);
    TH{3,4} = GetDeadMoneyz(HMT, WT, WC);
    FailCount = FailCount + 1; % #9
    
    %Filling the HH matrix
    FHMatrix{WT,WC} = TH;
    TH = FillHH(TH,1);
    temp = GpfV2(TH);
    FailCount = FailCount + 1; % #10
    
    disp('______________________________________________________________________________________')
    disp(temp)

    

else
    CL = TH{3,4}{12,1}; 
    PlayersTemp = TH{3,4}{14,1};
    
    %Filling in Stacks & Moneyz
    PlayersIn = GetIsIn(HMT,WT,WC);
    Moneyz  = GetMoneyz(HMT,WT,WC,1);
    
    for i = 1:6
        if PlayersTemp(i) == 0
            continue
        end
        
        Size1 = size(TH{CL,i},2);
        if Size1 == 8
            if CL == size(TH,1)
                CL = CL + 1;
                TH{CL,1} = [];
                HH{CL,1,1} = []; %#ok<SAGROW>
                TH{CL,i} = Moneyz(TH{1,i});
            else
                CL = CL + 1;
                TH{CL,i} = Moneyz(TH{1,i});
            end
        else
            TH{CL,i} = Moneyz(TH{1,i});
        end
        
        if PlayersIn(TH{1,i}) == 0
            TH{CL,i} = 0;
        end
    end
    
    %Stacks
    Stacks = GetStacks(HMT, WT, WC, PlayersIn);
    for i = 1:6
        if TH{1,i} == 0 || PlayersIn(TH{1,i}) == 0
            continue
        else
            TH{2,i} = Stacks(TH{1,i});
        end
    end  
    
    %Pot 
    TH{3,2} = GetPotSize(HMT, WT, WC);
    
    %Filling the HH matrix
    FH = TH;
    TH = FillHH(TH,1);
    temp = GpfV2(TH);
    
    disp(temp)
    
    if size(HH,1) > CL
        HH{CL, 1, 1} = [];
    end
end


%________________________________
%Putting everything back in place
HH(:,:,1) = TH;   

