function [Output,ErrorMatrix] = GetStacks(HMT, WT, WC, PlayersIn)

%NOTE:

% When playing tournaments players HUD in position #1 appear to be other
% way round on a cash table. When developing this for
% tournament play create new "versions"

ErrorMatrix = cell(6,1);
Position = zeros(6,4);
Output = zeros(6,1);
Temp = zeros(1,10);
fail = 0;

if HMT == 1
    bwfactor = 0.8;
    Offset = (WC-1)*1920;
    Height = 20;
    Width = 140;
    Position = [925 + Offset, 775, Width, Height;...
                360 + Offset, 615, Width, Height;...
                360 + Offset, 328, Width, Height;...
                850 + Offset, 218, Width, Height;...
                1420 + Offset, 328, Width, Height;...
                1420 + Offset, 615, Width, Height];
    VariableName = 'StackSizeTemplates1';
    eval(['load ',VariableName]);
    eval(['template = ',VariableName,';']);
    Resize = [15 10];    
    Check = 7;
elseif HMT == 2
    bwfactor = 0.7;
    Offset = (WC-1)*1920;
    Offset2 = 960 * (WT-1);
    Height = 14;
    Width = 100;
    Position = [451 + Offset + Offset2, 516, Width, Height;...
                50 + Offset + Offset2, 401, Width, Height;...
                50 + Offset + Offset2, 196, Width, Height;...
                405 + Offset + Offset2, 118, Width, Height;...
                805 + Offset + Offset2, 196, Width, Height;...
                810 + Offset + Offset2, 401, Width, Height];
    VariableName = 'StackSizeTemplates2';
    eval(['load ',VariableName]);
    eval(['template = ',VariableName,';']);
    Resize = [12 6];
    Check = 6; 
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
    Height = 11;
    Width = 80;
    Position = [565 + Offset + Offset2, 405 + Offset3, Width, Height;...
                255 + Offset + Offset2, 317 + Offset3, Width, Height;...
                260 + Offset + Offset2, 159 + Offset3, Width, Height;...
                530 + Offset + Offset2, 97 + Offset3, Width, Height;...
                846 + Offset + Offset2, 159 + Offset3, Width, Height;...
                846 + Offset + Offset2, 317 + Offset3, Width, Height];
    VariableName = 'StackSizeTemplates4';
    eval(['load ',VariableName]);
    eval(['template = ',VariableName,';']);
    Resize = [7 5];
    Check = 5;
end

i = 1;
while i < 7
    if PlayersIn(i) == 1
        IMG = SS(Position(i,1), Position(i,2), Position(i,3), Position(i,4), bwfactor);
        ErrorMatrix{i,1} = IMG;
        try
            [NumberedIMG, CharacterCount] = bwlabel(IMG);
            Multiplier = 1;
            Stop = 0;
            Go = 0;
            
            if CharacterCount == 0
                i = i + 1;
                continue
            else
                for j = 1:CharacterCount
                    CharacterStop = j;
                    [Pos1,Pos2] = find(NumberedIMG == j);
                    CharacterIMG = IMG(min(Pos1):max(Pos1),min(Pos2):max(Pos2));
                    [Size1, Size2] = size(CharacterIMG);  %#ok<*ASGLU>
                    if Size1 > Resize(1) - 2

                        CharacterIMG = imresize(CharacterIMG, [Resize(1) Resize(2)]);
                        if corr2(template{11},CharacterIMG) > 0.5 %#ok<*USENS>
                            %found doller sign, good to analyze
                            Go = 1;
                        elseif corr2(template{12},CharacterIMG) > 0.8
                            %All-in
                            Go = 0;
                            %in case of an all-in stack is 0, should this be
                            %correlated since take seat or any other empty
                            %matrix returns '0' as well?
                        else
                            %Take seat
                            Go = 0;
                        end
                        break
                    end
                end
            end
            
            if Go == 1
                for j = CharacterCount:-1:(CharacterStop + 1)
                    [Pos1,Pos2] = find(NumberedIMG == j);
                    CharacterIMG = IMG(min(Pos1):max(Pos1),min(Pos2):max(Pos2));
                    [Size1, Size2] = size(CharacterIMG);

                    if Size1 < Check
                        if Stop == 0 && Multiplier == 100
                            Output(i) = Output(i)/100;
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
                        Output(i) = Output(i) + Number*Multiplier;
                        Multiplier = Multiplier * 10;
                    end          
                end
            end
            i = i + 1;
        catch
            if fail < 3
                time = clock;
                code = [num2str(time(4)), num2str(time(5)), num2str(uint16(time(6)))];
                FileName = ['D:\OneDrive\Poker\Europe\M Files\Listed\12 Errors\Stacks\StacksError',code ,'.mat'];
                save(FileName,'IMG');
                disp(['GetStacks caught an error - ',code]);      

                PlayersIn = GetIsIn(HMT, WT, WC);
                if PlayersIn(i) == 1
                    fail = fail + 1;
                    Output(i) = 0;
                    continue
                else
                    i = i + 1;
                end
            else
                fail = 0;
                i = i + 1;
            end
        end
    else
        i = i + 1;
    end
end


%Display IMG for development:

% disp(Output)
% figure(88)
% pos = 1;
% for i = 1:6
%     subplot(6,2,pos)
%     subimage(ErrorMatrix{i,1});
%     pos = pos + 2;
% end

end