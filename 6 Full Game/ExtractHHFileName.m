function Output = ExtractHHFileName(CardsMatrix)

    Output = '';
    HistoryFolder = 'D:/OneDrive/Poker/Europe/HH/Metaliuga/Metaliuga/';
    FileStatus=dir([HistoryFolder,'*.txt']);

    try
        for i = 1:size(FileStatus,1)
            HistoryFileName = [HistoryFolder,FileStatus(i).name];

            fid = fopen(HistoryFileName);
            Text = textscan(fid, '%s', 'delimiter', '\n', 'whitespace', '');
            fclose(fid);
            Text = Text{1};

            CL = size(Text,1);
            LastJ = CL;
            Count = 1;
            if CL < 200
                stop = 1;
            else
                stop = CL - 200;
            end
            for j = CL: -1: stop
                Row = Text{j};
                Cards = CardsMatrix{1,1,Count};
                if strfind(Row, Cards) > 1
                    Count = Count + 1;
                    if Count == 4
                        Output = HistoryFileName; 
                        break
                    end   
                end
            end
        end
    catch
        Output = '';
    end
end