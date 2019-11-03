function Window = RestoreWindow(HMT, WT, WC, TextMatrix) 

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

%_______________________________________________________________
%Creating colors and portion variables for window screen devision

BackColor =[0.8 0.8 0.8]; %Background (Grey)
Black = [0 0 0]; %to make colored blocks stand out more with black frame
Green = [0.2 0.8 0.2]; % 'BET'
Yellow = [1 1 0.4];    % 'CALL'/'CHECK'
Red = [0.8 0.2 0.2];   % 'FOLD'


%___________________________________________________________
%This creates the actual window of size defined in Position:

Window = figure('units','pixels',...
                'position',Position,...
                'Color',BackColor,...
                'menubar','none',...
                'numbertitle','off',...
                'resize','off');
            
for i = 1:size(TextMatrix,3)
    
    
end







            