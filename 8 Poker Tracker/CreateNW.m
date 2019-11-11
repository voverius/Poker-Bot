% function CreateNW V1.0 - Creates Nickname matrix & NewWayOfLife cubes

NWMatrix = cell(6,2);

for a = 1:6
    if ~isempty(HH{1,a,1})
        Nickname = HH{1,a,1};
        VarNick = Nickname;
        VarNick = regexprep(VarNick,'[^a-zA-Z0-9]','');    
        NWMatrix{a,2} = VarNick;

        NW = zeros(1,11,4); %New Way Cube            
        flag = 0;
        for b = 1:4
            NWrow = 1;
            for c = 6:size(HH,1)
                if size(HH{c,a,b}) > 0
                    temp = HH{c,a,b};
                    NW(NWrow,:,b) = temp;
                    NWrow = NWrow + 1;
                elseif c == 6
                    flag = 1;
                    break
                end
            end
            if flag == 1
                break
            end
        end

        NWMatrix{a,1} = NW;
    end
end