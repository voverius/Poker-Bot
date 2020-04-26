% this function is purely for the development of the window layout
% close all
a = cell(2,20);
HMT = 1;
WT = 1;
WC = 3;
table = WT;


if HMT == 1
    Offset = (WC-1)*1920;    
    Position = [310 + Offset, 90, 600, 120];
    
elseif HMT == 2
    Offset = (WC-1)*1920;
    Offset2 = 960 * (WT-1);
    Position = [15 + Offset + Offset2, 400, 430, 100];
    
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
    
end

BackColor =[0.8 0.8 0.8]; %Background (Grey)
Black = [0 0 0]; %to make colored blocks stand out more with black frame
Green = [0.2 0.8 0.2]; % 'BET'
Yellow = [1 1 0.4]; %    'CALL'/'CHECK'
Red = [0.8 0.2 0.2]; %   'FOLD'

Length = Position(3);
L2 = Length/2;
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


Window = figure('units','pixels',...
              'position',Position,...
              'Color',BackColor,...
              'menubar','none',...
              'numbertitle','off',...
              'resize','off');
          
% %random text          
% a{table,2} = uicontrol('style','text',...
%                        'BackgroundColor',BackColor,...
%                        'Position', [40 40 80 20],...
%                        'String', 'Baaaaaaaaaaat');
                                    
%Background for final output, this is so the answer stands out more              
tp = [Length - L8 - L16, 0, L8 + L16, Width];                  
a{table,3} = uicontrol('style','text',...
                       'BackgroundColor',Black,...
                       'Position', tp);
                   
%rightmost position for final output                   
tp = [Length-L8+L128, W32, L8-2*L128,Width-2*W32];                  
a{table,4} = uicontrol('style','text',...
                       'BackgroundColor',Red,...
                       'Position', tp);                   
                   
                   
                   
%rightmost position for final output                   
tp = [Length-L8-L16+L128, W32, L16-L128,W3-2*W32];                  
a{table,5} = uicontrol('style','text',...
                       'BackgroundColor',BackColor,...
                       'Position', tp);                        
                   
%rightmost position for final output                   
tp = [Length-L8-L16+L128, W3 + W32, L16-L128,W3-2*W32];                  
a{table,6} = uicontrol('style','text',...
                       'BackgroundColor',Red,...
                       'Position', tp);                      
                   
%rightmost position for final output                   
tp = [Length-L8-L16+L128, 2*W3 + W32, L16-L128,W3-2*W32];                  
a{table,7} = uicontrol('style','text',...
                       'BackgroundColor',Red,...
                       'Position', tp);                       
                   
tp = [Length-L8-2*L16+L128, 2*W3 + W32, L16-2*L128,W3-2*W32];    
a{table,8} = uicontrol('style','text',...
                                'BackgroundColor',BackColor,...
                                'Position', tp,...
                                'String', 'PF',...
                                'FontSize',9);
                                
tp = [Length-L8-2*L16+L128, W3 + W32, L16-2*L128,W3-2*W32];    
a{table,8} = uicontrol('style','text',...
                                'BackgroundColor',BackColor,...
                                'Position', tp,...
                                'String', 'W',...
                                'FontSize',9);                   
                   
tp = [Length-L8-2*L16+L128, W32, L16-2*L128,W3-2*W32];    
a{table,8} = uicontrol('style','text',...
                                'BackgroundColor',BackColor,...
                                'Position', tp,...
                                'String', '3',...
                                'FontSize',9);                      
                   
                   
                   
tp = [0, 0, L16,Width+20];    
uicontrol('style','text',...
                                'BackgroundColor',Black,...
                                'Position', tp,...
                                'String', ' ',...
                                'FontSize',9);                            
                   
tp = [L128, W32, L16-2*L128,W5-W32];    
a{table,10} = uicontrol('style','text',...
                                'BackgroundColor',Green,...
                                'Position', tp,...
                                'FontSize',9);                      
                   
tp = [L128, W32+W5, L16-2*L128,W5-W32];    
a{table,11} = uicontrol('style','text',...
                                'BackgroundColor',Red,...
                                'Position', tp,...
                                'FontSize',9);                    
                   
tp = [L128, W32+2*W5, L16-2*L128,W5-W32];    
a{table,12} = uicontrol('style','text',...
                                'BackgroundColor',Green,...
                                'Position', tp,...
                                'FontSize',9);    

tp = [L128, W32+3*W5, L16-2*L128,W5-W32];    
a{table,13} = uicontrol('style','text',...
                                'BackgroundColor',Red,...
                                'Position', tp,...
                                'FontSize',9);    

tp = [L128, W32+4*W5, L16-2*L128,W5-W32];    
a{table,14} = uicontrol('style','text',...
                                'BackgroundColor',Green,...
                                'Position', tp,...
                                'FontSize',9);    


% tp = [L16+L128, W32+4*W5, L4, W5-W32];    
% a{table,15} = uicontrol('style','text',...
%                                 'BackgroundColor',BackColor,...
%                                 'Position', tp,...
%                                 'FontSize',9,...
%                                 'String', num2str(temp(1:4)));
%                             
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
WinOnTop(Window);











% end