function PT = RandomPT


%____________________________________________________________________________________________________________
                                            %PICKING A RANDOM PLAYER
Cease = 0;

HistoryFolder = 'D:\OneDrive\Poker\Europe\PT Files\Random\';
FileStatus=dir([HistoryFolder,'*.mat']);
    
while Cease ==0

    Q = randi(size(FileStatus,1));
    HistoryFileName = [HistoryFolder,FileStatus(Q).name];

    Nick = FileStatus(Q).name;
    Nick = Nick(1:(length(Nick)-4));

    load(HistoryFileName);
    PT = eval(Nick);

    if PT{1,2} > 500 %MINIMUM AMMOUNT OF HANDS REQUIRED
        Cease = 1;
    end
end



end