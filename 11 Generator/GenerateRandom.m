%function gs = GenerateRandom


gs = cell(8,6);
ssc = 0.2; %This is the chance that the player is Short Stacked
AllCards = uint8([21 22 23 24 31 32 33 34 41 42 43 44 51 52 53 54 61 62 63 64 71 72 73 74 81 82 83 84 91 92 93 94 101 102 103 104 111 112 113 114 121 122 123 124 131 132 133 134 141 142 143 144]);
NOP = 6; %Change for random situations?
CH = zeros(1,2); %Atual Cards Held (CH)
temp = cell(1,5); %This will be used to create temporary cell for action matrix
gs(5,:) = {0};
BET = 1;
SBET = 0;
IBET = 0;
CBET = 0;
LimpCount = 0;
IsIn = [ 1 1 1 1 1 1 ];
Eq = [ 0 0 0 0 0 0 ];
AI = [ 2 2 2 2 2 2 ];
AIp = 0;
IP = 0;



%___________________________________________________________________________________________________________
                                                %FILLING NAMES
gs{1,1} = 'Small Blind';
gs{1,2} = 'Big Blind';
gs{1,3} = 'UTG';
gs{1,4} = 'Middle';
gs{1,5} = 'Cut-Off';
gs{1,6} = 'Button';

Hpos = randi(6); % Gives a random position to the Hero
gs{1,Hpos} = 'Metaliuga';


%___________________________________________________________________________________________________________
                                                %FILLING STACKS
for i = 1:6
    
    if i == Hpos
        gs{2,i} = 100;
    elseif rand >= ssc
        gs{2,i} = 100;
    else
        gs{2,i} = 50;
    end
end

%___________________________________________________________________________________________________________
                                                %FILLING CARDS
                                                
gs(3,:) = {CH};                                                

for i = 1:2
    for j = 1:NOP
        
        DealtCard = AllCards(randi(size(AllCards,2)));
        AllCards = AllCards(AllCards ~= DealtCard);
        
        CH = gs{3,j};
        CH(1,i) = DealtCard;
        gs{3,j} = CH;
    end
end

for i = 1:6
    CHs = CtR(gs{3,i});
    gs{4,i} = CHs;
end



%___________________________________________________________________________________________________________
                                                %FILLING BLINDS


%SMALL BLIND

    temp{1,1} = 'SB'; %Action
    temp{1,2} = 0.5; %Moneyz Put In Front
    temp{1,3} = 0; %Current Bet On the Table
    temp{1,4} = 0; %Total Pot
    temp{1,5} = gs{2,1}; %Stack BEFOOOOORE Making the action
    gs{2,1} = gs{2,1} - temp{1,2};
    gs{7,1} = temp;
    gs{5,1} = temp{1,2};


%BIG BLIND

    temp{1,1} = 'BB';
    temp{1,2} = 1; 
    temp{1,3} = 0.5;
    temp{1,4} = 0.5;
    temp{1,5} = gs{2,2};
    gs{2,2} = gs{2,2} - temp{1,2};
    
    gs{7,2} = temp;
    gs{5,2} = temp{1,2};

    RoundBet = 1;
    POT = 1.5;
    
    
%___________________________________________________________________________________________________________
                                                %FILLING PLAYERS
                                               
for i = 1:6
    
    if strcmp('Metaliuga',gs{1,i})
        continue
    end
    
    gs{6,i} = RandomPT;
end



%___________________________________________________________________________________________________________
                                                %FILLING ACTIONS
                                                
                                                
%Creating a matrix for game status
GameStatus = cell(11,2);
GameStatus(1:size(GameStatus,1),1) = {0};
GameStatus{1,2}  = 'Limp Count';
GameStatus{2,2}  = 'BET';
GameStatus{3,2}  = 'Steal Bet';
GameStatus{4,2}  = 'Iso Bet';
GameStatus{5,2}  = 'Continuation Bet';
GameStatus{6,2}  = 'Pot Size';
GameStatus{7,2}  = 'Round Bet';
GameStatus{8,2}  = 'Original Raise';
GameStatus{9,2}  = 'Last Raise';
GameStatus{10,2} = 'All-in Status';
GameStatus{11,2} = 'In-Position Status';

        

flag = 0;
j = 7; %Game Line / Betting line
while flag == 0
    for i = 1:6
        
        GameStatus{1,1} = LimpCount;
        GameStatus{2,1} = BET;
        GameStatus{3,1} = SBET;
        GameStatus{4,1} = IBET;
        GameStatus{5,1} = CBET;
        GameStatus{6,1} = POT;
        GameStatus{7,1} = RoundBet;
        gs{6,Hpos} = GameStatus;        

        if any(AI == 1)
            IsInt = IsIn;
            IsInt = IsInt(IsInt == AI);
            
            if size(IsInt,2) == 1
                AIp = 1;
                GameStatus{10,1} = AIp;
                gs{6,Hpos} = GameStatus;
            end
        end
        
        
        if Hpos ~= 6 && sum(IsIn((Hpos+1):6)) == 0
            IP = 1;
            GameStatus{11,1} = IP;
        end
        
        
        if SBET == 1 && i == 2 && sum(IsIn) > 2
            SBET = 0;
        end
            
 
        if (j == 7 && i == 1) || (j == 7 && i == 2)
            continue
        elseif Eq(i) == BET || (BET == 1 && all(Eq == 0) && i == 2)
            flag = 1;
            break  
        elseif IsIn(i) == 0 || AI(i) == 1
            continue            
        elseif i == Hpos
            %temporary for development
            gs = ModifyRandom(gs);
            flag = 1;
            break
            gs = Gpf(gs);
            
            if strfind(gs{j,i}{1,1}, 'FOLD')
                IsIn(i) = 0;
                continue 
            elseif  size(strfind(gs{j,i}{1,1}, 'BET'),1) > 0 || size(strfind(gs{j,i}{1,1}, 'CALL'),1) > 0 ||...
                    size(strfind(gs{j,i}{1,1}, 'CHECK'),1) > 0 || size(strfind(gs{j,i}{1,1}, 'LIMP'),1) > 0
                
                LimpCount = gs{6,i}{1,1};
                BET = gs{6,i}{2,1};
                SBET = gs{6,i}{3,1};
                IBET = gs{6,i}{4,1};
                POT = gs{6,i}{6,1};
                RoundBet = gs{6,i}{7,1};
                AIp = gs{6,i}{10,1};
                
                Eq(i) = BET;
                
                
                if size(strfind(gs{j,i}{1,1}, 'ABET'),1) > 0
                    
                    AI(i) = 1;
                    GameStatus{9,1} = i;
                    if GameStatus{8,1} == 0
                        GameStatus{8,1} = 1;
                    end
                elseif size(strfind(gs{j,i}{1,1}, 'BET'),1) > 0
                    
                    GameStatus{9,1} = i;
                    if GameStatus{8,1} == 0
                        GameStatus{8,1} = 1;
                    end                    
                end
                
                continue 
            end
        
        end

        PT = gs{6,i};
        %CCp = WhichPercentile(gs{4,i});
        CCp = WPm(gs{4,i});
        
        if j > 8
             gs{j,1} = [];
        end        
        
%______________________________________________________________________________________________________________          
%______________________________________________________________________________________________________________            
        if BET == 1                                  %RAISE MOVES
                                                 
            if LimpCount == 0
                
                %STEAL BET
                if PT{2,3} > CCp && (i >= 5 || i == 1)%

                    temp{1,1} = 'SBET';
                    temp{1,2} = 3*RoundBet; 
                    temp{1,3} = RoundBet;
                    temp{1,4} = POT;
                    temp{1,5} = gs{2,i};

                    gs{j,i} = temp;
                    gs{2,i} = gs{2,i} - temp{1,2} + gs{5,1};

                    POT = POT + temp{1,2} - gs{5,i};
                    gs{5,i} = temp{1,2};
                    RoundBet = temp{1,2};
                    BET = BET + 1;
                    Eq(i) = BET;
                    SBET = 1;
                    GameStatus{8,1} = i;
                    GameStatus{9,1} = i;
                    continue
                
                %OPEN RAISE
                elseif PT{6,i} > CCp%

                    temp{1,1} = '2BET';
                    temp{1,2} = 3*RoundBet; 
                    temp{1,3} = RoundBet;
                    temp{1,4} = POT;
                    temp{1,5} = gs{2,i};

                    gs{j,i} = temp;
                    gs{2,i} = gs{2,i} - temp{1,2} + gs{5,i};

                    POT = POT + temp{1,2} - gs{5,i};
                    gs{5,i} = temp{1,2};
                    RoundBet = temp{1,2};
                    BET = BET + 1;
                    Eq(i) = BET;
                    GameStatus{8,1} = i;
                    GameStatus{9,1} = i;
                    continue
                
                end
                
                
            elseif LimpCount == 1
                
                %ISOLATION RAISE
                if PT{5,3} > CCp%

                    temp{1,1} = 'IBET';
                    temp{1,2} = 3*RoundBet; 
                    temp{1,3} = RoundBet;
                    temp{1,4} = POT;
                    temp{1,5} = gs{2,i};

                    gs{j,i} = temp;
                    gs{2,i} = gs{2,i} - temp{1,2} + gs{5,i};

                    POT = POT + temp{1,2} - gs{5,i};
                    gs{5,i} = temp{1,2};
                    RoundBet = temp{1,2};
                    BET = BET + 1;
                    Eq(i) = BET;
                    IBET = 1;
                    GameStatus{8,1} = i;
                    GameStatus{9,1} = i;
                    continue
                
                end
                
            elseif LimpCount > 1
                
                %OPEN - RAISE WITH LIMPERS IN
                if PT{6,i} > CCp%

                    temp{1,1} = '2BET';
                    temp{1,2} = 4*RoundBet; 
                    temp{1,3} = RoundBet;
                    temp{1,4} = POT;
                    temp{1,5} = gs{2,i};

                    gs{j,i} = temp;
                    gs{2,i} = gs{2,i} - temp{1,2} + gs{5,i};

                    POT = POT + temp{1,2} - gs{5,i};
                    gs{5,i} = temp{1,2};
                    RoundBet = temp{1,2};
                    BET = BET + 1;
                    Eq(i) = BET;
                    GameStatus{8,1} = i;
                    GameStatus{9,1} = i;
                    continue

                end  
            end
            
            
%______________________________________________________________________________________________________________            
                                                 %CALL MOVES
                                                 
                                                 
            if cellfun(@isempty, gs(j,i))
                
                %LIMP (NOT BLINDS)
                if (PT{6,i} + PT{7,i}) > CCp% 
                    
                    if i == 2
                        if LimpCount == 1
                            temp{1,1} = 'bCHECK';
                        else
                            temp{1,1} = 'cCHECK';
                        end
                    elseif LimpCount == 0
                        temp{1,1} = 'aLIMP';
                    elseif LimpCount == 1
                        temp{1,1} = 'bLIMP';
                    else
                        temp{1,1} = 'cLIMP';
                    end
                    
                    temp{1,2} = RoundBet - gs{5,i};
                    temp{1,3} = RoundBet;
                    temp{1,4} = POT;
                    temp{1,5} = gs{2,i};
                    gs{j,i} = temp;
                    
                    gs{5,i} = RoundBet;
                    gs{2,i} = gs{2,i} - temp{1,2};

                    POT = POT + temp{1,2};
                    LimpCount = LimpCount + 1;
                    Eq(i) = BET;
                    continue
                   
%                 %LIMP SMALL BLIND    
%                 elseif i == 1 && (PT{5,1} > CCp || PT{7,1} > CCp)
%                     
%                     if LimpCount == 0
%                         temp{1,1} = 'aLIMP';
%                     elseif LimpCount == 1
%                         temp{1,1} = 'bLIMP';
%                     else
%                         temp{1,1} = 'cLIMP';
%                     end
%                     
%                     temp{1,2} = RoundBet - gs{5,i}; 
%                     temp{1,3} = RoundBet;
%                     temp{1,4} = POT;
%                     temp{1,5} = gs{2,i};
%                     gs{j,i} = temp;
%                     
%                     
%                     gs{5,i} = RoundBet;
%                     gs{2,i} = gs{2,i} - temp{1,2};
% 
%                     POT = POT + temp{1,2};
%                     LimpCount = LimpCount + 1;
%                     Eq(i) = BET;
%                     continue
%                     
%                 %CHECK BIG BLIND    
%                 elseif i == 2
%                     
%                     if LimpCount == 1
%                         temp{1,1} = 'bCHECK';
%                     else
%                         temp{1,1} = 'cCHECK';
%                     end
%                     temp{1,2} = 0; 
%                     temp{1,3} = RoundBet;
%                     temp{1,4} = POT;
%                     temp{1,5} = gs{2,i};
%                     
%                     gs{j,i} = temp;
%                     LimpCount = LimpCount + 1;
%                     Eq(i) = BET;
%                     continue
                 end
                
            end
            
%______________________________________________________________________________________________________________            
                                                 %FOLD MOVE
                                                 
            if cellfun(@isempty, gs(j,i))%
                
                if LimpCount == 0
                    temp{1,1} = 'aFOLD';
                elseif LimpCount == 1
                    temp{1,1} = 'bFOLD';
                else
                    temp{1,1} = 'cFOLD';
                end
                
                temp{1,2} = RoundBet - gs{5,i}; 
                temp{1,3} = RoundBet;
                temp{1,4} = POT;
                temp{1,5} = gs{2,i};
                gs{j,i} = temp;

                IsIn(i) = 0; 
                continue
            end
        end
        
        
%______________________________________________________________________________________________________________        
%______________________________________________________________________________________________________________            
        if BET == 2                             %RAISE MOVES      
            
            %STEAL RE-RAISE    
            if i == 2 && SBET == 1 && (PT{3,1} > CCp || PT{4,2} >= CCp)%

                temp{1,1} = 'SRBET';
                temp{1,2} = 3*RoundBet; 
                temp{1,3} = RoundBet;
                temp{1,4} = POT;
                temp{1,5} = gs{2,i};

                gs{j,i} = temp;
                gs{2,i} = gs{2,i} - temp{1,2} + gs{5,i};

                POT = POT + temp{1,2} - gs{5,i};
                RoundBet = temp{1,2};
                gs{5,i} = temp{1,2};
                BET = BET + 1;
                Eq(i) = BET;
                GameStatus{9,1} = i;
                continue
                
            %3BET
            elseif PT{3,1} >= CCp ||...%
                   (size(strfind(gs{j-1,i}{1,1},'LIMP'),1) > 0 && ((PT{6,i}+PT{7,i})*(PT{2,5}/100)) >= CCp) %3BET

                temp{1,1} = '3BET';
                temp{1,2} = 3*RoundBet; 
                temp{1,3} = RoundBet;
                temp{1,4} = POT;
                temp{1,5} = gs{2,i};

                gs{j,i} = temp;
                gs{2,i} = gs{2,i} - temp{1,2} + gs{5,i};

                POT = POT + temp{1,2} - gs{5,i};
                gs{5,i} = temp{1,2};
                RoundBet = temp{1,2};
                BET = BET + 1;
                Eq(i) = BET;
                GameStatus{9,1} = i;
                continue



            end

        
        
%______________________________________________________________________________________________________________            
                                                 %CALL MOVES   
                                                 
                                                 
            %FOR FIRST ACTION                                     
            if cellfun(@isempty, gs(j,i)) && (j == 7 || (j == 8 && i == 1) || (j == 8 && i == 2))
                
                %STEAL CALL
                if SBET == 1 && i == 2 && ((100 - PT{2,4}) >= CCp || (PT{3,1} + PT{8,i}) >= CCp)%
                    
                    temp{1,1} = 'SCALL';
                    temp{1,2} = RoundBet - gs{5,i}; 
                    temp{1,3} = RoundBet;
                    temp{1,4} = POT;
                    temp{1,5} = gs{2,i};

                    gs{j,i} = temp;
                    gs{2,i} = gs{2,i} - temp{1,2};

                    POT = POT + temp{1,2};
                    gs{5,i} = RoundBet;
                    Eq(i) = BET;
                    continue
                
                %2-CALL    
                elseif (PT{3,1} + PT{8,i}) >= CCp %|| PT{5,2} >= CCp%
                    
                    temp{1,1} = '2CALL';
                    temp{1,2} = RoundBet - gs{5,i}; 
                    temp{1,3} = RoundBet;
                    temp{1,4} = POT;
                    temp{1,5} = gs{2,i};

                    gs{j,i} = temp;
                    gs{2,i} = gs{2,i} - temp{1,2};

                    POT = POT + temp{1,2};
                    gs{5,i} = RoundBet;
                    Eq(i) = BET;     
                    continue
                end
            
                
            %FOR SECOND ACTION    
            else
                
                %ISOLATION CALL%
                if size(strfind(gs{j-1,i}{1,1},'LIMP'),1) > 0 && ((PT{6,i} + PT{7,i})*(PT{2,6}/100)) >= CCp 
                    
                    if LimpCount == 1
                        temp{1,1} = 'ICALL';
                    else 
                        temp{1,1} = '2CALL';
                    end
                    
                    temp{1,2} = RoundBet - gs{5,i}; 
                    temp{1,3} = RoundBet;
                    temp{1,4} = POT;
                    temp{1,5} = gs{2,i};

                    gs{j,i} = temp;
                    gs{2,i} = gs{2,i} - temp{1,2};

                    POT = POT + temp{1,2};
                    gs{5,i} = RoundBet;
                    Eq(i) = BET;
                    continue
                    
                %2BET CALL%    
                elseif (PT{3,1} + PT{4,1}) > CCp || PT{5,2} >= CCp
                    
                    temp{1,1} = '2CALL';
                    temp{1,2} = RoundBet - gs{5,i}; 
                    temp{1,3} = RoundBet;
                    temp{1,4} = POT;
                    temp{1,5} = gs{2,i};

                    gs{j,i} = temp;
                    gs{2,i} = gs{2,i} - temp{1,2};

                    POT = POT + temp{1,2};
                    gs{5,i} = RoundBet;
                    Eq(i) = BET;    
                    continue
                end
            end
                    
%______________________________________________________________________________________________________________            
                                                 %FOLD MOVE
                                                 
            if cellfun(@isempty, gs(j,i))%
                
                if IBET == 1 && j > 7 && size(strfind(gs{j-1,i}{1,1},'LIMP'),1) > 0
                    temp{1,1} = 'IFOLD';
                elseif SBET == 1
                    temp{1,1} = 'SFOLD';
                else
                    temp{1,1} = '2FOLD';
                end
                
                temp{1,2} = RoundBet - gs{5,i};  
                temp{1,3} = RoundBet;
                temp{1,4} = POT;
                temp{1,5} = gs{2,i};
                gs{j,i} = temp;

                IsIn(i) = 0; 
                continue
            end
        end                

        
        
        
%______________________________________________________________________________________________________________            
%______________________________________________________________________________________________________________            
         if BET == 3                           %RAISE MOVES
       
        
             
             
             
            %4BET%
            if AIp == 0 && PT{2,2}*(PT{4,4}/100) >= CCp || (PT{3,1} / 2) >= CCp %Special case - 4BET with half 3BET range

                temp{1,1} = '4BET';
                temp{1,2} = 3*RoundBet; 
                temp{1,3} = RoundBet;
                temp{1,4} = POT;
                temp{1,5} = gs{2,i};

                gs{j,i} = temp;
                gs{2,i} = gs{2,i} - temp{1,2} + gs{5,i};

                POT = POT + temp{1,2} - gs{5,i};
                gs{5,i} = temp{1,2};
                RoundBet = temp{1,2};
                BET = BET + 1;
                Eq(i) = BET;
                GameStatus{9,1} = i;
                continue    
            end
            
            
%______________________________________________________________________________________________________________            
                                               %CALL MOVES             
            
            

            %3BET CALL    %
            if PT{5,2}*((100 - PT{4,3})/100) > CCp || PT{3,1} >= CCp

                temp{1,1} = '3CALL';
                temp{1,2} = RoundBet - gs{5,i}; 
                temp{1,3} = RoundBet;
                temp{1,4} = POT;
                temp{1,5} = gs{2,i};

                gs{j,i} = temp;
                gs{2,i} = gs{2,i} - temp{1,2};

                POT = POT + temp{1,2};
                gs{5,i} = RoundBet;
                Eq(i) = BET;    
                continue
            %    
            elseif j >= 8 && size(strfind(gs{j-1,i}{1,1}, 'BET'),1) > 0 &&...
                   PT{5,2}*((100 - PT{3,2})/100) >= CCp
                
                temp{1,1} = '3CALL';
                temp{1,2} = RoundBet - gs{5,i}; 
                temp{1,3} = RoundBet;
                temp{1,4} = POT;
                temp{1,5} = gs{2,i};

                gs{j,i} = temp;
                gs{2,i} = gs{2,i} - temp{1,2};

                POT = POT + temp{1,2};
                gs{5,i} = RoundBet;
                Eq(i) = BET;    
                continue
            %    
            elseif (size(strfind(gs{j-1,i}{1,1}, 'CALL'),1) > 0 || size(strfind(gs{j-1,i}{1,1}, 'LIMP'),1) > 0) &&...
                   (PT{5,1}*((100-PT{5,5})/100) >=CCp || PT{5,2}*((100-PT{5,5})/100)) %#ok<BDLOG>
               
                temp{1,1} = '3CALL';
                temp{1,2} = RoundBet - gs{5,i}; 
                temp{1,3} = RoundBet;
                temp{1,4} = POT;
                temp{1,5} = gs{2,i};

                gs{j,i} = temp;
                gs{2,i} = gs{2,i} - temp{1,2};

                POT = POT + temp{1,2};
                gs{5,i} = RoundBet;
                Eq(i) = BET;    
                continue               
            end
                
                
 %______________________________________________________________________________________________________________            
                                                 %FOLD MOVE
                                                 
                                                 
            if cellfun(@isempty, gs(j,i))%
                
                if j > 7 && size(strfind(gs{j-1,i}{1,1}, 'BET'),1) > 0 
                    temp{1,1} = '3BFOLD';
                else
                    temp{1,1} = '3FOLD';
                end
                
                temp{1,2} = RoundBet - gs{5,i};  
                temp{1,3} = RoundBet;
                temp{1,4} = POT;
                temp{1,5} = gs{2,i};
                gs{j,i} = temp;

                IsIn(i) = 0; 
                continue
            end
        end                  

        
        
%______________________________________________________________________________________________________________            
%______________________________________________________________________________________________________________            
         if BET >= 4                           %RAISE MOVES
       
        
             
            %4+BET
            if AIp == 0 && (PT{3,1}*(PT{4,5}/100) >= CCp  || (PT{3,1} / 4) >= CCp)  %Special case - 4+BET with third 3BET range

                if POT >= gs{2,i}*0.8 || RoundBet >= 3*gs{2,Hpos} % stack multiplied by factor needed to go all in
                    temp{1,1} = [num2str(BET+1),'ABET'];
                    temp{1,2} = gs{2,i} + gs{5,i}; 
                    AI(i) = 1;
                else
                    temp{1,1} = [num2str(BET+1),'BET'];
                    temp{1,2} = 2.5*RoundBet;
                end   
                
                temp{1,3} = RoundBet;    
                temp{1,4} = POT;
                temp{1,5} = gs{2,i};

                gs{j,i} = temp;
                gs{2,i} = gs{2,i} - temp{1,2} + gs{5,i};

                POT = POT + temp{1,2} - gs{5,i};
                gs{5,i} = temp{1,2};
                RoundBet = temp{1,2};
                BET = BET + 1;
                Eq(i) = BET;
                GameStatus{9,1} = i;
                continue    
            end             
                             
                
%______________________________________________________________________________________________________________            
                                               %CALL MOVES             
            
            

            %4+BET CALL    
            if (PT{3,1}*((100 - PT{4,6})/100)) > CCp || (PT{3,1} / 2) >= CCp %Last one is for 4BET range 

                if AIp == 0
                    temp{1,1} = [num2str(BET),'CALL'];
                elseif AIp == 1
                    temp{1,1} = [num2str(BET),'ACALL']; 
                end
                
                temp{1,2} = RoundBet - gs{5,i}; 
                temp{1,3} = RoundBet;
                temp{1,4} = POT;
                temp{1,5} = gs{2,i};

                gs{j,i} = temp;
                gs{2,i} = gs{2,i} - temp{1,2};

                POT = POT + temp{1,2};
                gs{5,i} = RoundBet;
                Eq(i) = BET;    
                continue         
            end
                
            
 %______________________________________________________________________________________________________________            
                                                 %FOLD MOVE
                                                 
                                                 
            if cellfun(@isempty, gs(j,i))
                    
                temp{1,1} = [num2str(BET),'FOLD'];
                temp{1,2} = RoundBet - gs{5,i};  
                temp{1,3} = RoundBet;
                temp{1,4} = POT;
                temp{1,5} = gs{2,i};
                gs{j,i} = temp;

                IsIn(i) = 0; 
                continue
            end
        end                  
    end
    j = j + 1; %Moves to next betting line
end



%___________________________________________________________________________________________________________
                                                %HERO ACTION



gs{6,Hpos} = GameStatus
















































%end