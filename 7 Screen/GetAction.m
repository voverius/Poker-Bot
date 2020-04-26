function Output = GetAction(HMT, WT, WC)

Output = uint8(1);
Position = zeros(1,4);
bwfactor = 0.8;

if HMT == 1
    Offset = (WC-1)*1920;
    Position = [1628 + Offset, 952, 1337, 13];
elseif HMT == 2
    Offset = (WC-1)*1920;
    Offset2 = 960 * (WT-1);
    Position = [550 + Offset + Offset2, 640, 12, 12];    
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
    Position = [640 + Offset + Offset2, 500 + Offset3, 10, 10];   
end

IMG = SS(Position(1), Position(2), Position(3), Position(4), bwfactor);

if all(all(IMG == 0))
    Output = uint8(0);
end

end