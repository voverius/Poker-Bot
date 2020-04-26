function [IMGMatrix,ErrorMatrix] = GetNames(HMT, WT, WC, IMGMatrix, PlayersIn)

ErrorMatrix = cell(6,1);
Position = zeros(6,4);
bwfactor = 0.85;
flag = 0;

if HMT == 1
    Offset = (WC-1)*1920;
    Height = 20;
    Width = 100;
    Position = [945 + Offset, 743, Width, Height;...
                380 + Offset, 583, Width, Height;...
                380 + Offset, 296, Width, Height;...
                870 + Offset, 187, Width, Height;...
                1440 + Offset, 296, Width, Height;...
                1440 + Offset, 583, Width, Height];      
elseif HMT == 2
    Offset = (WC-1)*1920;
    Offset2 = 960 * (WT-1);
    Height = 12;
    Width = 100;
    Position = [452 + Offset + Offset2, 492, Width, Height;...
                59 + Offset + Offset2, 378, Width, Height;...
                54 + Offset + Offset2, 173, Width, Height;...
                406 + Offset + Offset2, 94, Width, Height;...
                814 + Offset + Offset2, 173, Width, Height;...
                810 + Offset + Offset2, 378, Width, Height];
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
    Height = 9;
    Width = 80;  
    Position = [571 + Offset + Offset2, 387 + Offset3, Width, Height;...
                257 + Offset + Offset2, 298 + Offset3, Width, Height;...
                257 + Offset + Offset2, 139 + Offset3, Width, Height;...
                528 + Offset + Offset2, 80 + Offset3, Width, Height;...
                848 + Offset + Offset2, 139 + Offset3, Width, Height;...
                848 + Offset + Offset2, 297 + Offset3, Width, Height];
end

for i = 2:6
    if PlayersIn(i) == 1
        IMG = SS(Position(i,1), Position(i,2), Position(i,3), Position(i,4), bwfactor);
        ErrorMatrix{i,1} = IMG;
        if all(all(IMG == 0))
            while flag == 0;
                IMG = SS(Position(i,1), Position(i,2), Position(i,3), Position(i,4), bwfactor);
                if  all(all(IMG == 0) == 1) == 0
                    break
                else
                    IsInTemp = GetIsIn(HMT, WT, WC);
                    if IsInTemp(i) == 0
                        flag = 1;
                    end
                end
            end
        end
        if flag == 1
            continue
        end
                
        Size1 = size(IMGMatrix{i,1},1);
        Size2 = size(IMGMatrix{i,2},1);
        
        if Size1 == 0
            IMGMatrix{i,1} = IMG;
            temp = 0;
        elseif Size2 == 0
            IMGMatrix{i,2} = IMG;
            temp = corr2(IMGMatrix{i,1},IMGMatrix{i,2});
        else
            temp = corr2(IMGMatrix{i,2},IMG);
        end
        
        if temp >= 0.8
            IMGMatrix{i,3} = 1;
        else
            IMGMatrix{i,3} = 0;
            IMGMatrix{i,1} = IMG;
            IMGMatrix{i,2} = [];
        end
    end
end       
end