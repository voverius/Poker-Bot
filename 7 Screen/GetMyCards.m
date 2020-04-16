function [Output,ErrorMatrix] = GetMyCards(HMT, WT, WC)

Output = uint8(zeros(1,2));
ErrorMatrix = cell(2,2);
Temp = zeros(1,13);
Temp2 = zeros(1,4);
OT = zeros(2,2);
bwfactor = 0.8;

if HMT == 1
    Offset = (WC-1) * 1920;
    NumberHeight = 22;
    NumberWidth = 25;
    SuitHeight = 23;
    SuitWidth = 23;
    SuitSpacing = 28;
    CardSpacing = 85;
    
%               Width position            , Height position  , Width      , Height    
    Position = [879 + Offset              , 667              , NumberWidth, NumberHeight;...
                879 + Offset              , 667 + SuitSpacing, SuitWidth  , SuitHeight;...
                879 + Offset + CardSpacing, 667              , NumberWidth, NumberHeight;...
                879 + Offset + CardSpacing, 667 + SuitSpacing, SuitWidth  , SuitHeight];    

    VariableName = 'CardTemplates1';
    eval(['load ',VariableName]);
    eval(['template = ',VariableName,';']);
    
elseif HMT == 2
    Offset = (WC-1) * 1920;
    Offset2 = 960 * (WT-1);
    NumberHeight = 17;
    NumberWidth = 18;
    SuitHeight = 15;
    SuitWidth = 15;
    SuitSpacing = 21;
    CardSpacing = 60;

%               Width position                      , Height position  , Width      , Height    
    Position = [422 + Offset + Offset2              , 438              , NumberWidth, NumberHeight;...
                422 + Offset + Offset2              , 438 + SuitSpacing, SuitWidth  , SuitHeight;...
                422 + Offset + Offset2 + CardSpacing, 438              , NumberWidth, NumberHeight;...
                422 + Offset + Offset2 + CardSpacing, 438 + SuitSpacing, SuitWidth  , SuitHeight]; 
    VariableName = 'CardTemplates2';
    eval(['load ',VariableName]);
    eval(['template = ',VariableName,';']);
    
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
    
    Width = 477 + Offset + Offset2;
    Height = 200 + Offset3;
    NumberHeight = 12;
    NumberWidth = 11;
    SuitHeight = 11;
    SuitWidth = 10;
    SuitSpacing = 15;
    CardSpacing = 45;
    
%               Width position                      , Height position            , Width      , Height    
    Position = [543 + Offset + Offset2              , 344 + Offset3              , NumberWidth, NumberHeight;...
                543 + Offset + Offset2              , 344 + Offset3 + SuitSpacing, SuitWidth  , SuitHeight;...
                543 + Offset + Offset2 + CardSpacing, 344 + Offset3              , NumberWidth, NumberHeight;...
                543 + Offset + Offset2 + CardSpacing, 344 + Offset3 + SuitSpacing, SuitWidth  , SuitHeight];    
    
    VariableName = 'CardTemplates4';
    eval(['load ',VariableName]);
    eval(['template = ',VariableName,';']);    
end



%__________________________________ GETTING CARDS _______________________________________

i = 1;
fail = 0;
quit = 0;
while i < 5
    IMG = SS(Position(i,1), Position(i,2), Position(i,3), Position(i,4), bwfactor);
    ErrorMatrix{i} = IMG;
    try
        if rem(i,2) ~= 0
            for j = 1:13
                Temp(j) = corr2(template{j},IMG);   %#ok<USENS>
            end
            if i > 1
                OT((i-1),1) = find(Temp == max(Temp));
            else
                OT(i,1) = find(Temp == max(Temp));
            end
            i = i + 1;
        else
            for j = 1:4
                Temp2(j) = corr2(template{j+13},IMG); 
            end
            OT((i/2),2) = find(Temp2 == max(Temp2));
            i = i + 1;
        end
    catch
        if fail < 3
            if all(all(IMG == 0)) == 0
                time = clock;
                code = [num2str(time(4)), num2str(time(5)), num2str(uint8(time(5)*10000))];
                FileName = ['D:\OneDrive\Poker\Europe\M Files\Listed\12 Errors\MyCardsError', code ,'.mat'];
                save(FileName,'IMG');
                disp(['GetMyCards caught an error - ',code]);                

                fail = fail + 1;
                continue
            else
                quit = 1;
                break
            end
        else
            fail = 0;
            i = i + 1;
        end
    end
end

if quit == 0
    for i = 1:2
        OutputTemp = (OT(i,1) + 1) * 10;
        Output(i) = OutputTemp + OT(i,2);
    end
end
end