% function  HH = ModifyRandomPostFlop(HH,street)

for j = 1:6
    if HH{1,j,1} == 1
        JumpStreet = 0;
        Starti = j - 1;
        i = j - 1;
        break
    end
end


%What position was filled last:
if street == HH{3,4,1}{13}
    %this has to continue where left off
    CL = HH{3,4,1}{12};
    FirstRun = 1;
else
    %This has to jump a street back and fix that one
    FirstRun = 0;
    if street == 2
        %Pre-flop is sorted in 'ModifyRandomPreFlop'
        i = 0;
        CL = 7;
        Starti = i;
    else
        street = street - 1;
        CL =  HH{3,4,1}{12};
        JumpStreet = 1;
        FirstRun = 1;
    end
end


quit = 0;
while quit == 0
    
    i = i + 1;
    if i > 6
        i = i - 6;
        CL = CL + 1;
        if i == Starti
            if JumpStreet == 1
                street = street + 1;
                JumpStreet = 0;
                CL = 7;
                i = 0;
                continue     
            else
                break
            end
        elseif CL > size(HH,1)
            break
        end
    end
    
    if HH{1,i,street} == 0 
        continue
    elseif HH{1,i,street} == 1
        if FirstRun == 1
            FirstRun = 0;
        else
            break
        end
    elseif isempty(HH{CL,i,street})
        continue
    end
    
    temp = HH{CL,i,street};
    if temp(1) == 1;
        HH(CL,i,street) = HH(5,i,street); %#ok<*SAGROW>
    elseif temp(1) == 2
        if temp(4) == 1
            HH{CL,i,street} = temp(5) + HH{5,i,street};
        else
            HH{CL,i,street} = temp(6);
        end
    elseif temp(1) == 3
        HH{CL,i,street} = temp(5);
    elseif temp(1) == 4
        HH{CL,i,street} = temp(6);
    end
end
% end