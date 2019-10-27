% function ShowAction(HMT, WT, WC) 
HMT = 4;
WT = 1;
WC = 2;
table = WT;

if size(a{table,1},2) == 1
    try
        close(a{table,1})
    catch
        %do nothing
    end
end

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

color =[0.8 0.8 0.8];
a{table,1} = figure('units','pixels',...
              'position',Position,...
              'Color',color,...
              'menubar','none',...
              'numbertitle','off',...
              'resize','off');
a{table,2} = uicontrol('style','text',...
                       'BackgroundColor',color,...
                       'Position', [40 40 80 20],...
                       'String', 'Baaaaaaaaaaat');

































% end