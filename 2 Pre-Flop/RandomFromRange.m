function [Output1, Output2] = RandomFromRange(Input1, Input2)

if strcmp(Input1(1),Input1(2))
    combo = uint8([1,2;1,3;1,4;2,3;2,4;3,4]);
elseif strcmp(Input1(3),'s')
    combo = uint8([1,1;2,2;3,3;4,4]);
elseif strcmp(Input1(3),'o')
    combo = uint8([1,2;1,3;1,4;2,1;2,3;2,4;3,1;3,2;3,4;4,1;4,2;4,3]);
end

Cards = uint8(zeros(1,2));
for i = 1:2
    if strcmp(Input1(1,i),'T') 
        Cards(1,i) = 100;
    elseif strcmp(Input1(1,i),'J') 
        Cards(1,i) = 110;
    elseif strcmp(Input1(1,i),'Q') 
        Cards(1,i) = 120;    
    elseif strcmp(Input1(1,i),'K')
        Cards(1,i) = 130;
    elseif strcmp(Input1(1,i),'A')
        Cards(1,i) = 140;
    elseif isstrprop(Input1(1,i),'digit')
        Cards(1,i) = str2double(Input1(1,i))*10;
    end
end


combo(:,1) = combo(:,1) + Cards(1);
combo(:,2) = combo(:,2) + Cards(2);

for i = 1:size(Input2,2)
    
     temp = combo(:,1) == Input2(i) | combo(:,2) == Input2(i);
     combo(temp,:) = [];
end


if size(combo,1) ~= 0
    Output = combo(randi(size(combo,1)),:);
    Output1 = Output(1);
    Output2 = Output(2);
else 
    Output1 = uint8(0);
    Output2 = uint8(0);
end



end
