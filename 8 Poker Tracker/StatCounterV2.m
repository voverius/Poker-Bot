%   StatCounter V2.0 - Creates the PT matrix


%PT variable dimensions
gap = 3;
PTcol = 6;
PTRow = 13;
PlayersIn = ones(1,6);

for i = 1:6
    PlayersIn(i) = i;
end     %Fills from 1 to 6 the positions

for i = 6:-1:1;
    if isnumeric(HH{1,i,1}) == 1
    	PlayersIn(i) = [];
    end
end  %marks which players are out



%_________________________________________________________________________________________________________    
                                           %Beast Mode On
for a = 1:size(PlayersIn,2)
 
    
    %Constructing individual HH Matrix
    j = PlayersIn(a);
    PTpos1 = j;
    
    %Loading variables
    SummaryTemp = HH{5,j,1};
    BB = SummaryTemp{1,6};
    PotSummary = HH{5,j,2};
    Nickname = HH{1,j,1};
    NW = NWMatrix{j,1};
    NWr = size(NW,1);
    HasWon = 0; 
  
    
    %Checking for PT file - saved, existing or new
    New = 0;
    VarNick = NWMatrix{j,2};
    VariableName = ['PT_',VarNick];
    FileName = ['D:\OneDrive\Poker\Europe\PT Files\Work\',VariableName,'.mat'];

    if exist(VariableName,'var') == 1
        PT = eval(VariableName);
    elseif exist(FileName,'file') == 2
        load(FileName);
        PT = eval(VariableName);
    else
        PT = cell(PTRow,PTcol+PTcol*gap);
        PT(:,:) = {0};
        New = 1;
    end    
    
    
    %Checking if won any pots
    for b = 1:size(PotSummary,1)
        if strcmp(Nickname,PotSummary{b,1})
            HasWon = 1;
            break
        end
    end

      


%_________________________________________________________________________________________________________    
                                        WL = 1; %WORKING LINE DEFINED HERE '1'

                                        
    %Nickname input
    if New == 1
        PT(WL,1) = HH(1,j,1);
    end
    
    
    %Hand count
    PT{WL,2} = PT{WL,2} + 1;
    
    
    %Walk Count
    if NW(1,1,1) == 0 && HasWon == 1 %If no further action and won - walked
      PT{WL,3} = PT{WL,3} + 1;    
    end

    
    %BB/100
    PTpos = PTcol + 1;
    if PT{WL,PTpos} == 0
        PT{WL,PTpos}= 'BB/100';  
    end
    if HasWon == 1
        PT{WL,PTpos+1} = PT{WL,PTpos+1} + (HH{2,j,4} - HH{2,j,1} + PotSummary{i,2} - HH{3,j,1})/BB;
    else
        PT{WL,PTpos+1} = PT{WL,PTpos+1} + (HH{2,j,4} - HH{2,j,1} - HH{3,j,1})/BB;
    end

    PT{WL,4} = (PT{WL,PTpos+1}*100)/PT{WL,2};
    PT{WL,PTpos+2}=BB;


    %MoneyWon
    PTpos = PTcol + 1 + gap;
    if PT{WL,PTpos} == 0
        PT{WL,PTpos}= '$$$';
    end
    if HasWon == 1
        PT{WL,PTpos+1} = PT{WL,PTpos+1} + HH{2,j,4} - HH{2,j,1} + PotSummary{i,2} - HH{3,j,1};
    else
        PT{WL,PTpos+1} = PT{WL,PTpos+1} + HH{2,j,4} - HH{2,j,1} - HH{3,j,1};
    end
    
    PT{WL,5} = PT{WL,PTpos+1};
    PT{WL,PTpos+2}=BB;
        

%_________________________________________________________________________________________________________    
                                        WL = WL + 1; %WORKING LINE DEFINED HERE '2'       


    %VP$IP
    PTpos = PTcol + 1;
    if PT{WL,PTpos} == 0
        PT{WL,PTpos} = 'VP$IP';
    end
    if any(NW(:,1,1) == 2) || any(NW(:,1,1) == 3)
        PT{WL,PTpos+1} = PT{WL,PTpos+1} + 1;
    end

    PT{WL,PTpos+2} = PT{1,2} - PT{1,3};
    PT{WL,1} = PT{WL,PTpos+1}*100/PT{WL,PTpos+2};
    
         
    
    %PFR
    PTpos = PTcol + 1 + gap;
    if PT{WL,PTpos} == 0
        PT{WL,PTpos} = 'PFR';   
    end
    if any(NW(:,1,1) == 3)
        PT{WL,PTpos+1} = PT{WL,PTpos+1} + 1;
    end

    PT{WL,PTpos+2} = PT{1,2} - PT{1,3};
    PT{WL,2} = PT{WL,PTpos+1}*100/ PT{WL,PTpos+2};
      
    
                                        
    %Steal Bet (AS)
    if PTpos1 > 4 || PTpos1 == 1
        PTpos = PTcol + 1 + gap*2;
        if PT{WL,PTpos} == 0
            PT{WL,PTpos} = 'AS';
        end
    
        if NW(1,3,1) == 1
          PT{WL,PTpos+2} = PT{WL,PTpos+2} + 1;
        end

        if NW(1,3,1) == 5
            PT{WL,PTpos+2} = PT{WL,PTpos+2} + 1;
            PT{WL,PTpos+1} = PT{WL,PTpos+1} + 1;
        end
              
        if PT{WL,PTpos+1} ~= 0 && PT{WL,PTpos+2} ~= 0
            PT{WL,3} = PT{WL,PTpos+1}*100/ PT{WL,PTpos+2};
        end      
    end
                                        
                                        
                                        
    %FOLD TO BB STEAL (FB)
    if PTpos1 == 2
        PTpos = PTcol + 1 + gap*3;
        if PT{WL,PTpos} == 0
            PT{WL,PTpos} = 'FBS';
        end
    
        if NW(1,3,1) == 5
            PT{WL,PTpos+2} = PT{WL,PTpos+2} + 1;
            if NW(1,1,1) == 1
                PT{WL,PTpos+1} = PT{WL,PTpos+1} + 1;
            end
            PT{WL,4} = PT{WL,PTpos+1}*100/ PT{WL,PTpos+2};
        end  
    end
    
            
    %LIMP-RAISE PERCENTAGE   
    if NWr > 1 && NW(2,1,1) > 0
        PTpos = PTcol + 1 + gap*4;
        if PT{WL,PTpos} == 0
            PT{WL,PTpos} = 'LR';
        end

        if NW(1,2,1) == 1
            PT{WL,PTpos+2} = PT{WL,PTpos+2} + 1;
            if NW(2,1,1) == 3
                PT{WL,PTpos+1} = PT{WL,PTpos+1} + 1;
            end
            PT{WL,5} = PT{WL,PTpos+1}*100/ PT{WL,PTpos+2};
        end
    
    end
            
                
    %LIMP-CALL PERCENTAGE   
    if NWr > 1 && NW(2,1,1) > 0
        PTpos = PTcol + 1 + gap*5;
        if PT{WL,PTpos} == 0
            PT{WL,PTpos} = 'LC'; 
        end

        if NW(1,3,1) < 4
            PT{WL,PTpos+2} = PT{WL,PTpos+2} + 1;
            if NW(2,1,1) == 2
                PT{WL,PTpos+1} = PT{WL,PTpos+1} + 1;
            end
            PT{WL,6} = PT{WL,PTpos+1}*100/ PT{WL,PTpos+2};
        end 
    end
    
    
    
%_________________________________________________________________________________________________________    
                                        WL = WL + 1; %WORKING LINE DEFINED HERE '3'    
 
      
                                 
    %3BET PRE-FLOP  
    if any(NW(:,2,1) > 1)
        PTpos = PTcol + 1;
        if PT{WL,PTpos} == 0
            PT{WL,PTpos} = 'P3B';
        end
        flag = 0;
        NWt = NW(:,1:2,1); %temporary smaller NW matrix to compare with needed result
        NWm = [1 2; 2 2; 3 3]; %results that satisfy the conditions
        for b = 1:NWr
            if NWt(b,1) == 0
                break
            end
            if any(all(bsxfun(@eq, NWt(b,:), NWm),2)==1)
                flag = 1;
                break
            end
        end        

        if flag == 1
            PT{WL,PTpos+2} = PT{WL,PTpos+2} + 1;
            if any(all(bsxfun(@eq, NWt, [3 3]),2)==1)
                PT{WL,PTpos+1} = PT{WL,PTpos+1} + 1;
            end
            PT{WL,1} = PT{WL,PTpos+1}*100/ PT{WL,PTpos+2};
        end
    end
            
                                        
    %FOLD TO 3-BET PRE-FLOP
    if NWr > 1 && NW(2,1,1) > 0
        PTpos = PTcol + 1 + gap;
        if PT{WL,PTpos} == 0
            PT{WL,PTpos} = 'P3F';
        end
        if NW(1,1,1) == 3 && NW(1,2,1) == 2 
            if NW(2,2,1) == 3 || NW(2,1,1) == 3 && NW(2,2,1) == 4
                PT{WL,PTpos+2} = PT{WL,PTpos+2} + 1;
                if NW(2,1,1) == 1
                    PT{WL,PTpos+1} = PT{WL,PTpos+1} + 1;
                end 
                PT{WL,2} = PT{WL,PTpos+1}*100/ PT{WL,PTpos+2};
            end
        end
    end
                                        

    
    %FLOP AGGRESSION FACTOR
    if NW(1,1,2) ~= 0
        PTpos = PTcol + 1 + gap*3;
        if PT{WL,PTpos} == 0
            PT{WL,PTpos} = 'FAF';
        end
        if any(NW(:,1,2) == 2)
            PT{WL,PTpos+2} = PT{WL,PTpos+2} + 1;
        end
        if any(NW(:,1,2) == 3)
            PT{WL,PTpos+1} = PT{WL,PTpos+1} + 1;
        end
        
        if PT{WL,PTpos+1} > 0
           PT{WL,4} = PT{WL,PTpos+1}/ PT{WL,PTpos+2};
        end
    end
            
                                        
                                        
    %TURN AGGRESSION FACTOR
    if NW(1,1,3) ~= 0
        PTpos = PTcol + 1 + gap*4;
        if PT{WL,PTpos} == 0
            PT{WL,PTpos} = 'TAF';
        end
        if any(NW(:,1,3) == 2)
            PT{WL,PTpos+2} = PT{WL,PTpos+2} + 1;
        end
        if any(NW(:,1,3) == 3)
            PT{WL,PTpos+1} = PT{WL,PTpos+1} + 1;
        end
        
        if PT{WL,PTpos+1} > 0
           PT{WL,5} = PT{WL,PTpos+1}/ PT{WL,PTpos+2};
        end
    end                                        
                                        
                                        
                                        
    %RIVER AGGRESSION FACTOR
    if NW(1,1,4) ~= 0
        PTpos = PTcol + 1 + gap*5;
        if PT{WL,PTpos} == 0
            PT{WL,PTpos} = 'RAF';
        end
        if any(NW(:,1,4) == 2)
            PT{WL,PTpos+2} = PT{WL,PTpos+2} + 1;
        end
        if any(NW(:,1,4) == 3)
            PT{WL,PTpos+1} = PT{WL,PTpos+1} + 1;
        end
        
        if PT{WL,PTpos+1} > 0
           PT{WL,6} = PT{WL,PTpos+1}/ PT{WL,PTpos+2};
        end
    end                                        
                                        
                                        
                                        
    %TOTAL AGGRESSION FACTOR
    if NW(1,1,2)~=0
        PTpos = PTcol + 1 + gap*2;
        if PT{WL,PTpos} == 0
            PT{WL,PTpos} = 'AF';   
        end

        PT{WL,PTpos+1} = PT{WL,PTpos+4} + PT{WL,PTpos+7} + PT{WL,PTpos+10};
        PT{WL,PTpos+2} = PT{WL,PTpos+5} + PT{WL,PTpos+8} + PT{WL,PTpos+11};

        if PT{WL,PTpos+1} > 0
            PT{WL,3} = PT{WL,PTpos+1} / PT{WL,PTpos+2};
        end   
    end
    
    
    
%_________________________________________________________________________________________________________    
                                        WL = WL + 1; %WORKING LINE DEFINED HERE '4'   
 
            
                                        
    %PRE-FLOP CALL 2BET/SBET/IBET
    if any(NW(:,2,1) > 1)
        PTpos = PTcol + 1;
        if PT{WL,PTpos} == 0
            PT{WL,PTpos} = 'P2C';
        end
        flag = 0;
        NWt = NW(:,1:2,1);
        NWm = [1 2; 2 2; 3 3];                                        
        for b = 1:NWr
            if NWt(b,1) == 0
                break
            end
            if any(all(bsxfun(@eq, NWt(b,:), NWm),2)==1)
                flag = 1;
                break
            end
        end 

        if flag == 1
            PT{WL,PTpos+2} = PT{WL,PTpos+2} + 1;
            if any(all(bsxfun(@eq, NWt, [2 2]),2)==1)
                PT{WL,PTpos+1} = PT{WL,PTpos+1} + 1;
            end
            PT{WL,1} = PT{WL,PTpos+1}*100/ PT{WL,PTpos+2};
        end 
    end
          
    
    
    %Steal 3Bet (S3B)
    if PTpos1 == 2 && NW(1,3,1) == 5
        PTpos = PTcol + 1 + gap;
        if PT{WL,PTpos} == 0
            PT{WL,PTpos} = 'S3B';
        end
        
        PT{WL,PTpos+2} = PT{WL,PTpos+2} + 1;
        if NW(1,1,1) == 3
            PT{WL,PTpos+1} = PT{WL,PTpos+1} + 1;
        end
        PT{WL,2} = PT{WL,PTpos+1}*100/ PT{WL,PTpos+2};
    end
    
    
    %FOLD TO ANY 3-BET PRE-FLOP
    if any(NW(:,2,1) > 2)
        PTpos = PTcol + 1 + gap*2;
        if PT{WL,PTpos} == 0
            PT{WL,PTpos} = '3BF';
        end
        flag = 0;
        NWt = NW(:,1:2,1);
        NWm = [1 3; 2 3; 3 4];
        for b = 1:NWr
            if NWt(b,1) == 0
                break
            end
            if any(all(bsxfun(@eq, NWt(b,:), NWm),2)==1)
                flag = 1;
                break
            end
        end     

        if flag == 1
            PT{WL,PTpos+2} = PT{WL,PTpos+2} + 1;
            if any(all(bsxfun(@eq, NWt, [1 3]),2)==1)
                PT{WL,PTpos+1} = PT{WL,PTpos+1} + 1;
            end
            PT{WL,3} = PT{WL,PTpos+1}*100/ PT{WL,PTpos+2};
        end    
    end
        
        
    %4BET PRE-FLOP
    if any(NW(:,2,1) > 2)
        PTpos = PTcol + 1 + gap*3;
        if PT{WL,PTpos} == 0
            PT{WL,PTpos} = 'P4B';
        end
        flag = 0;
        NWt = NW(:,1:2,1);
        NWm = [1 3; 2 3; 3 4];                                        
        for b = 1:NWr
            if NWt(b,1) == 0
                break
            end
            if any(all(bsxfun(@eq, NWt(b,:), NWm),2)==1)
                flag = 1;
                break
            end
        end 

        if flag == 1
            PT{WL,PTpos+2} = PT{WL,PTpos+2} + 1;
            if any(all(bsxfun(@eq, NWt, [3 4]),2)==1)
                PT{WL,PTpos+1} = PT{WL,PTpos+1} + 1;
            end
            PT{WL,4} = PT{WL,PTpos+1}*100/ PT{WL,PTpos+2};
        end   
    end
        
        
    %4+BET PRE-FLOP
    if any(NW(:,2,1) > 3)
        PTpos = PTcol + 1 + gap*4;
        if PT{WL,PTpos} == 0
            PT{WL,PTpos} = '4+B';
        end
        for b = NWr:-1:1
            if NW(b,1,1) > 0
                PT{WL,PTpos+2} = PT{WL,PTpos+2} + 1;
                if NW(b,1,1) == 3
                    PT{WL,PTpos+1} = PT{WL,PTpos+1} + 1;
                end
                PT{WL,5} = PT{WL,PTpos+1}*100/ PT{WL,PTpos+2};
                break
            end
        end
    end
                    
                
    %4+FOLD PRE-FLOP
    if any(NW(:,2,1) > 3)
        PTpos = PTcol + 1 + gap*5;
        if PT{WL,PTpos} == 0
            PT{WL,PTpos} = '4+F';
        end
        for b = NWr:-1:1
            if NW(b,1,1) > 0
                PT{WL,PTpos+2} = PT{WL,PTpos+2} + 1;
                if NW(b,1,1) == 1
                    PT{WL,PTpos+1} = PT{WL,PTpos+1} + 1;
                end
                PT{WL,6} = PT{WL,PTpos+1}*100/ PT{WL,PTpos+2};
                break
            end
        end
    end
     
                                        
%_________________________________________________________________________________________________________    
                                        WL = WL + 1; %WORKING LINE DEFINED HERE '5'  
                                        
                                        
          
    %LIMP   DOESN'T TAKE INTO ACCOUNT FOR BB
    if NW(1,2,1) == 1 && NW(1,1,1) ~= 4 ||  NW(1,1,1) == 3 && NW(1,2,1) == 2  
   
        PTpos = PTcol + 1;
        if PT{WL,PTpos} == 0
            PT{WL,PTpos} = 'LIMP';
        end

        PT{WL,PTpos+2} = PT{WL,PTpos+2} + 1;
        if NW(1,1,1) == 2
            PT{WL,PTpos+1} = PT{WL,PTpos+1} + 1;
        end
        PT{WL,1} = PT{WL,PTpos+1}*100/ PT{WL,PTpos+2};
    end

    
    %PRE-FLOP OPEN RAISE 
    if NW(1,2,1) == 1 || NW(1,1,1) == 3 && NW(1,2,1) == 2
   
        PTpos = PTcol + 1 + gap;
        if PT{WL,PTpos} == 0
            PT{WL,PTpos} = 'P2B';
        end

        PT{WL,PTpos+2} = PT{WL,PTpos+2} + 1;
        if NW(1,1,1) == 3
            PT{WL,PTpos+1} = PT{WL,PTpos+1} + 1;
        end
        PT{WL,2} = PT{WL,PTpos+1}*100/PT{WL,PTpos+2};
    end
            
    
    %ISOLATION BET 
    if NW(1,3,1) == 2 || NW(1,1,1) == 3 && NW(1,3,1) == 6 
        PTpos = PTcol + 1 + gap*2;
        if PT{WL,PTpos} == 0
            PT{WL,PTpos} = 'IB';
        end

        PT{WL,PTpos+2} = PT{WL,PTpos+2} + 1;
        if NW(1,1,1) == 3
            PT{WL,PTpos+1} = PT{WL,PTpos+1} + 1;
        end
        PT{WL,3} = PT{WL,PTpos+1}*100/ PT{WL,PTpos+2};
    end
        
        
    %LIMP WITH LIMPERS BEHIND           DOESN'T TAKE INTO ACCOUNT FOR BB
    if NW(1,3,1) == 2 || NW(1,3,1) == 3 ||... %LIMP/OPEN FOLD
       NW(1,1,1) == 3 && NW(1,2,1) == 2 && NW(1,3,1) == 4 ||... %OPEN RAISE
       NW(1,1,1) == 3 && NW(1,3,1) == 6       %ISO RAISE
   
        PTpos = PTcol + 1 + gap*3;
        if PT{WL,PTpos} == 0
            PT{WL,PTpos} = '1+L';
        end

        if NW(1,3,1) == 4
            if (NW(1,7,1)/NW(1,6,1)) >= 2.5 % In case open raises with no limpers
                PT{WL,PTpos+2} = PT{WL,PTpos+2} + 1;
            end
        else
            PT{WL,PTpos+2} = PT{WL,PTpos+2} + 1;
            if NW(1,1,1) == 2
                PT{WL,PTpos+1} = PT{WL,PTpos+1} + 1;
            end
        end

        if PT{WL,PTpos+1} ~= 0 &&  PT{WL,PTpos+2} ~= 0 
            PT{WL,4} = PT{WL,PTpos+1}*100/ PT{WL,PTpos+2};
        end
    end %this stat might be unused in PTpf

    
    
    %FOLD AFTER VPIP
    if NWr > 1 && NW(2,1,1) ~= 0
        PTpos = PTcol + 1 + gap*4;
        if PT{WL,PTpos} == 0
            PT{WL,PTpos} = 'FAV';  
        end
        
        PT{WL,PTpos+2} = PT{WL,PTpos+2} + 1;
        if any(NW(:,1,1) == 1)
            PT{WL,PTpos+1} = PT{WL,PTpos+1} + 1;
        end
        PT{WL,5} = PT{WL,PTpos+1}*100/ PT{WL,PTpos+2};
    end
            

    
%_________________________________________________________________________________________________________    
                                        WL = WL + 1; %WORKING LINE DEFINED HERE '6' 
                                        
           
    %P2B FOR EVERY STREET
    if PT{WL,7} == 0
        PT{WL,7}  = 'S_P2B';
        PT{WL,10} = 'B_P2B';
        PT{WL,13} = 'U_P2B';
        PT{WL,16} = 'M_P2B';
        PT{WL,19} = 'C_P2B';
        PT{WL,22} = 'D_P2B';
    end
    if NW(1,2,1) == 1 || NW(1,1,1) == 3 && NW(1,2,1) == 2
        PTpos = PTcol + 1 + (PTpos1-1)*gap;
        PT{WL,PTpos+2} = PT{WL,PTpos+2} + 1;
        if NW(1,1,1) == 3
            PT{WL,PTpos+1} = PT{WL,PTpos+1} + 1;
        end
        PT{WL,PTpos1} = PT{WL,PTpos+1}*100/ PT{WL,PTpos+2};
    end

    
    
%_________________________________________________________________________________________________________    
                                        WL = WL + 1; %WORKING LINE DEFINED HERE '7' 
                                        
             
    %LIMP FOR EVERY STREET   
    if PT{WL,7} == 0
        PT{WL,7}  = 'S_LIMP';
        PT{WL,10} = 'B_LIMP';
        PT{WL,13} = 'U_LIMP';
        PT{WL,16} = 'M_LIMP';
        PT{WL,19} = 'C_LIMP';
        PT{WL,22} = 'D_LIMP';
    end    
    if NW(1,2,1) == 1 || NW(1,1,1) == 3 && NW(1,2,1) == 2
        PTpos = PTcol + 1 + (PTpos1-1)*gap;
        PT{WL,PTpos+2} = PT{WL,PTpos+2} + 1;
        if NW(1,1,1) == 2 || PTpos1 == 2 && NW(1,1,1) == 4
            PT{WL,PTpos+1} = PT{WL,PTpos+1} + 1;
        end
        PT{WL,PTpos1} = PT{WL,PTpos+1}*100/ PT{WL,PTpos+2};
    end
  
    
    
%_________________________________________________________________________________________________________    
                                        WL = WL + 1; %WORKING LINE DEFINED HERE '8' 
                                        
       
        
    %CALL AN OPENING-RAISE PRE-FLOP  
    if PT{WL,7} == 0
        PT{WL,7}  = 'S_P2C';
        PT{WL,10} = 'B_P2C';
        PT{WL,13} = 'U_P2C';
        PT{WL,16} = 'M_P2C';
        PT{WL,19} = 'C_P2C';
        PT{WL,22} = 'D_P2C';
    end     
    if any(NW(:,2,1)>1)
        PTpos = PTcol + 1 + (PTpos1-1)*gap;

        flag = 0;
        NWt = NW(:,1:2,1);
        NWm = [1 2; 2 2; 3 3];
        for b = 1:NWr
            if NWt(b,1) == 0
                break
            end
            if any(all(bsxfun(@eq, NWt(b,:), NWm),2)==1)
                flag = 1;
                break
            end
        end

        if flag == 1
            PT{WL,PTpos+2} = PT{WL,PTpos+2} + 1;
            if any(all(bsxfun(@eq, NWt, [2 2]),2)==1)
                PT{WL,PTpos+1} = PT{WL,PTpos+1} + 1;
            end
            PT{WL,PTpos1} = PT{WL,PTpos+1}*100/ PT{WL,PTpos+2};
        end            
    end
    
    
    
%_________________________________________________________________________________________________________    
                                        WL = WL + 1; %WORKING LINE DEFINED HERE '9'    
 
                                 
    %3BET PRE-FLOP  
    if PT{WL,7} == 0
        PT{WL,7}  = 'S_3B';
        PT{WL,10} = 'B_3B';
        PT{WL,13} = 'U_3B';
        PT{WL,16} = 'M_3B';
        PT{WL,19} = 'C_3B';
        PT{WL,22} = 'D_3B';
    end 
    if any(NW(:,2,1) > 1)
        PTpos = PTcol + 1 + (PTpos1-1)*gap;
        flag = 0;
        NWt = NW(:,1:2,1); 
        NWm = [1 2; 2 2; 3 3];
        for b = 1:NWr
            if NWt(b,1) == 0
                break
            end
            if any(all(bsxfun(@eq, NWt(b,:), NWm),2)==1)
                flag = 1;
                break
            end
        end        

        if flag == 1
            PT{WL,PTpos+2} = PT{WL,PTpos+2} + 1;
            if any(all(bsxfun(@eq, NWt, [3 3]),2) == 1)
                PT{WL,PTpos+1} = PT{WL,PTpos+1} + 1;
            end
            PT{WL,PTpos1} = PT{WL,PTpos+1}*100/ PT{WL,PTpos+2};
        end
    end
    
    
    
%_________________________________________________________________________________________________________    
                                        WL = WL + 1; %WORKING LINE DEFINED HERE '10'        
    
    
    %FOLD TO 3-BET PRE-FLOP
    if PT{WL,7} == 0
        PT{WL,7}  = 'S_F3B';
        PT{WL,10} = 'B_F3B';
        PT{WL,13} = 'U_F3B';
        PT{WL,16} = 'M_F3B';
        PT{WL,19} = 'C_F3B';
        PT{WL,22} = 'D_F3B';
    end 
    if NWr > 1 && NW(2,1,1) > 0
        PTpos = PTcol + 1 + (PTpos1-1)*gap;
        if NW(1,1,1) == 3 && NW(1,2,1) == 2 
            if NW(2,2,1) == 3 || NW(2,1,1) == 3 && NW(2,2,1) == 4
                PT{WL,PTpos+2} = PT{WL,PTpos+2} + 1;
                if NW(2,1,1) == 1
                    PT{WL,PTpos+1} = PT{WL,PTpos+1} + 1;
                end 
                PT{WL,PTpos1} = PT{WL,PTpos+1}*100/ PT{WL,PTpos+2};
            end
        end
    end    
                                        
                                        
    
%_________________________________________________________________________________________________________    
                                        WL = WL + 1; %WORKING LINE DEFINED HERE '11'    
                                        
                                        
    
    %FLOP CONTINUATION BET
    %!!!!!!!!!!!!!!!!!!consider adding a re-raise as a CBET (2Bet CBet)!!!!!!!!!!!!!!!!!!   
    if NW(1,1,2) > 2
        PTpos = PTcol + 1;
        if PT{WL,PTpos} == 0
            PT{WL,PTpos} = 'FCB';   
        end
        if NW(1,3,2) == 8
            PT{WL,PTpos+2} = PT{WL,PTpos+2} + 1;
            if NW(1,1,2) == 3
                PT{WL,PTpos+1} = PT{WL,PTpos+1} + 1;
            end
            PT{WL,1} = PT{WL,PTpos+1}*100/ PT{WL,PTpos+2};
        end
    end
        
            
    %TURN CONTINUATION BET
    if NW(1,1,3) > 2
        PTpos = PTcol + 1 + gap;
        if PT{WL,PTpos} == 0
            PT{WL,PTpos} = 'TCB';   
        end
        if NW(1,3,3) == 8 
            PT{WL,PTpos+2} = PT{WL,PTpos+2} + 1;
            if NW(1,1,3) == 3
                PT{WL,PTpos+1} = PT{WL,PTpos+1} + 1;
            end
            PT{WL,2} = PT{WL,PTpos+1}*100/ PT{WL,PTpos+2};
        end 
    end
        
    
    %FLOP CONTINUATION FOLD
    if NW(1,1,2) ~= 0
        PTpos = PTcol + 1 + gap*2;
        if PT{WL,PTpos} == 0
            PT{WL,PTpos} = 'FCF';
        end
        flag = 0;
        NWt = NW(:,1:3,2);
        NWm = [1 1 8;2 1 8; 3 2 10];
        for b = 1:NWr
            if NWt(b,1) == 0
                break
            end
            if any(all(bsxfun(@eq, NWt(b,:), NWm),2)==1)
                flag = 1;
                break
            end
        end

        if flag == 1
             PT{WL,PTpos+2} = PT{WL,PTpos+2} + 1;
             if any(all(bsxfun(@eq, NWt, [1 1 8]),2)==1)
                 PT{WL,PTpos+1} = PT{WL,PTpos+1} + 1;
             end
             PT{WL,3} = PT{WL,PTpos+1}*100/ PT{WL,PTpos+2};
        end
    end
         
         
    %TURN CONTINUATION FOLD
    if NW(1,1,3) ~= 0
        PTpos = PTcol + 1 + gap*3;
        if PT{WL,PTpos} == 0
            PT{WL,PTpos} = 'TCF';
        end
        flag = 0;
        NWt = NW(:,1:3,3);
        NWm = [1 1 8;2 1 8; 3 2 10];
        for b = 1:NWr
            if NWt(b,1) == 0
                break
            end
            if any(all(bsxfun(@eq, NWt(b,:), NWm),2)==1)
                flag = 1;
                break
            end
        end

        if flag == 1
             PT{WL,PTpos+2} = PT{WL,PTpos+2} + 1;
             if any(all(bsxfun(@eq, NWt, [1 1 8]),2)==1)
                 PT{WL,PTpos+1} = PT{WL,PTpos+1} + 1;
             end
             PT{WL,4} = PT{WL,PTpos+1}*100/ PT{WL,PTpos+2};
        end        
    end
        
%_________________________________________________________________________________________________________    
                                        WL = WL + 1; %WORKING LINE DEFINED HERE '12'        
    

    %FLOP CHECK-RAISE 
    if NWr > 1
        PTpos = PTcol + 1;
        if PT{WL,PTpos} == 0
            PT{WL,PTpos} = 'FCR';
        end
        if NW(2,1,2) > 0 && NW(1,1,2) == 4
            PT{WL,PTpos+2} = PT{WL,PTpos+2} + 1;
            if NW(2,1,2) == 3
                PT{WL,PTpos+1} = PT{WL,PTpos+1} + 1;
            end
            PT{WL,1} = PT{WL,PTpos+1}*100/ PT{WL,PTpos+2};
        end
    end
        
        
    %TURN CHECK-RAISE
    if NWr > 1
        PTpos = PTcol + 1 + gap;
        if PT{WL,PTpos} == 0
            PT{WL,PTpos} = 'TCR';
        end
        if NW(2,1,3) > 0 && NW(1,1,3) == 4
            PT{WL,PTpos+2} = PT{WL,PTpos+2} + 1;
            if NW(2,1,3) == 3
                PT{WL,PTpos+1} = PT{WL,PTpos+1} + 1;
            end
            PT{WL,2} = PT{WL,PTpos+1}*100/ PT{WL,PTpos+2};
        end     
    end
        
        
    %RIVER CHECK-RAISE 
    if NWr > 1
        PTpos = PTcol + 1 + gap*2;
        if PT{WL,PTpos} == 0
            PT{WL,PTpos} = 'RCR';
        end
        if NW(2,1,4) > 0 && NW(1,1,4) == 4
            PT{WL,PTpos+2} = PT{WL,PTpos+2} + 1;
            if NW(2,1,4) == 3
                PT{WL,PTpos+1} = PT{WL,PTpos+1} + 1;
            end
            PT{WL,3} = PT{WL,PTpos+1}*100/ PT{WL,PTpos+2};
        end    
    end
        
    
    %FLOP CHECK-FOLD 
    if NWr > 1
        PTpos = PTcol + 1 + gap*3;
        if PT{WL,PTpos} == 0
            PT{WL,PTpos} = 'FCxF';
        end
        if NW(2,1,2) > 0 && NW(1,1,2) == 4
            PT{WL,PTpos+2} = PT{WL,PTpos+2} + 1;
            if NW(2,1,2) == 1
                PT{WL,PTpos+1} = PT{WL,PTpos+1} + 1;
            end
            PT{WL,4} = PT{WL,PTpos+1}*100/ PT{WL,PTpos+2};
        end    
    end
        
        
    %TURN CHECK-FOLD 
    if NWr > 1
        PTpos = PTcol + 1 + gap*4;
        if PT{WL,PTpos} == 0
            PT{WL,PTpos} = 'TCxF';
        end
        if NW(2,1,3) > 0 && NW(1,1,3) == 4
            PT{WL,PTpos+2} = PT{WL,PTpos+2} + 1;
            if NW(2,1,3) == 1
                PT{WL,PTpos+1} = PT{WL,PTpos+1} + 1;
            end
            PT{WL,5} = PT{WL,PTpos+1}*100/ PT{WL,PTpos+2};
        end        
    end
        
        
    %RIVER CHECK-FOLD 
    if NWr > 1
        PTpos = PTcol + 1 + gap*5;
        if PT{WL,PTpos} == 0
            PT{WL,PTpos} = 'RCxF';
        end
        if NW(2,1,4) > 0 && NW(1,1,4) == 4
            PT{WL,PTpos+2} = PT{WL,PTpos+2} + 1;
            if NW(2,1,4) == 1
                PT{WL,PTpos+1} = PT{WL,PTpos+1} + 1;
            end
            PT{WL,6} = PT{WL,PTpos+1}*100/ PT{WL,PTpos+2};
        end      
    end
                                        
                                
 %_________________________________________________________________________________________________________    
                                        WL = WL + 1; %WORKING LINE DEFINED HERE '13'             
                                        
           
	%WIN MONEY WHEN SEE FLOP
    if NW(1,1,2) ~= 0
        PTpos = PTcol + 1;
        if PT{WL,PTpos} == 0
            PT{WL,PTpos} = 'W$F'; 
        end
        
        PT{WL,PTpos+2} = PT{WL,PTpos+2} + 1;
        if HasWon == 1
            PT{WL,PTpos+1} = PT{WL,PTpos+1} + 1;
        end

        if PT{WL,PTpos+1} ~= 0 && PT{WL,PTpos+2} ~= 0 
            PT{WL,1} = PT{WL,PTpos+1}*100/ PT{WL,PTpos+2};
        end   
    end
         
         
	%WENT TO SHOWDOWN 
    if NW(1,1,2) ~= 0
        PTpos = PTcol + 1 + gap;
        if PT{WL,PTpos} == 0
            PT{WL,PTpos} = 'WtS';
        end

        if strcmp(SummaryTemp{1,7}, 'Y')
            PT{WL,PTpos+1} = PT{WL,PTpos+1} + 1;
            PT{WL,PTpos+2} = PT{WL,PTpos+2} + 1;
        elseif NW(1,1,2) ~= 0
            PT{WL,PTpos+2} = PT{WL,PTpos+2} + 1;
        end

        if PT{WL,PTpos+1} ~= 0 &&  PT{WL,PTpos+2} ~= 0 
            PT{WL,2} = PT{WL,PTpos+1}*100/ PT{WL,PTpos+2};
        end
    end
    
            
    %WIN MONEY AT SHOWDOWN           
    PTpos = PTcol + 1 + gap*2;
    if PT{WL,PTpos} == 0
        PT{WL,PTpos} = 'W$S';
    end
            
    if strcmp(SummaryTemp{1,7}, 'Y') == 1; 

        PT{WL,PTpos+2} = PT{WL,PTpos+2} + 1;
        if HasWon == 1
           PT{WL,PTpos+1} = PT{WL,PTpos+1} + 1; 
        end
        PT{WL,3} = PT{WL,PTpos+1}*100/ PT{WL,PTpos+2};            
    end             

  
%_________________________________________________________________________________________________________    
                                        %The end of Stat Counter.   
        
 
   
%For keeping track of updated PT_* variables 
NickNameSummary{(size(NickNameSummary,1)+1),1} = VariableName; %#ok<SAGROW>


%Transfering from PT to PT_*
eval(['PT_' VarNick ' = PT;']);

PlayerCount = PlayerCount +1;
end
