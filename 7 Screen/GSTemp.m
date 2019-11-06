WC = 3;
WT = 4;
%HMC - How Many Tables
%WT - Which Table
%WC - Which Screen
%This will determine from which area a screenshot of what size will be taken
Output = zeros(6,1);
Temp = zeros(1,10);

bwfactor = 0.5;
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
    Position = [217 + Offset + Offset2, 0 + Offset3, 743, 539];  
            
i = 1;
IMG = SS(Position(i,1), Position(i,2), Position(i,3), Position(i,4),bwfactor);
% [NumberedIMG, CharacterCount] = bwlabel(IMG);
a = IMG;
subimage(IMG)

% [Pos1,Pos2] = find(NumberedIMG == 2);
% CharacterIMG = IMG(min(Pos1):max(Pos1),min(Pos2):max(Pos2));
% imshow(CharacterIMG);


% StackSizeTemplates1{6} = CharacterIMG