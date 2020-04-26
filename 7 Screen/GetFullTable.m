function IMG = GetFullTable(HMT,WT,WC)

IMG = 0;
Position = zeros(1,4);
bwfactor = 0.5;

if HMT == 1
    Offset = (WC-1)*1920;
    Position = [291 + Offset, 67, 1337, 945];
elseif HMT == 2
    Offset = (WC-1)*1920;
    Offset2 = 960 * (WT-1);
    Position = [Offset + Offset2, 0, 960, 688];    
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
    Position = [217 + Offset + Offset2, 0 + Offset3, 743, 539];   
end

[~,IMG] = SS(Position(1), Position(2), Position(3), Position(4), bwfactor);
end