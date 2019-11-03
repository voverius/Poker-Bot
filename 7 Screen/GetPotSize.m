function [Output,IMG] = GetPotSize(HMT, WT, WC)

%HMC - How Many Tables
%WT - Which Table
%WC - Which Screen
%This will determine from which area a screenshot of what size will be taken

Output = 0;
Temp = zeros(1,11);
Multiplier = 1;
bwfactor = 0.8;
Stop = 0;

if HMT == 1
    Offset = (WC-1)*1920;    
    Position = [865 + Offset, 354, 200, 20];
    
    VariableName = 'PotSizeTemplates1';
    eval(['load ',VariableName]);
    eval(['template = ',VariableName,';']);
    Resize = [16 10];
    
elseif HMT == 2
    Offset = (WC-1)*1920;
    Offset2 = 960 * (WT-1);
    
    Height = 16;
    Width = 165;
    Position = [400 + Offset + Offset2, 214, Width, Height];
    
    VariableName = 'PotSizeTemplates2';
    eval(['load ',VariableName]);
    eval(['template = ',VariableName,';']);
    Resize = [13 6];
    
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

    Height = 13;
    Width = 140;
    Position = [518 + Offset + Offset2, 172 + Offset3, Width, Height];
    
    VariableName = 'PotSizeTemplates4';
    eval(['load ',VariableName]);
    eval(['template = ',VariableName,';']);
    Resize = [10 6];    
end

IMG = SS(Position(1), Position(2), Position(3), Position(4), bwfactor);
[NumberedIMG, CharacterCount] = bwlabel(IMG);

for i = CharacterCount:-1:7
    [Pos1,Pos2] = find(NumberedIMG == i);
    CharacterIMG = IMG(min(Pos1):max(Pos1),min(Pos2):max(Pos2));
    [Size1, Size2] = size(CharacterIMG); %#ok<ASGLU>
    
    if Size1 < 7
        if Stop == 0
            if Pos1(1) >= Position(4) - 5 
                Output = Output/100;
                Multiplier = 1;
                Stop = 1;
                continue
            else
                continue
            end
        else
            continue
        end
    else
        CharacterIMG = imresize(CharacterIMG, [Resize(1) Resize(2)]);
        for j = 1:11
            Temp(j) = corr2(template{j},CharacterIMG); %#ok<USENS>
        end
        
        if find(Temp == max(Temp)) == 11
            break
        end
        
        Number = find(Temp == max(Temp)) - 1;
        Output = Output + Number*Multiplier;
        Multiplier = Multiplier * 10;
    end
end
end    