function Output = ExtractHHNames(HistoryFileName)

Output = cell(6,1);
Hero = 'Metaliuga';

try
    fid = fopen(HistoryFileName);
    Text = textscan(fid, '%s', 'delimiter', '\n', 'whitespace', '');
    fclose(fid);
    Text = Text{1};

    CL = size(Text,1);
    flag = 0;

    if CL < 100
        LastLine = 1;
    else
        LastLine = 100;
    end

    for i = CL : -1 : (CL-100)
        Row = Text{i};
        if strfind(Row, 'PokerStars Hand #') > 0 %PokerStars Zoom Hand #
            CL = i + 2;
            for j = CL : (CL + 5)
                Row = Text{j};
                if strfind(Row, 'Seat ') == 1
                    if strcmp(' ',Row(size(Row,2))) == 1
                        Row(size(Row,2)) = '';
                    end

                    Position = sscanf(Row(6),'%f');
                    spaces = strfind(Row, ' ');
                    spacesSize = size(spaces);
                    Name = Row((spaces(2)+ 1):(spaces((spacesSize(2)-2))-1));

                    Output{Position} = Name;
                    flag = 1;
                else
                    break
                end
            end
        end
        if flag == 1
            break
        end
    end

    for i = 1:6
        if strcmp(Output{i},Hero) == 1
            if i~=1
                OT = Output;
                OT(7:12) = Output;
                OT((i+6):12) = [];
                OT(1:(i-1)) = [];
                Output = OT;
            end
            break
        end
    end
catch
    Output = 1;
    try %#ok<TRYNC>
        disp('caught an error Extracting HH Names');
        time = clock;
        code = [num2str(time(4)), num2str(time(5)), num2str(uint16(time(6)))];
        FileName = ['D:\OneDrive\Poker\Europe\M Files\Listed\12 Errors\ExtractNames\ExtractNames',code,'.mat'];
        save(FileName,'Text');        
    end
end
end