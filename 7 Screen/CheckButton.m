function Output = CheckButton(HMT, WT, WC, Button)

Output = uint8(1);
Position = zeros(6,4);
bwfactor = 0.6;

if HMT == 1
    Offset = (WC-1)*1920;
    Height = 36;
    Width = 42;
    Position = [1053 + Offset, 642, Width, Height;... 
                618 + Offset, 582, Width, Height;... 
                577 + Offset, 362, Width, Height;... 
                842 + Offset, 274, Width, Height;... 
                1318 + Offset, 370, Width, Height;... 
                1262 + Offset, 582, Width, Height]; 
elseif HMT == 2
    Offset = (WC-1)*1920;
    Offset2 = 960 * (WT-1);
    Height = 23;
    Width = 27;    
    Position = [548 + Offset + Offset2, 422, Width, Height;...
                237 + Offset + Offset2, 379, Width, Height;...
                207 + Offset + Offset2, 222, Width, Height;...
                396 + Offset + Offset2, 158, Width, Height;...
                737 + Offset + Offset2, 227, Width, Height;...
                697 + Offset + Offset2, 379, Width, Height];
            
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
    Height = 19;
    Width = 21;    
    Position = [640 + Offset + Offset2, 332 + Offset3, Width, Height;...
                401 + Offset + Offset2, 298 + Offset3, Width, Height;...
                378 + Offset + Offset2, 177 + Offset3, Width, Height;...
                524 + Offset + Offset2, 128 + Offset3, Width, Height;...
                787 + Offset + Offset2, 182 + Offset3, Width, Height;...
                755 + Offset + Offset2, 298 + Offset3, Width, Height];
            
end

IMG = SS(Position(Button,1), Position(Button,2), Position(Button,3), Position(Button,4), bwfactor);
if all(all(IMG == 0))
   Output = uint8(0);
end

end