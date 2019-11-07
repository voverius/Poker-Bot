%                                      PLAY POST-FLOP:  

%Used variables:
ErrorType = 1;
FailCount = 0;

%HH 2nd page:
%3rd row - Board





%For recording errors:
ErrorMatrix = cell(5,4);
ErrorMatrix{3,1} = HH;
ErrorMatrix{5,3} = StatusMatrix(WT,WC,:);
ErrorMatrix{6,1} = GetFullTable(HMT,WT,WC);
ErrorMatrix{6,3} = Button;

%   1st & 2nd:
%1st Column: Players In
%2nd: Moneyz
%3rd: Stacks
%4th: Board

%   3rd & 4th:
%1st: Original HH & FH
%2nd: 
%3rd: Pot
%4th: 

%   5th:
%1st: Final HH
%2nd: 
%3rd: StatusMatrix
%4th: FailCount

try
    %1 - Getting the board & recovering variables
    FailCount = FailCount + 1;
    PlayersTemp = HH{3,4,1}{14,1};  
    if isempty(HH{3,(street+1),2}) == 1
        %New Street
        [ErrorMatrix{2,4},ErrorMatrix{1,4}] = GetBoard(HMT, WT, WC, street);
        if street == 2
            for i = 1:3
                HH{3,i,2} = ErrorMatrix{2,4}(i); %#ok<*SAGROW>
            end             
        else
            HH(3,(street+1),2) = ErrorMatrix(2,4);
        end
    end
    
    
    %2 - PlayersIn & Moneyz
    FailCount = FailCount + 1;
    [PlayersIn,ErrorMatrix{1,1}] = GetIsIn(HMT,WT,WC);
    [Moneyz,ErrorMatrix{1,2}] = GetMoneyz(HMT,WT,WC,1);       
    ErrorMatrix{2,1} = PlayersIn;
    ErrorMatrix{2,2} = Moneyz;     
    HH{4,4,1} = PlayersIn;
    
    
    %3 - Filling players in and moneyz
    FailCount = FailCount + 1;
    for i = 1:6
        if PlayersTemp(i) == 0
            continue
        end
        
        Size1 = size(HH,1);
        for j = 7:Size1
            if isempty(HH{j,i,street}) == 1 || size(HH{j,i,street},2) == 1
                HH{j,i,street} = Moneyz(HH{1,i,1});
            elseif j == Size1
                HH{j+1,1,1} = [];
                HH{j+1,1,1} = Moneyz(HH{1,i,1});
            end
        end      
    end
   
    
    %4 - Stacks
    FailCount = FailCount + 1;
    [Stacks,ErrorMatrix{1,3}]  = GetStacks(HMT, WT, WC, PlayersIn);
    ErrorMatrix{2,3} = Stacks;
    for i = 1:6
        if HH{1,i,1} == 0 || PlayersIn(HH{1,i,1}) == 0
            continue
        else
            HH{2,i,street} = Stacks(HH{1,i,1});
        end
    end     
    
    
    %5 - Pot 
    FailCount = FailCount + 1;
    [HH{3,2,1},ErrorMatrix{3,3}] = GetPotSize(HMT, WT, WC);
    ErrorMatrix(4,3) = HH(3,2,1);    
    
    
    %6 - Filling HH
    FailCount = FailCount + 1;
    ErrorMatrix{4,1} = HH;
    [TH,FillHHError] = FillHH(TH,street);
    ErrorMatrix{5,1} = HH;
    if FillHHError == 1
    %saving if FH has a problem
        disp('FillHH error saved');
        time = clock;
        code = [num2str(time(4)), num2str(time(5)), num2str(uint8(time(5)*10000))];
        FileName = ['D:\OneDrive\Poker\Europe\M Files\Listed\12 Errors\FillHH\FillHH',code,'.mat'];
        save(FileName,'ErrorMatrix');                
    end        
    
    
    %7 - Play the game
    FailCount = FailCount + 1;
    
    
    
    
    
    
    
catch
    %Development:
        
    ErrorMatrix{5,4} = FailCount;
    
    %Regular problem
    disp('caught a problem on PlayPostFlop');
    time = clock;
    code = [num2str(time(4)), num2str(time(5)), num2str(uint8(time(5)*10000))];
    FileName = ['D:\OneDrive\Poker\Europe\M Files\Listed\12 Errors\PlayTable\PlayPostFlop',code,'.mat'];
    save(FileName,'ErrorMatrix');     
end