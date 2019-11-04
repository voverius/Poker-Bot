    Height = 13;
    Width = 110;
    Resize = [8 5];
    Check = [2 3];
    Count = [0 0];
    Width2 = 5;

Output = 0;
Stop = 0;
i = 6;
IMG = Photos{i,4};
% IMG = a{3};

%Removes empty lines:
for j = Height:-1:1
   if all(IMG(j,:) == 0)
       IMG(j,:) = [];
   else
       Height = size(IMG,1);
       break
   end
end
    
if i == 1 || i > 4 %This removes the chips from the image
    TempIMG = 0;
    if any(IMG(1,:) == 1)
        IMG(:,find(IMG(1,:) == 1, 1 ):Width) = [];
        Width = size(IMG,2);
    end
    for j = Width:-1:1
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
    IMG(:,(Width - TempIMG + Width2):Width) = [];
end
% figure(1)
% imshow(IMG)
[NumberedIMG, CharacterCount] = bwlabel(IMG);
Multiplier = 1;
BreakUp = 0;

for j = CharacterCount:-1:2
    if BreakUp == 0
        [Pos1,Pos2] = find(NumberedIMG == j);
        CharacterIMG = IMG(min(Pos1):max(Pos1),min(Pos2):max(Pos2));
        [Size1, Size2] = size(CharacterIMG); 
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
            Temp(k) = corr2(template{k},CharacterIMG); 
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
disp(Output)