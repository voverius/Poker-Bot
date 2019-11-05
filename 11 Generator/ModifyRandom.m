function Output = ModifyRandom(gs)

for i = 1:6
    if gs{1,i} == 1
        Hero = i;
        break
    end
end


%finding where last time FillHH was used
%gs = circshift(gs,[0 (6 - Hero)]); %This should be used for further streets?

%Circshifting this badboy
Output = gs;
gs(:,1:4) = Output(:,3:6);
gs(:,5:6) = Output(:,1:2);

if isnumeric(Output{3,4}) == 1 %brand new run
    FurtherAction = 0;
    CL = 7;
    i = 0;
else
    FurtherAction = 1;
    i = Hero - 2;
    if i < 1
        i = i + 6;
    end
    for j = 7 : size(gs,1)
        if size(gs{j,i},2) == 1 
            CL = j;
            i = i - 1;
            break
        end
    end
end

quit = 0;
expanded = 0;
while quit == 0
    
    i = i + 1;
    if i > 6
        i = i - 6;
        CL = CL + 1;
        if CL > size(gs,1)
            gs{CL,1} = [];
            expanded = 1;
        end
    end
    
    if gs{1,i} == 0 
        continue
    elseif gs{1,i} == 1
        if FurtherAction == 1
            FurtherAction = 2;
        else
            break
        end
    elseif size(gs{CL,i},2) == 0
        continue
    end
    
    temp = gs{CL,i};
    if size(temp,2) == 1
        %Do nothing
    elseif temp(1) == 1;
        gs{CL,i} = 0;
    elseif temp(1) == 2
        if temp(4) == 1
            gs{CL,i} = temp(5) + gs{5,i};
        else
            gs{CL,i} = temp(6);
        end
    elseif temp(1) == 3
        gs{CL,i} = temp(5);
    elseif temp(1) == 4
        gs{CL,i} = temp(6);
    end
    
    expanded = 0;
end
    
    
%shift the matrix back
Output(:,1:2) = gs(:,5:6);
Output(:,3:6) = gs(:,1:4);

if expanded == 1
    Output(CL,:) = [];
end
end