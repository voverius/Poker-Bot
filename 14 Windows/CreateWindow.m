function [Window, TextMatrix] = CreateWindow(HMT, WT, WC, TextMatrix) 

if HMT == 1
    Offset = (WC-1)*1920;    
    Position = [310 + Offset, 90, 600, 120];
    FS = 9; %Font Size
elseif HMT == 2
    Offset = (WC-1)*1920;
    Offset2 = 960 * (WT-1);
    Position = [15 + Offset + Offset2, 400, 430, 100];
    FS = 8;
elseif HMT == 4
    Offset = (WC-1)*1920;
    if rem(WT,2) == 0
        Offset2 = 744;
    else
        Offset2 = 0;
    end
    
    if WT > 2
        Offset3 = 540;
    else
        Offset3 = 0;
    end
    Position = [225 + Offset + Offset2, 550 - Offset3, 340, 70];
    FS = 7;
end

%_______________________________________________________________
%Creating colors and portion variables for window screen devision

BackColor =[0.8 0.8 0.8]; %Background (Grey)
Black = [0 0 0]; %to make colored blocks stand out more with black frame
Green = [0.2 0.8 0.2]; % 'BET'
Yellow = [1 1 0.4];    % 'CALL'/'CHECK'
Red = [0.8 0.2 0.2];   % 'FOLD'

Length = Position(3);
L4 = Length/4;
L8 = Length/8;
L16 = Length/16;
L32 = Length/32;
L64 = Length/64;
L128 = Length/128;

Width = Position(4);
W3 = Width/3;
W4 = Width/4;
W5 = Width/5;
W8 = Width/8;
W16 = Width/16;
W32 = Width/32;
W64 = Width/64; 


%___________________________________________________________
%This creates the actual window of size defined in Position:

Window = figure('units','pixels',...
                'position',Position,...
                'Color',BackColor,...
                'menubar','none',...
                'numbertitle','off',...
                'resize','off');

            
%____________________________________________________________________________________________________________
%                                     ACTION SQUARES AND WINDOW PREPARATION
            

%1  - Final Output
%2  - General Output
%3  - PokerTracker Output
%4  - Nash Output
%5  - Street
%6  - Waiting Status
%7  - Current Status
%8  - 2nd seat player name known
%9  - 3rd seat player name known
%10 - 4th seat player name known
%11 - 5th seat player name known
%12 - 6th seat player name known
%13 - Table is open
%14 - GetNames position
%15 - FileName known
%16 - Cards held
%17 - POT
%18 - 
%19 - temp first part
%20 - temp second part


%_____________     
%FINAL OUTPUT:

% Background for final output, this is so the answer stands out more              
tp = [Length - L8 - L16, 0, L8 + L16, Width];                  
                      uicontrol('style','text',...
                                'BackgroundColor',Black,...
                                'Position', tp);
                   
% Rightmost position for final output                   
tp = [Length-L8+L128, W32, L8-2*L128,Width-2*W32];                  
TextMatrix{WT,WC,1} = uicontrol('style','text',...
                                'BackgroundColor',BackColor,...
                                'Position', tp);                   
                   
             
                            
%__________________________                   
%INDIVIDUAL MODULE OUTPUTS:
                   
% Top for General                 
tp = [Length-L8-L16+L128, W32, L16-L128,W3-2*W32];                  
TextMatrix{WT,WC,4} = uicontrol('style','text',...
                                'BackgroundColor',BackColor,...
                                'Position', tp);                        
                   
% Middle for PokerTracker                 
tp = [Length-L8-L16+L128, W3 + W32, L16-L128,W3-2*W32];                  
TextMatrix{WT,WC,3} = uicontrol('style','text',...
                                'BackgroundColor',BackColor,...
                                'Position', tp);                      
                   
% Bottom for Nash             
tp = [Length-L8-L16+L128, 2*W3 + W32, L16-L128,W3-2*W32];                  
TextMatrix{WT,WC,2} = uicontrol('style','text',...
                                'BackgroundColor',BackColor,...
                                'Position', tp); 


                            
%____________________________     
%SHOWING STATUS CURRENT INFO:

%This shows the street initial 'PF,'F','T',R'        
tp = [Length-L8-2*L16+L128, 2*W3 + W32, L16-2*L128,W3-2*W32];    
TextMatrix{WT,WC,5} = uicontrol('style','text',...
                                'BackgroundColor',BackColor,...
                                'Position', tp,...
                                'String', ' ',...
                                'FontSize',FS);

%This will show wether to wait or take action - 'A' & 'W'                            
tp = [Length-L8-2*L16+L128, W3 + W32, L16-2*L128,W3-2*W32];    
TextMatrix{WT,WC,6} = uicontrol('style','text',...
                                'BackgroundColor',BackColor,...
                                'Position', tp,...
                                'String', ' ',...
                                'FontSize',FS);

%This will show the current status - '1', '2', '3', '4'...                       
tp = [Length-L8-2*L16+L128, W32, L16-2*L128,W3-2*W32];    
TextMatrix{WT,WC,7} = uicontrol('style','text',...
                                'BackgroundColor',BackColor,...
                                'Position', tp,...
                                'String', ' ',...
                                'FontSize',FS);

                            

%_______________________________________________________
%Checking Player Names, Turn To Green Once Name Is Known

%Black background to make it stand out more
tp = [0, 0, L16,Width];    
                      uicontrol('style','text',...
                                'BackgroundColor',Black,...
                                'Position', tp);                        
                   
%Player in seat #2, number backwards so that would be arranged from top to bottom                            
tp = [L128, W32, L16-2*L128,W5-W32];    
TextMatrix{WT,WC,12} = uicontrol('style','text',...
                                 'BackgroundColor',BackColor,...
                                 'Position', tp);  
%Player in seat #3                   
tp = [L128, W32+W5, L16-2*L128,W5-W32];    
TextMatrix{WT,WC,11} = uicontrol('style','text',...
                                 'BackgroundColor',BackColor,...
                                 'Position', tp);                  
%Player in seat #4                   
tp = [L128, W32+2*W5, L16-2*L128,W5-W32];    
TextMatrix{WT,WC,10} = uicontrol('style','text',...
                                 'BackgroundColor',BackColor,...
                                 'Position', tp);    
%Player in seat #5
tp = [L128, W32+3*W5, L16-2*L128,W5-W32];    
TextMatrix{WT,WC,9} =  uicontrol('style','text',...
                                 'BackgroundColor',BackColor,...
                                 'Position', tp);     
%Player in seat #6
tp = [L128, W32+4*W5, L16-2*L128,W5-W32];    
TextMatrix{WT,WC,8} =  uicontrol('style','text',...
                                 'BackgroundColor',BackColor,...
                                 'Position', tp); 


%___________________________________
%Three Status light for overall game

%Black background to make it stand out more
tp = [Length-L8-3*L16, 0, L16,Width];    
                      uicontrol('style','text',...
                                'BackgroundColor',Black,...
                                'Position', tp,...
                                'String', ' ',...
                                'FontSize',FS);   

%This shows if the table is active(in position where it should be):     
tp = [Length-L8-3*L16+L128, 2*W3 + W32, L16-2*L128,W3-2*W32];    
TextMatrix{WT,WC,13} = uicontrol('style','text',...
                                'BackgroundColor',BackColor,...
                                'Position', tp);
                            
%This shows if the names were recovered during free time or in PlayPF
tp = [Length-L8-3*L16+L128, W3 + W32, L16-2*L128,W3-2*W32];    
TextMatrix{WT,WC,14} = uicontrol('style','text',...
                                'BackgroundColor',BackColor,...
                                'Position', tp);

%turns to green when file name is known
tp = [Length-L8-3*L16+L128, W32, L16-2*L128,W3-2*W32];    
TextMatrix{WT,WC,15} = uicontrol('style','text',...
                                'BackgroundColor',BackColor,...
                                'Position', tp);



%_____________________                   
%CURRENT GAME FIGURES:
                   
% Top for Cards held            
tp = [Length-L8-4*L16+L128, 2*W3 + W32, L16-2*L128,W3-2*W32];              
TextMatrix{WT,WC,16} = uicontrol('style','text',...
                                 'BackgroundColor',BackColor,...
                                 'Position', tp,...
                                 'String', ' ',...
                                 'FontSize',FS);              

%Middle for POT:                         
tp = [Length-L8-4*L16+L128, W3 + W32, L16-2*L128,W3-2*W32];    
TextMatrix{WT,WC,17} = uicontrol('style','text',...
                                 'BackgroundColor',BackColor,...
                                 'Position', tp,...
                                 'String', ' ',...
                                 'FontSize',FS);

%                 
tp = [Length-L8-4*L16+L128, W32, L16-2*L128,W3-2*W32];    
TextMatrix{WT,WC,18} = uicontrol('style','text',...
                                 'BackgroundColor',BackColor,...
                                 'Position', tp,...
                                 'String', ' ',...
                                 'FontSize',FS);
 


%_____________________                   
%LAST OUTPUT (temp):

%temp first  part
tp = [L16+L128, W32+4*W5, L4, W5-W32];
TextMatrix{WT,WC,19} = uicontrol('style','text',...
                                 'BackgroundColor',BackColor,...
                                 'Position', tp,...
                                 'String', ' ',...
                                 'FontSize',FS);

%temp second part                             
tp = [L16+L128, W32+3*W5, L4, W5-W32];
TextMatrix{WT,WC,20} = uicontrol('style','text',...
                                 'BackgroundColor',BackColor,...
                                 'Position', tp,...
                                 'String', ' ',...
                                 'FontSize',FS);





                             
                             
                             
                             
                             
                             




drawnow
end