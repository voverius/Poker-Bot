function [Output,ErrorMatrix] = GetMoneyz(HMT, WT, WC, version)

%NOTE:

% When playing tournament moneyz in position #1 appear to be in a different
% position and orientation than on a cash table. When developing this for
% tournament play create new "versions"



ErrorMatrix = cell(6,2);
Position = zeros(6,4);
Output = zeros(6,1);
Temp = zeros(1,11);

if HMT == 1
    bwfactor = 0.8;
    Offset = (WC-1)*1920;
    Height = 20;
    Width = 200;
        Position = [820 + Offset, 599, Width, Height;... 
                    621 + Offset, 551, Width, Height;... 
                    658 + Offset, 344, Width, Height;... 
                    930 + Offset, 289, Width, Height;... 
                    1070 + Offset, 344, Width, Height;... 
                    1094 + Offset, 552, Width, Height]; 
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
    Height = 15;
    Width = 150;
    Position = [372 + Offset + Offset2, 387, Width, Height;... 
                234 + Offset + Offset2, 353, Width, Height;... 
                260 + Offset + Offset2, 205, Width, Height;... 
                456 + Offset + Offset2, 166, Width, Height;... 
                553 + Offset + Offset2, 205, Width, Height;... 
                570 + Offset + Offset2, 354, Width, Height];
   
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
    Width = 110;
    Position = [510 + Offset + Offset2, 305 + Offset3, Width, Height;... 
                398 + Offset + Offset2, 278 + Offset3, Width, Height;... 
                420 + Offset + Offset2, 164 + Offset3, Width, Height;... 
                570 + Offset + Offset2, 134 + Offset3, Width, Height;... 
                650 + Offset + Offset2, 164 + Offset3, Width, Height;... 
                663 + Offset + Offset2, 279 + Offset3, Width, Height];
            
    VariableName = 'ChipsTemplates4';
    eval(['load ',VariableName]);
    eval(['template = ',VariableName,';']);
    Resize = [8 5];
    Check = [2 3];
    Count = [0 0];
    Width2 = 5;
end


for i = 1:6
    if i == 2 && version == 2
        Output = Output(1);
        break
    end
    IMG = SS(Position(i,1), Position(i,2), Position(i,3), Position(i,4), bwfactor);
    ErrorMatrix{i,1} = IMG;
    
    if all(all(IMG == 0) == 1)
        continue
    end
    
    %Removes empty lines:
    for j = Height:-1:1
       if all(IMG(j,:) == 0)
           IMG(j,:) = [];
       else
           Height = size(IMG,1);
           break
       end
    end
    
    %This removes the chips from the image
    if i == 1 || i > 4 
        TempIMG = 0;
        TempWidth = Width;
        if any(IMG(1,:) == 1)
            IMG(:,find(IMG(1,:) == 1, 1 ):TempWidth) = [];
            TempWidth = size(IMG,2);
        end
        for j = TempWidth:-1:1
            if any(IMG(1:Check(1),j) == 1)
                TempIMG = TempIMG + 1;
                Count(1) = Count(1) + 1;
            elseif all(all(IMG((Height-Check(2)):Height,j) == 0) == 1)
                TempIMG = TempIMG + 1;
                Count(2) = Count(2) + 1;
            else
                break
            end
        end
        IMG(:,(TempWidth - TempIMG + Width2):TempWidth) = [];
        ErrorMatrix{i,2} = IMG;
    end
    
    [NumberedIMG, CharacterCount] = bwlabel(IMG);
    Multiplier = 1;
    BreakUp = 0;
    Stop = 0;
        
    for j = CharacterCount:-1:2
        if BreakUp == 0
            [Pos1,Pos2] = find(NumberedIMG == j);
            CharacterIMG = IMG(min(Pos1):max(Pos1),min(Pos2):max(Pos2));
            [Size1, Size2] = size(CharacterIMG);  %#ok<*ASGLU>
        else
            CharacterIMG = IMG(min(Pos3):max(Pos1),min(Pos2):max(Pos4));
            [Size1, Size2] = size(CharacterIMG);  
            BreakUp = 0;
        end

        if Size1 < 5
            if Stop == 0 && Multiplier == 100
                Output(i) = Output(i)/100;
                Multiplier = 1;
                Stop = 1;
                continue
            else
                continue
            end
        elseif Size1 < Resize(1) %check for split in half digits
            [Pos3,Pos4] = find(NumberedIMG == (j-1));
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
                Temp(k) = corr2(template{k},CharacterIMG);  %#ok<USENS>
            end
            MaxPosition = find(Temp == max(Temp));
            if MaxPosition == 11
                break
            end
            TempPosition = MaxPosition - 1;
            Output(i) = Output(i) + TempPosition*Multiplier;
            Multiplier = Multiplier * 10;
        end
    end    
end
end


%Display IMG, trimmed IMG for development:

% disp(Output)
% figure(88)
% pos = 1;
% pos2 = 2;
% for i = 1:6
%     subplot(6,2,pos)
%     subimage(ErrorMatrix{i,1});
%     pos = pos + 2;
% 
%     subplot(6,2,pos2)
%     subimage(ErrorMatrix{i,2});
%     pos2 = pos2 + 2;
% end
