function IMG = CheckPot(HMT, WT, WC)
%HMT - How Many Tables
%WC - Which Table
%WC - Which Screen
%This will determine from which area a screenshot of what size will be taken

Output = uint8(0);
Position = zeros(1,4);
bwfactor = 0.8;

if HMT == 1
    Offset = (WC-1)*1920;
    Position = [947 + Offset, 356, 67, 16];
elseif HMT == 2
    Offset = (WC-1)*1920;
    Offset2 = 960 * (WT-1);
    Position = [471 + Offset + Offset2, 216, 51, 12];
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
    Position = [579 + Offset + Offset2, 173 + Offset3, 42, 10];
end

IMG = SS(Position(1), Position(2), Position(3), Position(4), bwfactor);
end

% These are for raise window by the slide bar
% Position = [1231 + Offset, 875, 24, 11];
% Position = [668 + Offset + Offset2, 587, 23, 11];
% Position = [728 + Offset + Offset2, 461 + Offset3, 22, 10];