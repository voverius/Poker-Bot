% function UpdatePT
clear all %change the folder for HH when turning back into a working function
% SM = zeros(2464,3); %Strength matrix
load SM

%Set global variables
NickNameSummary = cell(1,1);
HHcSummary = cell(1,1);
HeroName = 'Metaliuga';

%This defines the folder where the hand history is held
HistoryFolder = 'D:/OneDrive/Poker/Europe/HH/Metaliuga/Work/';


%opening a file with file names, dates & last read lines
FileHistoryMat = 'D:/OneDrive/Poker/Europe/HH/FileHistory.mat';

if exist('FileHistory','var') == 1

elseif exist(FileHistoryMat,'file') == 2
    load(FileHistoryMat);
else
    FileHistory = cell(1,3);
end

%opening a file with rake values
RakeFileName = 'D:\OneDrive\Poker\Europe\M Files\Listed\15 Constants\PS_Rakes.mat';
load(RakeFileName);
    
%Checking the status of all files in the folder where hand history (HH) is saved   
FileStatus=dir([HistoryFolder,'*.txt']);
HandCount = 1;
PlayerCount = 1;
for w = 1:size(FileStatus,1);
    
    CurrentLine = 1;
    for x  = size(FileHistory,1):-1:1
        
        if strcmp(FileStatus(w).name,FileHistory(x,1)) == 1 % This checks if the file exists in the log
            
            CurrentFileDate = datevec(FileStatus(w).date,'dd-mmm-yy HH:MM:SS');
            CheckedFileDate = datevec(FileHistory(x,2),'dd-mmm-yy HH:MM:SS');
            DateComparisonBigger = (CurrentFileDate > CheckedFileDate);
            DateComparisonEqual = (CurrentFileDate == CheckedFileDate);

            for y = 1:6
                
                if DateComparisonBigger(y) == 1
                    
                    CurrentLine = FileHistory{x,3};
                    
                        HistoryFileName = [HistoryFolder,FileStatus(w).name];
                        fid = fopen(HistoryFileName);
                        Text = textscan(fid, '%s', 'delimiter', '\n', 'whitespace', '');
                        fclose(fid);
                        Text = Text{1};
                        PokerTracker; %This launches the Poker Tracker
                    
                    FileHistory{x,2} = FileStatus(w).date;
                    FileHistory{x,3} = CurrentLine;
                    
                  break
                elseif DateComparisonEqual(y) == 1
                    
                  continue
                elseif DateComparisonBigger(y) == 0 && DateComparisonEqual(y) == 0
                    
                    disp('Previously checked file',FileStatus(w).name,'is newer than the current file on drive');
                end
                
            end

            break
        elseif x == 1; %This creates a new file to the log
            
            FileHistory{size(FileHistory,1)+1,1} = FileStatus(w).name;
            FileHistory{size(FileHistory,1),2} = FileStatus(w).date;
            CurrentLine = 1;
            
                    HistoryFileName = [HistoryFolder,FileStatus(w).name];
                    fid = fopen(HistoryFileName);
                    Text = textscan(fid, '%s', 'delimiter', '\n', 'whitespace', '');
                    fclose(fid);
                    Text = Text{1}; %#ok<*NASGU>
                    PokerTracker; %This launches the Poker Tracker

            FileHistory{size(FileHistory,1),3} = CurrentLine;
            
            
            break
        end
        
    end
end

save('D:\OneDrive\Poker\Europe\M Files\Listed\13 Development\SM.mat','SM')

%Sorting Out The Variables
% if size(NickNameSummary,1) > 2
%     NickNameSummary(1) = [];
%     NickNameSummary = unique(NickNameSummary);
% 
%     for i = 1:size(NickNameSummary,1)
%         FileName = ['D:\OneDrive\Poker\Europe\PT Files\Work\',NickNameSummary{i},'.mat'];
%         save(FileName,NickNameSummary{i});
%     end
% end


%  HHcSummary(1,:) = [];
%  HHcSummary = unique(HHcSummary);
% 
% for i = 1:size(HHcSummary,1)
%      FileName = ['D:/DropBox/Dropbox/Poker/Justas/WhiteSnake/HHc/',HHcSummary{i},'.mat'];    
%      save(FileName,HHcSummary{i});
%      
%      TempVar = HHcSummary{i}; %This is the HHc_* variable
%      TempVar2 = ['PT_',TempVar(5:length(TempVar))]; % This is for PT_* variable
%      
%      TempVar = eval(TempVar);
%      TempVar2 = eval(TempVar2);
%      TempVar(1,:) = [];
% 
%      AnalHH(TempVar, TempVar2); %Launches the ANALYZER
% 
% end
%     save(FileHistoryMat,'FileHistory');

% end

