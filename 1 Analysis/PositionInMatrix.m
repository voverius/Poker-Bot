function [EVPosition1, EVPosition2] = PositionInMatrix(InputCardRange)

Output = zeros(1,2);

for i = 1:2
    if strcmp(InputCardRange(i),'A') == 1
        Output(1,i) = 1;
    elseif strcmp(InputCardRange(i),'K') == 1
        Output(1,i) = 2;
    elseif strcmp(InputCardRange(i),'Q') == 1
        Output(1,i) = 3;
    elseif strcmp(InputCardRange(i),'J') == 1
        Output(1,i) = 4;
    elseif strcmp(InputCardRange(i),'T') == 1
        Output(1,i) = 5;
    elseif isstrprop(InputCardRange(i),'digit')
        Output(1,i) = 15 - str2double(InputCardRange(i));
    end
end

if strcmp(InputCardRange(3),'o')
    Output(1,2:-1:1) = Output(1,1:2);
end

EVPosition1=Output(1,1);
EVPosition2=Output(1,2);
end