%                                         PLAY FLOP:  

%Used variables:
ErrorType = 1;
FailCount = 0;


%For recording errors:
ErrorMatrix = cell(5,4);
ErrorMatrix{5,2} = [HMT,WT,WC];
ErrorMatrix{5,3} = StatusMatrix;
%   1st & 2nd:
%1st Column: Players In
%2nd: Moneyz
%3rd: Stacks
%4th: Board

%   3rd & 4th:
%1st: RH & FH
%2nd: Cards
%3rd: Pot
%4th: Dead $

%   5th:
%1st: HH
%2nd: HMT,WT,WC
%3rd: StatusMatrix
%4th: FailCount

try
    %1 - Getting the board & recovering variables
    FailCount = FailCount + 1;
    PlayersTemp = HH{3,4,1}{14,1};  
    ErrorMatrix{3,1} = HH;
    if isempty(HH{3,1,2}) == 1
        %New flop
        [ErrorMatrix{2,4},ErrorMatrix{1,4}] = GetBoard(HMT, WT, WC, 2);
        for i = 1:3
            HH{3,i,2} = ErrorMatrix{2,4}(i); %#ok<*SAGROW>
        end             
        CL = 7;         
    else
        %Further run
        CL = HH{3,4,1}{12,1}; 
    end
    
    
    %2 - PlayersIn & Moneyz
    FailCount = FailCount + 1;
    [PlayersIn,ErrorMatrix{1,1}] = GetIsIn(HMT,WT,WC);
    [Moneyz,ErrorMatrix{1,2}] = GetMoneyz(HMT,WT,WC,1);       
    ErrorMatrix{2,1} = PlayersIn;
    ErrorMatrix{2,2} = Moneyz;       
    
    
    %3 - Filling players in and moneyz
    FailCount = FailCount + 1;
    for i = 1:6
        if PlayersTemp(i) == 0
            continue
        end

        Size1 = size(HH{CL,i},2);
        if Size1 == 8
            if CL == size(HH,1)
                CL = CL + 1;
                HH{CL,1,2} = [];
                HH{CL,i,2} = Moneyz(HH{1,i,1});
            else
                CL = CL + 1;
                HH{CL,i,2} = Moneyz(HH{1,i,1});
            end
        else
            HH{CL,i,2} = Moneyz(HH{1,i,1});
        end

        if PlayersIn(HH{1,i,1}) == 0
            HH{CL,i,2} = 0;
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
            HH{2,i,2} = Stacks(HH{1,i,1});
        end
    end     
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
catch
    
    
    
    
    
    
    
    
    
    
    
    
    
    
end