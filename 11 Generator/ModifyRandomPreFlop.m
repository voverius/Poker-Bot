function Output = ModifyRandomPreFlop(gs)

%Circshifting this badboy
Output = gs;
gs(:,1:4) = Output(:,3:6);
gs(:,5:6) = Output(:,1:2);

%finding where last time FillHH was used
if isnumeric(Output{3,4}) == 1 %brand new run
    FirstRun = 0;
    CL = 7;
    i = 0;
else
    CL = Output{3,4}{12};
    FirstRun = 1;
    
    for j = 1:6
        if gs{1,j} == 1
            i = j - 1;
            break
        end
    end
end


quit = 0;
while quit == 0
    
    i = i + 1;
    if i > 6
        i = i - 6;
        CL = CL + 1;
        if CL > size(gs,1)
            break
            
        end
    end
    
    if gs{1,i} == 0 
        continue
    elseif gs{1,i} == 1
        if FirstRun == 1
            FirstRun = 0;
        else
            break
        end
    elseif isempty(gs{CL,i})
        continue
    end
    
    temp = gs{CL,i};
    if temp(1) == 1;
        gs(CL,i) = gs(5,i);
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
end
    
    
%shift the matrix back
Output(:,1:2) = gs(:,5:6);
Output(:,3:6) = gs(:,1:4);
end