function gs = FillInPT(gs,rank)

Random = ischar(rank);
if Random == 1
    FolderName{1,1} = 'D:\OneDrive\Poker\Europe\PT Files\Ranked\TOP 10000\';
    FolderName{2,1} = 'D:\OneDrive\Poker\Europe\PT Files\Ranked\TOP 1000\';
    FolderName{3,1} = 'D:\OneDrive\Poker\Europe\PT Files\Ranked\TOP 100\';
    FolderName{4,1} = 'D:\OneDrive\Poker\Europe\PT Files\Ranked\The Rest\';
elseif rank >= 10000
    FolderName = 'D:\OneDrive\Poker\Europe\PT Files\Ranked\TOP 10000\'; %Over 10'000 habds
elseif rank >= 1000
    FolderName = 'D:\OneDrive\Poker\Europe\PT Files\Ranked\TOP 1000\'; %Over 1'000 hands
elseif rank >= 100 
    FolderName = 'D:\OneDrive\Poker\Europe\PT Files\Ranked\TOP 100\'; %Over 100 hands
else
    FolderName = 'D:\OneDrive\Poker\Europe\PT Files\Ranked\The Rest\'; %Less than 100 hands
end

if Random == 0
    FileStatus=dir([FolderName,'*.mat']);
    Size1 = size(FileStatus,1);
    Size2 = size(gs,2);
    Previous = zeros(Size2,1);

    for i = 1:Size2
        if gs{1,i,1} == 1
            continue
        end

        quit = 0;
        while quit == 0
            Q = randi(Size1);
            if any(Previous == Q)
                continue
            end
            FileName = [FolderName,FileStatus(Q).name];
            Previous(i) = Q;
            quit = 1;
            load(FileName);
            Nick = FileStatus(Q).name;
            Nick = Nick(1:(length(Nick)-4));

            PT = eval(Nick);
            gs{6,i} = PT;      
        end
    end
else
    FileMatrix = cell(4,2);
    for i = 1:4
        FileMatrix{i,1} = dir([FolderName{i,1},'*.mat']);
        FileMatrix{i,2} = size(FileMatrix{i,1},1);
    end
    Size2 = size(gs,2);
    Previous = zeros(Size2,4);
    
    for i = 1:Size2
        if gs{1,i,1} == 1
            continue
        end
        
        quit = 0;
        while quit == 0
            W = randi(4);
            Q = randi(FileMatrix{W,2});
            if any(Previous == Q)
                continue
            end            
            FileName = [FolderName{W,1},FileMatrix{W,1}(Q).name];
            Previous(i,W) = Q;
            quit = 1;
            load(FileName);
            Nick = FileMatrix{W,1}(Q).name;
            Nick = Nick(1:(length(Nick)-4));

            PT = eval(Nick);
            gs{6,i} = PT;      
        end
    end
end  
end