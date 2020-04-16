HMT = 4;
WC = 2;
WT = 1;
Photos = cell(6,HMT);
PhotoPlot = figure(69);

if HMT == 1
    Resize = [13, 9];
    Check = [16, 20];
    Width2 = [200, 206];    
elseif HMT == 2
    Resize = [10 6];
    Check = [13, 15];
    Width2 = [150, 154];    
elseif HMT == 4
    Resize = [8 5];
    Check = [10, 13];
    Width2 = [110, 116];
end

for i = 1:HMT
    bwfactor = 0.8;

    if HMT == 1
        Offset = (WC-1)*1920;
        Width = 739 + Offset;
        Height = 402;
        NumberHeight = 22;
        NumberWidth = 25;
        SuitHeight = 23;
        SuitWidth = 23;
        SuitSpacing = 28;
        CardSpacing = 91;

        VariableName = 'CardTemplates1';
        eval(['load ',VariableName]);
        eval(['template = ',VariableName,';']);

        Position = [(Width + CardSpacing*0), Height;...
                    (Width + CardSpacing*1), Height;...
                    (Width + CardSpacing*2), Height;...
                    (Width + CardSpacing*3), Height;...
                    (Width + CardSpacing*4), Height];

    elseif HMT == 2
        Offset = (WC-1)*1920;
        Offset2 = 960 * (WT-1);
        Width = 323 + Offset + Offset2;
        Height = 248;
        NumberHeight = 17;
        NumberWidth = 18;
        SuitHeight = 15;
        SuitWidth = 15;
        SuitSpacing = 21;
        CardSpacing = 65;

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
        CardSpacing = 46;

        VariableName = 'CardTemplates4';
        eval(['load ',VariableName]);
        eval(['template = ',VariableName,';']);
    end

     

    Pos = i;
    for j = 1:6
        IMG = SS(Position(j,1), Position(j,2), Position(j,3), Position(j,4), bwfactor);
        Photos{j,WT} = IMG;
        subplot(6,HMT,Pos);
        subimage(IMG);
        Pos = Pos + HMT;
    end
    WT = WT + 1;

end





















