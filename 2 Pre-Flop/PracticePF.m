% function TH = PracticePF(HMT, WT, WC, HH, Button, PlayersTemp, PlayersIn, Blinds)

HMT = 1;
WT = 1;
WC = 3;

if 1 == 1
    PlayersTemp = ones(6,1);
    Blinds = zeros(2,1);
    HH = cell(8,6,4);
    HH(2,:,1) = {0};
    street = 1;
    TH = HH(:,:,1);
end

% PlayersTemp(2) = 1;

%______________________________________________________________________________________________________________            
                                               %The ShaBANG!!!

if size(TH{3,1},2) == 0  %Brand new run  
    %this is important!
    TH(5,:) = {0};
    
    %Button
    Button = GetButton(HMT, WT, WC);
    
    %PlayersIn & Moneyz
    PlayersIn = GetIsIn(HMT,WT,WC);
    Moneyz  = GetMoneyz(HMT,WT,WC,1);
    
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
    
    %Stacks
    Stacks = GetStacks(HMT, WT, WC, PlayersIn);
    TH(2,:) = {0};
    for i = 1:6
        TH{2,i} = Stacks(i);
    end    
  
    %Rearranging
    RH = TH;
    TH = RearrangeHH(TH,Button,Blinds);
    
    %MyCards
    MyCards = GetMyCards(HMT, WT, WC);
    TH{3,1} = MyCards;
    TH{4,1} = CtR(MyCards);   
    
    %Pot & Dead Moneyz
    TH{3,2} = GetPotSize(HMT, WT, WC);
    TH{3,4} = GetDeadMoneyz(HMT, WT, WC);
    
    %Filling the HH matrix
    FH = TH;
    TH = FillHH(TH,1);
    temp = GpfV2(TH);
    disp(temp)

    
%Any further run
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

end




























































