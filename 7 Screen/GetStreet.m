function Output = GetStreet(HMT, WT, WC)

%HMT - How Many Tables
%WT - Which Table
%WC - Which Screen
%This will determine from which area a screenshot of what size will be taken

Output = uint8(1);
Position = zeros(6,4);
bwfactor = 0.8;

if HMT == 1
    Offset = (WC-1)*1920;
    Gap = 90;
    Height = 22;
    Width = 22;
    Position = [923 + Offset, 402, Width, Height;... 
                923 + Offset + Gap, 402, Width, Height;... 
                923 + Offset + Gap*2, 402, Width, Height]; 
elseif HMT == 2
    Offset = (WC-1)*1920;
    Offset2 = 960 * (WT-1);
    Gap = 65;
    Height = 17;
    Width = 11;
    Position = [455 + Offset + Offset2, 248, Width, Height;... 
                455 + Offset + Offset2 + Gap, 248, Width, Height;... 
                455 + Offset + Offset2 + Gap*2, 248, Width, Height];
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
    Gap = 45;
    Height = 13;
    Width = 10;
    Position = [570 + Offset + Offset2, 200 + Offset3, Width, Height;... 
                570 + Offset + Offset2 + Gap, 200 + Offset3, Width, Height;... 
                570 + Offset + Offset2 + Gap*2, 200 + Offset3, Width, Height]; 
end

for i = 1:3
    IMG = SS(Position(i,1), Position(i,2), Position(i,3), Position(i,4), bwfactor);
    if all(all(IMG == 0))
        break
    end
    Output = i + 1;
end
end