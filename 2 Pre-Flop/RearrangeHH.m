function [Output,arr] = RearrangeHH(TH,Button,Blinds)

arr = zeros(1,6);
OT = TH;
OT(:,7:12) = TH;
OT(:,(7+Button):12) = [];
OT(:,1:Button) = [];
SBPos = 0;
BBPos = 0;
Output = cell(8,6);
Output(1,:) = {0};

%Sorting Out Blinds
for i = 1:6 
    if OT{1,i} == 0
        continue
    elseif OT{5,i} == 0 && OT{7,i} == 0
        continue
    elseif SBPos == 0
        SBPos = i;
    elseif BBPos == 0
        BBPos = i;
        break
    end
end

if Blinds(1) == 0 && Blinds(2) == 0
    Blinds(1) = OT{7,SBPos};
    Blinds(2) = OT{7,BBPos};
    BR = Blinds(2)/Blinds(1); %Blinds Ratio
    if BR <= 2.5 && BR >= 1
        Output(:,1) = OT(:,SBPos);
        Output(:,2) = OT(:,BBPos);
        Output(5,1) = OT(7,SBPos);
        Output(5,2) = OT(7,BBPos);
        OT(:,1:BBPos) = [];
        arr(Output{1,1}) = 1;
        arr(Output{1,2}) = 2;
    elseif BR < 1 %SB raised or called previous raise
        Output(:,1) = OT(:,SBPos);
        Output(:,2) = OT(:,BBPos);
        Output(5,2) = OT(7,BBPos);
        Blinds(1) = Blinds(2)/2;
        Output{5,1} = Blinds(1);
        OT(:,1:BBPos) = [];
        arr(Output{1,1}) = 1;
        arr(Output{1,2}) = 2;
    else
        Output{1,1} = 0; %no SB
        Output(:,2) = OT(:,SBPos);
        Output(5,2) = OT(7,SBPos);
        Blinds(2) = Blinds(1);
        Blinds(1) = Blinds(2)/2;
        OT(:,1:SBPos) = [];
        arr(Output{1,2}) = 2;
    end
else
    if OT{7,SBPos} == Blinds(1) && OT{7,BBPos} == Blinds(2)
        Output(:,1) = OT(:,SBPos);
        Output(:,2) = OT(:,BBPos);
        Output{5,1} = Blinds(1);
        Output{5,2} = Blinds(2);
        OT(:,1:BBPos) = [];
        arr(Output{1,1}) = 1;
        arr(Output{1,2}) = 2;
    elseif OT{7,BBPos} == Blinds(2)
        Output(:,1) = OT(:,SBPos);
        Output(:,2) = OT(:,BBPos);
        Output{5,1} = Blinds(1);
        Output{5,2} = Blinds(2);
        OT(:,1:BBPos) = [];   
        arr(Output{1,1}) = 1;
        arr(Output{1,2}) = 2;
    elseif OT{7,SBPos} == Blinds(1)
        Output{1,1} = 0; %no SB
        Output(:,2) = OT(:,SBPos);
        Output{5,2} = Blinds(2);
        OT(:,1:SBPos) = [];
        arr(Output{1,2}) = 2;
    end
end

flag = 6;
for i = size(OT,2):-1:1
    if OT{1,i} == 0
        continue
    else
        Output(:,flag) = OT(:,i);
        arr(Output{1,flag}) = flag;
        flag = flag - 1;
    end
end

Output{3,3} = Blinds;
Output{4,3} = arr;
Output(7,:) = Output(8,:);
Output(8,:) = {[]};
end