HMT = 4;
WC = 3;
WT = 1;
Photos = cell(5,HMT,2);
PhotoPlot = figure(69);

for i = 1:HMT
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

%For board development    
    
%     Pos = (2*i)-1;
%     for j = 1:2
%         %Getting the number
%         IMG = SS(Position(j,1), Position(j,2), NumberWidth, NumberHeight, bwfactor);
%         Photos{j,WT,1} = IMG;
%         subplot(5,HMT*2,Pos);
%         subimage(IMG);
%         
%         %Getting the suit
%         IMG = SS(Position(j,1), Position(j,2) + SuitSpacing, SuitWidth, SuitHeight, bwfactor);
%         Photos{j,WT,2} = IMG;
%         subplot(5,HMT*2,Pos+1);
%         subimage(IMG);
%         
%         Pos = Pos + HMT*2;
%     end



%For hand development:

    Pos = i;
    for j = 1:4
        if j < 3
            Pos2 = 1;
        else
            Pos2 = 2;
        end
        
        IMG = SS(Position(j,1), Position(j,2), Position(j,3), Position(j,4), bwfactor);
        if rem(j,2) == 0
            Photos{Pos2,WT,2} = IMG;
        else
            Photos{Pos2,WT,1} = IMG;
        end
        subplot(4,HMT,Pos);
        subimage(IMG);
        
        Pos = Pos + HMT;
    end

    WT = WT + 1;

end