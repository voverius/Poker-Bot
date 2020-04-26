function Output = TempCorr(IMG, template)

[NumberedIMG, CharacterCount] = bwlabel(IMG);
Multiplier = 1;
Temp = zeros(10,1);
Output = 0;

for j = CharacterCount:-1:2
        [Pos1,Pos2] = find(NumberedIMG == j);
        CharacterIMG = IMG(min(Pos1):max(Pos1),min(Pos2):max(Pos2));
        [Size1, Size2] = size(CharacterIMG); %#ok<ASGLU>
        
        if Size1 < 7
            if j == (CharacterCount - 2)
                Output = Output/100;
                Multiplier = 1;
                continue
            else
                continue
            end
        elseif Size1 > 14
            break
        else
            CharacterIMG = imresize(CharacterIMG, [13 9]);
            for k = 1:10
                Temp(k) = corr2(template{k},CharacterIMG);
            end
            TempPosition = find(Temp == max(Temp))-1;
            Output = Output + TempPosition*Multiplier;
            Multiplier = Multiplier * 10;
            disp(Temp);
            disp(j);
        end   
end


end