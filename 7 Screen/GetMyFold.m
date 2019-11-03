function Output = GetMyFold(HMT, WT, WC)
%HMT - How Many Tables
%WC - Which Table
%WC - Which Screen
%This will determine from which area a screenshot of what size will be taken

Output = uint8(0);
Position = zeros(1,4);
bwfactor = 0.9;

if HMT == 1
    Offset = (WC-1)*1920;
    Position = [884 + Offset, 672, 15, 15];
elseif HMT == 2
    Offset = (WC-1)*1920;
    Offset2 = 960 * (WT-1);
    Position = [424 + Offset + Offset2, 440, 14, 14];
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
    Position = [543 + Offset + Offset2, 344 + Offset3, 12, 11];
end

IMG = SS(Position(1), Position(2), Position(3), Position(4), bwfactor);

if all(all(IMG == 0))
    Output = uint8(1);
end
end