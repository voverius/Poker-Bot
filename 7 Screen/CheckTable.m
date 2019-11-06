function Output = CheckTable(HMT, WT, WC)

Output = uint8(0);
bwfactor = 0.5;

if HMT == 1
    Offset = (WC-1)*1920;
    Position = [1593 + Offset, 72, 9, 8];
elseif HMT == 2
    Offset = (WC-1)*1920;
    Offset2 = 960 * (WT-1);   
    Position = [925 + Offset + Offset2, 6, 9, 8];
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
    Position = [925 + Offset + Offset2, 6 + Offset3, 9, 8];
end

IMG = SS(Position(1), Position(2), Position(3), Position(4), bwfactor);

Ratio = (nnz(IMG)/(Position(3)*Position(4)));
if Ratio > 0.55  && Ratio < 0.65
    Output = uint8(1);
end
end