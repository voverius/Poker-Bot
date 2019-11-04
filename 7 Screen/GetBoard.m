function [Output,ErrorMatrix] = GetBoard(HMT, WT, WC, street)

%HMC - How Many Tables
%WT - Which Table
%WC - Which Screen
%This will determine from which area a screenshot of what size will be taken

if street == 2
    TempOutput = zeros(3,2);
    Output = uint8(zeros(1,3));
    ErrorMatrix = cell(3,2);
else
    TempOutput = zeros(1,2);
    Output = uint8(zeros(0));
    ErrorMatrix = cell(3,2);
end

Temp = zeros(1,13);
Temp2 = zeros(1,4);
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

if street == 2
    Position = [(Width + CardSpacing*0), Height;...
                (Width + CardSpacing*1), Height;...
                (Width + CardSpacing*2), Height];
else
    Position = [(Width + CardSpacing*street), Height];
end


%__________________________________ GETTING CARDS _______________________________________

for i = 1:size(Position,1)
    %Finding the card number
    CurrentPosition = [Position(i,1), Position(i,2), NumberWidth, NumberHeight];
    IMG = SS(CurrentPosition(1), CurrentPosition(2), CurrentPosition(3), CurrentPosition(4), bwfactor);
    for j = 1:13
        Temp(j) = corr2(template{j},IMG);  %#ok<USENS>
    end
    TempOutput(i,1) = find(Temp == max(Temp));
    
    %Finding the card suit
    CurrentPosition = [Position(i,1), Position(i,2) + SuitSpacing, SuitWidth, SuitHeight];
    IMG = SS(CurrentPosition(1), CurrentPosition(2), CurrentPosition(3), CurrentPosition(4), bwfactor);
    for j = 1:4
        Temp2(j) = corr2(template{j+13},IMG); 
    end
    TempOutput(i,2) = find(Temp2 == max(Temp2));
end

for i = 1:size(TempOutput,1)
    OutputTemp = (TempOutput(i,1) + 1) * 10;
    Output(i) = OutputTemp + TempOutput(i,2);
end

end