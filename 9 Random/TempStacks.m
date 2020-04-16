    
    Resize = [12 6];
    Check = 6;


Output = 0;
Stop = 0;
i = 1;
% IMG = Photos{i,1};
% IMG = a{3};

[NumberedIMG, CharacterCount] = bwlabel(IMG);
Multiplier = 1;
BreakUp = 0;
% Go = 1;


% end


for j = 1:CharacterCount
    CharacterStop = j;
    [Pos1,Pos2] = find(NumberedIMG == j);
    CharacterIMG = IMG(min(Pos1):max(Pos1),min(Pos2):max(Pos2));
    [Size1, Size2] = size(CharacterIMG);
    if Size1 > Resize(1) - 2
        CharacterIMG = imresize(CharacterIMG, [Resize(1) Resize(2)]);
        if corr2(template{11},CharacterIMG) > 0.5
            Go = 1;
        elseif corr2(template{12},CharacterIMG) > 0.8
            Go = 0;
            Output = 0;
            disp('All In'); 
        else
            disp('Empty Seat');
            Go = 0;
        end
        break
    end
end



if Go == 1
    for j = CharacterCount:-1:(CharacterStop + 1)
        [Pos1,Pos2] = find(NumberedIMG == j);
        CharacterIMG = IMG(min(Pos1):max(Pos1),min(Pos2):max(Pos2));
        [Size1, Size2] = size(CharacterIMG);

        if Size1 < Check
            if Stop == 0 && Multiplier == 100
                Output = Output/100;
                Multiplier = 1;
                Stop = 1;
                continue
            else
                continue
            end
        else
            CharacterIMG = imresize(CharacterIMG, [Resize(1) Resize(2)]);
            for k = 1:10
                Temp(k) = corr2(template{k},CharacterIMG);
            end
            MaxPosition = find(Temp == max(Temp));

            Number = MaxPosition - 1;
            Output = Output + Number*Multiplier;
            Multiplier = Multiplier * 10;
        end       
    end  
end
disp(Output)

% if CharacterCount == 4 %In case of "TAKE SEAT"
%     if all(all(IMG(Check(1):Check(2),:) == 0) == 1)
%         Output = 'Take Seat';
%         Go = 0;
%     end
% elseif CharacterCount == 0
%     Go = 0;
% elseif CharacterCount == 5  %In case of "All in"
%     [Pos1,Pos2] = find(NumberedIMG == 1);
%     CharacterIMG = IMG(min(Pos1):max(Pos1),min(Pos2):max(Pos2));
%     CharacterIMG = imresize(CharacterIMG, [Resize(1) Resize(2)]);
%     if corr2(template{11},CharacterIMG) < 0.5 
%         Go = 0;
%         Output = 0;
%         disp('All In');
%     end