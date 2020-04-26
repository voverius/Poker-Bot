clear all
load SM


HandCount = 1;
PlayerCount = 1;
HeroName = 'Metaliuga';
HistoryFileName = ('D:\OneDrive\Poker\Europe\HH\Work\H2.txt');
%HistoryFileName = ['D:/DropBox/Dropbox/PokerboT/Justas/WhiteSnake/HH/',FileStatus(44).name];

Text = textread(HistoryFileName, '%s', 'delimiter', '\n', 'whitespace', '');
CurrentLine = 1;
NickNameSummary = cell(1,1);
HHcSummary = cell(1,1);
HandCount = HandCount + 1;

%opening a file with rake values
RakeFileName = 'D:\OneDrive\Poker\Europe\M Files\Listed\15 Constants\PS_Rakes.mat';
load(RakeFileName);
  
PokerTracker; %This launches the Poker Tracker
