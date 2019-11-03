function HH = GetMyMove(HMT, WT, WC, HH, street) 

%HMT - How Many Tables
%WT - Which Table
%WC - Which Screen
%This will determine from which area a screenshot of what size will be taken

for i = 1:6
    if HH{1,i,1} == 1
        LastMoneyz = HH{5,i,street};
        Hero = i;
    end
end

quit = 0;
while quit == 0
    Moneyz = GetMoneyz(HMT, WT, WC, 2);
    if Moneyz ~= LastMoneyz
        for i = 7:size(HH,1)
            if size(HH{i,Hero,street},2) == 0 
                HH{i,Hero,street} = Moneyz;
                break
            end
        end
        break
    end
    
    quit = GetMyFold(HMT, WT, WC);
end
end
    