% function PT = RANDtopPT

HistoryFolder = 'D:\OneDrive\Poker\Europe\PT Files\Random\';
FileStatus=dir([HistoryFolder,'*.mat']);
asd = size(FileStatus,1);

for i = 1:asd

%     Q = randi(size(FileStatus,1));
    HistoryFileName = [HistoryFolder,FileStatus(i).name];

    Nick = FileStatus(i).name;
    Nick = Nick(1:(length(Nick)-4));

    load(HistoryFileName);
    PT = eval(Nick);

    if PT{1,2} > 1000 && PT{1,2} <= 10000 %MINIMUM AMMOUNT OF HANDS REQUIRED
        newFolder = 'D:\OneDrive\Poker\Europe\PT Files\Ranked\TOP 1000\';
        HistoryFileName = [newFolder,FileStatus(i).name];
        save(HistoryFileName,Nick) 
    elseif PT{1,2} > 100
        newFolder = 'D:\OneDrive\Poker\Europe\PT Files\Ranked\TOP 100\';
        HistoryFileName = [newFolder,FileStatus(i).name];
        save(HistoryFileName,Nick) 
    else
        newFolder = 'D:\OneDrive\Poker\Europe\PT Files\Ranked\The Rest\';
        HistoryFileName = [newFolder,FileStatus(i).name];
        save(HistoryFileName,Nick) 
        
    end
end
% end