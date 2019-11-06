function [Output,ErrorOutput] = GetIsIn(HMT, WT, WC)

Output = uint8(zeros(6,1));
ErrorOutput = cell(6,1);
Position = zeros(6,4);
bwfactor = 0.6;
Output(1) = 1;

if HMT == 1
    Offset = (WC-1)*1920;
    Height = 18;
    Width = 19;
    area = Height*Width;
    ReqRatio = [0.32 0.47];
    Position = [0,0,0,0;...
                416 + Offset,  538, Width, Height;... 
                416 + Offset,  251, Width, Height;... 
                910 + Offset,  143, Width, Height;... 
                1408 + Offset, 251, Width, Height;... 
                1408 + Offset, 538, Width, Height]; 
elseif HMT == 2
    Offset = (WC-1)*1920;
    Offset2 = 960 * (WT-1);
    Height = 13;
    Width = 13;    
    area = Height*Width;
    ReqRatio = [0.35 0.5];
    Position = [444 + Offset + Offset2, 461, Width, Height;...
                92 + Offset + Offset2,  346, Width, Height;...
                92 + Offset + Offset2,  141, Width, Height;...
                444 + Offset + Offset2,  64, Width, Height;...
                801 + Offset + Offset2, 141, Width, Height;...
                801 + Offset + Offset2, 346, Width, Height];
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
    Width = 11;    
    area = Height*Width;
    ReqRatio = [0.35 0.5];
    Position = [560 + Offset + Offset2, 363 + Offset3, Width, Height;...
                288 + Offset + Offset2, 275 + Offset3, Width, Height;...
                288 + Offset + Offset2, 117 + Offset3, Width, Height;...
                560 + Offset + Offset2, 57  + Offset3, Width, Height;...
                835 + Offset + Offset2, 117 + Offset3, Width, Height;...
                835 + Offset + Offset2, 275 + Offset3, Width, Height];        
end


for i = 2:6
    IMG = SS(Position(i,1), Position(i,2), Position(i,3), Position(i,4), bwfactor);
    ErrorOutput{i} = IMG;
    if all(all(IMG == 0))
        continue
    end
    
    Ratio = nnz(IMG)/area;
    if ReqRatio(1) < Ratio  &&  Ratio < ReqRatio(2)
        Output(i) = 1;
    end
end
end