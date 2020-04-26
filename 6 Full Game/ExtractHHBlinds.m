function Output = ExtractHHBlinds(HistoryFileName)

Output = zeros(2,1);
fid = fopen(HistoryFileName);
Text = textscan(fid, '%s', 'delimiter', '\n', 'whitespace', '');
fclose(fid);
Text = Text{1};
 
MaxLine = size(Text,1);
Quit = zeros(2,1); 
        
for i = 1:MaxLine
    Row = Text{i};
    if Quit(1) == 0
        if strfind(Row,': posts small b') > 1
            spaces = strfind(Row, ' ');
            Name = Row((spaces(size(spaces,2))+2):size(Row, 2));
            Output(1) = sscanf(Name,'%f');  
            Quit(1) = 1;
        end
    end
    if Quit(2) == 0
        if strfind(Row,': posts big b') > 1
            spaces = strfind(Row, ' ');
            Name = Row((spaces(size(spaces,2))+2):size(Row, 2));
            Output(2) = sscanf(Name,'%f');  
            Quit(2) = 1;
        end
    end    
    if all(Quit == 1)
        break
    end
end
end