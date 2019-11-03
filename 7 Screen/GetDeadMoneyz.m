function [Output,ErrorMatrix] = GetDeadMoneyz(HMT, WT, WC)

% %Development (comment out when finished):
% HMT = 4;
% WT = 4;
% WC = 3;

Output = 0;
Temp = zeros(1,11);
Position = zeros(6,1);

if HMT == 1
    bwfactor = 0.8;
    Offset = (WC-1)*1920;
    Position = [827 + Offset, 542, 200, 20];

    VariableName = 'ChipsTemplates1';
    eval(['load ',VariableName]);
    eval(['template = ',VariableName,';']);
    Resize = [13, 9];
    Check = [3 4];
    Count = [0 0];
    Width2 = 6;
elseif HMT == 2
    bwfactor = 0.65;
    Offset = (WC-1)*1920;
    Offset2 = 960 * (WT-1);
    Position = [390 + Offset + Offset2, 348, 100, 15];
   
    VariableName = 'ChipsTemplates2';
    eval(['load ',VariableName]);
    eval(['template = ',VariableName,';']);
    Resize = [10 6];
    Check = [2 3];
    Count = [0 0];
    Width2 = 6;
elseif HMT == 4
    bwfactor = 0.7;
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
    Width = 130;
    Position = [512 + Offset + Offset2, 275 + Offset3, 90, 13];
            
    VariableName = 'ChipsTemplates4';
    eval(['load ',VariableName]);
    eval(['template = ',VariableName,';']);
    Resize = [8 5];
    Check = [2 3];
    Count = [0 0];
    Width2 = 5;
end

IMG = SS(Position(1), Position(2), Position(3), Position(4), bwfactor);
[NumberedIMG, CharacterCount] = bwlabel(IMG);
ErrorMatrix = IMG;
Multiplier = 1;
BreakUp = 0;
Stop = 0;

for i = CharacterCount:-1:2
    if CharacterCount == 0
        break
    end    

    if BreakUp == 0
        [Pos1,Pos2] = find(NumberedIMG == i);
        CharacterIMG = IMG(min(Pos1):max(Pos1),min(Pos2):max(Pos2));
        [Size1, Size2] = size(CharacterIMG);  %#ok<*ASGLU>
    else
        CharacterIMG = IMG(min(Pos3):max(Pos1),min(Pos2):max(Pos4));
        [Size1, Size2] = size(CharacterIMG);  
        BreakUp = 0;
    end
    
    if Size1 < 5
        if Stop == 0 && Multiplier == 100
            Output = Output/100;
            Multiplier = 1;
            Stop = 1;
            continue
        else
            continue
        end
    elseif Size1 < Resize(1) %check for split in half digits
        [Pos3,Pos4] = find(NumberedIMG == (i-1));
        CharacterIMG = IMG(min(Pos3):max(Pos3),min(Pos4):max(Pos4));
        [Size3, Size4] = size(CharacterIMG); 
        if Size3 < Resize(1)
            if min(Pos2) <= max(Pos4) %checking if split peaces are above each other
                BreakUp = 1;
            end
        end
    else
        CharacterIMG = imresize(CharacterIMG, [Resize(1) Resize(2)]);
        for k = 1:11
            Temp(k) = corr2(template{k},CharacterIMG); %#ok<*USENS>
        end
        MaxPosition = find(Temp == max(Temp));
        if MaxPosition == 11
            break
        end
        TempPosition = MaxPosition - 1;
        Output = Output + TempPosition*Multiplier;
        Multiplier = Multiplier * 10;
    end
end
end