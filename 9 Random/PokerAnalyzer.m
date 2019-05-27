function PokerAnalyzer
%%% Graphical interface for analyzing a game of Texas Hold'em. %%%
% See PokerHelp.txt for more information.

% Tim Farajian 12/2004
% tfarajia@mathworks.com

rand('state',sum(100*clock)); %Set random state

%%% Create figure and axis %%%
ss = get(0,'Screensize');
H.hFig = figure('Name','Texas Hold''em Analyzer','NumberTitle','off','Tag','Stopped',...
    'menubar','none','DoubleBuffer','on','color',[1 1 1],'units','normalized',...
    'pos',[.1 .1 .8 .8],'resize','off');

H.hAxis = axes('Position',[0 0 1 1],'XTick',[],'YTick',[],'color',0.6*[1 1 1]);
axis([0 30 0 30])

%%% Create buttons %%%
H.hSimButton = uicontrol('Style','pushbutton','Units','normalized',...
    'Position',[.645 0.0452 0.1071 2*0.0476],'String','Simulate',...
    'callback',@Simulate,'Fontsize',14); %Simulate button
H.hDealButton = uicontrol('Style','pushbutton','Units','normalized',...
    'Position',[0.645 0.90 0.1071 0.0476],'String','Deal',...
    'callback',@DealClick,'Fontsize',12); %Deal button
H.hClearButton = uicontrol('Style','pushbutton','Units','normalized',...
    'Position',[0.645 0.85 0.1071 0.0476],'String','Clear',...
    'callback',@ClearClick,'Fontsize',12); %Clear button
H.hHelpButton = uicontrol('Style','pushbutton','Units','normalized',...
    'Position',[0.645 0.80 0.1071 0.0476],'String','Help',...
    'callback',@HelpCallback,'Fontsize',10); %Help button

%%% Create radiobuttons %%%
H.hRadio(1) = uicontrol('Style','radiobutton', 'Units','normalized',...
    'Position',[0.0339 .05 .2 .04],'String',' Win Percentage',...
    'Value', 1, 'callback', @WinClick,'tooltip','100*(#Wins)/(#Games)',...
    'Fontsize',12,'FontUnits','normalized','backg',get(H.hAxis,'color'));
H.hRadio(2) = uicontrol('Style','radiobutton', 'Units','normalized',...
    'Position',[0.0339 .095 .2 .04],'String',' Expected Return',...
    'Value', 0, 'callback', @WinClick,'userdata',H.hRadio(1),...
    'tooltip','(#Wins)/(#Games)*(#Players)','Fontsize',12,...
    'FontUnits','normalized','backg',get(H.hAxis,'color'));
set(H.hRadio(1), 'userdata',H.hRadio(2));

%%% Create Deck on right %%%
yspacing = 15/14-1; ysize = 30/14; bottomy = ysize/2; % Constants for y
xspacing = yspacing; xsize = ysize*(1.1/2)+2*xspacing; leftx = 24; % for x
xPos = leftx+(0:3)*xsize+xspacing; % Calculate x Positions
yPos = bottomy+(0:12)*ysize+yspacing; % Calculate y Positions
ctr = 0;
for m = 1:4
    for n = 1:13,
        ctr = ctr+1;
        H.hDeck(n,m) = PlotCard(xPos(m),yPos(n),n,m); %Create deck cards
        set(H.hDeck(n,m),'Tag','Deck','UserData',[m n ctr]); % Set props
    end
end

%%% Create 10-sided table %%%
t = 0:pi/5:2*pi; w = 9; % Constants
hTable = patch(12+w*cos(t),15+3/2*w*sin(t),[0 .6 0]);

%%% Create Hands on Table %%%
 t = 0:pi/5:2*pi;w = 6.75; % Constants
zx = 10.8+w*sin(t); zy = 14.5+3/2*w*cos(t); % Calculate positions
for y = 1:10,
        [H.hHand(1,y,1) H.hHand(1, y, 2) H.hHand(1, y, 3)] = PlotCard(zx(y),zy(y)); %Hand Card 1
        set(H.hHand(1,y,1),'Tag','Hand','UserData',[1 y],'facecolor',[0 .6 0])
        [H.hHand(2,y,1) H.hHand(2, y, 2) H.hHand(2, y, 3)] = PlotCard(zx(y)+1.3,zy(y)); %Hand Card 2
        set(H.hHand(2,y,1),'Tag','Hand','UserData',[2 y],'facecolor',[0 .6 0])
        H.hHandText(y) = text(zx(y)+1.25,zy(y)-.65,'','fontname','courier',...
        'backgroundcolor','none','color','k','Horiz','center','fontweight','bold'); %Win Pct TextBox
end

%%% Create "Number of Games" TextBox and Label%%%
H.hHandText(11) = text(3, 27, '', 'horiz','center','fontname', 'courier',...
    'backgroundcolor','none','color','k','fontsize',12); % Textbox
text(1,28,'Number of Games:','Visible','on','fontsize',12); % Label

%%% Create Flop cards %%%
xPos = 8.5:1.5:16; % x Positions
yPos = 14.5; % y Position
for x = 1:5
    [H.hHand(1,10+x,1) H.hHand(1,10+x,2) H.hHand(1,10+x,3)]= PlotCard(xPos(x),yPos); %Create Card
    set(H.hHand(1,10+x,1),'FaceColor',.4*[1 1 1],'Tag','Flop','UserData',[1 10+x])
end

%%% Initialize Game info %%%
H.curCard = []; % Currently selected hand card
H.Hin = false(10,1); % Hands currently in game
H.Pocket = zeros(2,15); % Cards currently in each hand

%%%Save data%%%
guidata(H.hFig, H);



function [hc, hv, hs] = PlotCard(x,y,cval,csuit)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Creates the card rectangles and labels%
% x, y are positions in axis
% cval and csuit are the value and suit of the card

%%% Check inputs %%%
if nargin<4
    % Suit not specified - create face down card
    csuit = 5;
    s2 = '';
else
    % Convert suit to symbol
    s2 = char(166+csuit);
end
if nargin<3
    % Val not specified - create face down card
    cval = 14;
end

%%% Set constants %%%
pips = {'2','3','4','5','6','7','8','9','T','J','Q','K','A',''}; % Define pips for values
clr = {'k','r','r','k','k'}; % Define color for each suit

%%% Create card %%%
hc = rectangle('position',[x y 1.1 2],'curvature',[.1 .1],'buttondownfcn',@CardClick,'facecolor','w');

%%% Create card value and suit textboxes %%%
hv = text(x+.25,y+1,pips{cval},'fontname','courier','backgroundcolor','none',...
    'color',clr{csuit},'fontweight','bold','hittest','off','erasemode','normal');
hs = text(x+.6,y+1,s2,'fontname','symbol','backgroundcolor','none',...
    'color',clr{csuit},'fontweight','bold','hittest','off','erasemode','normal');


function CardClick(h, varargin)
%%%%%%%%%%%%%%%%%%%%%
%Card click callback%
%%%%%%%%%%%%%%%%%%%%%

H = guidata(gcbf); %Load app data
if strcmp(get(H.hSimButton,'String'),'Stop')
    %If simulation is currently running --> do nothing
    return
end

%%% Set Constants %%%
pips = {'2','3','4','5','6','7','8','9','T','J','Q','K','A',''};
clr = {'k','r','r','k','k'}; 

type = get(h,'Tag'); % Determine type of card clicked

if strcmp(get(H.hFig,'SelectionType'),'normal') 
    % Left Mouse Click
    if strcmp(type,'Hand') 
        % Clicked a hand card 
        hCard = get(h, 'UserData'); %Get index of card clicked
        if ~isempty(H.curCard) 
            % There is already a selected card
            set(H.curCard,'LineWidth',1); %Remove focus from current card
        end        
        if ~H.Hin(hCard(2)) 
            % Hand not already in game  --> Assign hand to game
            set(H.hHand(1:2,hCard(2),1),'FaceColor',.4*[1 1 1]);
            H.Hin(hCard(2)) = true;
        end
        
        set(h,'LineWidth',2.5) % Assign focus to clicked card        
        H.curCard = h; % Set clicked card to current card
        
    elseif strcmp(type,'Deck') 
        % Clicked a deck card
        if isempty(H.curCard) || any(get(h, 'facecolor')~=1)
            % There is no current card, or deck card is already assigned --> do nothing
            return
        end
        dCard = get(h,'UserData'); % Get index of clicked deck card
        hCard = get(H.curCard,'UserData'); % get index of current hand card        
        if H.Pocket(hCard(1),hCard(2))
            % Current card already assigned --> Change old deck card color to white
            set(H.hDeck(H.Pocket(hCard(1),hCard(2))), 'facecolor','w')
        end
        
        H.Pocket(hCard(1),hCard(2)) = dCard(3); %Add clicked card to current card
        set(h, 'facecolor',.7*[1 1 1]) %Grey-out deck card
        set(H.curCard,'Facecolor','w'); %Ensure current location is white        
        set(H.hHand(hCard(1), hCard(2),2), 'String', pips{dCard(2)},...
            'color',clr{dCard(1)}); % Set card value text
        set(H.hHand(hCard(1), hCard(2),3), 'String', char(166+dCard(1)),...
            'color',clr{dCard(1)}); %Set card suit text        
        set(H.hHand(hCard(1), hCard(2),1), 'LineWidth',1); %Move focusborder off current card
        if hCard(2)<=10
            % Current card is hand card
            hCard(1) = mod(hCard(1),2)+1; %Move focus to next card
        else 
            % Current card is flop card            
            hCard(2) = hCard(2) + 1; %Move focus to next card
            if hCard(2)>15,hCard(2) = 11;end % Wrap around
        end
        
        set(H.hHand(hCard(1), hCard(2),1), 'LineWidth', 2.5); %Move focusborder to next card
        H.curCard = H.hHand(hCard(1),hCard(2),1); %Set current card to next card

    elseif strcmp(type,'Flop')
        % Clicked a flop card
        if ~isempty(H.curCard)
            % There is already a selected card
            set(H.curCard,'LineWidth',1); %Remove focusborder from current card
        end
        set(h,'LineWidth',2.5) %Set focusborder to clicked card
        H.curCard = h; %Set current card to clicked card
    end
elseif strcmp(get(gcbf,'SelectionType'),'alt') 
    % Right Mouse Button click
    if strcmp(type,'Deck')
        % Clicked a deck card 
        return % Do nothing
    end
    
    hCard = get(h,'UserData'); % Get index of clicked card 
    
    if hCard(2)<=10 && ~H.Hin(hCard(2)) 
        % Clicked hand card and it's not already in hand
        return % Do nothing         
    end
    
    if H.Pocket(hCard(1), hCard(2))
        % Card is already "shown" --> Turn card back over "not shown"
        set(H.hHand(hCard(1),hCard(2),1),'FaceColor',.4*[1 1 1]);
        set(H.hHand(hCard(1),hCard(2),2:3),'String','');
        set(H.hDeck(H.Pocket(hCard(1), hCard(2))),'FaceColor',[1 1 1]);
        H.Pocket(hCard(1), hCard(2)) = 0; % Unassign from hand
        
    elseif strcmp(type,'Hand') 
        % Card is not already "shown", and is a hand card --> Remove hand from game
        set(H.hHand(1:2,hCard(2),1),'FaceColor',[0 .6 0]);
        set(H.hHand(1:2,hCard(2),2:3),'String','');
        set(H.hHandText(hCard(2)),'String','');        
        
        N = mod(hCard(1),2)+1; %Determine index of other card in hand
        if H.Pocket(N, hCard(2))>0 
            % Other card is assigned --> Unassign
            set(H.hDeck(H.Pocket(N, hCard(2))),'FaceColor',[1 1 1]); 
            H.Pocket(N, hCard(2)) = 0;
        end
        
        if ~isempty(H.curCard) 
            % There is a current card
            cI = find(H.hHand(1:2,hCard(2),1)==H.curCard); % Find if current card is in this hand
            if ~isempty(cI) % If it is in this hand
                H.curCard = []; % Remove current card
            end
            set(H.hHand(cI,hCard(2),1),'LineWidth',1) %Remove focusborder from current card
        end
        H.Hin(hCard(2)) = false; % Remove hand from game
    end
end
guidata(gcbf, H) % Save app data


function ClearClick(varargin)
%%%%%%%%%%%%%%%%%%%%%%
%Clear click callback%
%%%%%%%%%%%%%%%%%%%%%%

H = guidata(gcbf); % Load app data
if strcmp(get(H.hSimButton,'String'),'Stop')
    % If simulation is currently running --> do nothing
    return
end

%%% Clear game data %%%
H.Hin = false(10,1);
H.curCard = [];
H.Pocket = zeros(2,15);

%%% Set default card settings %%
set(H.hHand(:,1:10,1),'facecolor',[0 .6 0],'LineWidth',1)
set(H.hHand(:,1:10,2:3),'String','')
set(H.hHandText(1:11),'String','')
set(H.hHand(1,11:15,1),'facecolor',.4*[1 1 1],'LineWidth',1)
set(H.hHand(1,11:15,2:3),'String','')
set(H.hDeck,'facecolor',[1 1 1])

guidata(H.hFig, H); % Save app data



function DealClick(varargin)
%%%%%%%%%%%%%%%%%%%%%
%Deal click callback%
%%%%%%%%%%%%%%%%%%%%%
if strcmp(get(gcbf,'Tag'),'Running')
    % If simulation is currently running --> do nothing
    return
end
H = guidata(gcbf);  % Load app data

nSeats = sum(H.Hin); % Determine number of players in game
if nSeats==0
    % If no players --> Assign all players
    H.Hin = true(10,1);
    nSeats = 10;
end

ClearClick % Clears all cards

%%% Define constants %%%
pips = {'2','3','4','5','6','7','8','9','T','J','Q','K','A',''};
clr = {'k','r','r','k','k'};

[Vals Suits] = DealEm(1,nSeats); % Deals random cards

%%% Set text boxes for all cards %%%
hi = find(H.Hin); % Determine index of hands in game
for n = 1:nSeats
    for m=1:2
        set(H.hHand(m,hi(n),2),'String',pips{Vals(m,n)-1},'color',clr{Suits(m,n)});
        set(H.hHand(m,hi(n),3),'String',char(166+Suits(m,n)),'color',clr{Suits(m,n)});
    end
end
set(H.hHand(:,H.Hin),'facecolor',[1 1 1]) % Make faces white

%%% Assign cards to pockets %%%
H.Pocket = zeros(2,15); % Intialize pocket 
tmp = 13*(Suits(1:2,:)-1)+Vals(1:2,:)-1; % Get linear representation of card
set(H.hDeck(tmp),'facecolor',.7*[1 1 1]) % Grey-out deck card
H.Pocket(:,H.Hin) = tmp; % Assign to pocket

guidata(H.hFig, H); % Save app data


function WinClick(h,varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Radio button click callback%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ~get(h,'value') 
   % Turning off
    set(h, 'value',1) % Turn other on
else
    set(get(h,'Userdata'), 'value',0) % Turn other off
end


function Simulate(h,varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Simulate/Stop button click callback%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
H = guidata(gcbf); %Load app data
if sum(H.Hin)<2
    % Less than 2 players --> Do nothing
    return
end

ID = []; %Initialize error ID
if strcmp(get(H.hSimButton,'String'),'Simulate') 
    % Simulation is not already running
    set(H.hSimButton,'String','Stop') %Change simulate button label
    set(H.hClearButton,'Enable','off') %Turn off clear button
    set(H.hDealButton,'Enable','off') %Turn off deal button
    
    Flop = H.Pocket(1,end-4:end); % Extract flop cards 
    Pkt = H.Pocket(:,H.Hin); %Extract hand cards
    nSeats = size(Pkt,2); %Determine number of players in game

    nGames = 200; %Number of games to simulate per iteration (changing this can improve rate of simulation)
    ctr = 0; Wins = 0; %Initialize counters
    try
        nHands = nGames*nSeats; % Total number of hands in all games
        %%% Create 3 constant matrices for use later %%%
        C.IhVals = 13*repmat(0:nHands-1, 7, 1); 
        C.IhSuits = 4*repmat(0:nHands-1, 7, 1);
        C.IH = 5*repmat(0:nHands-1, 13, 1) + 1;
        
        while strcmp(get(H.hSimButton,'String'),'Stop')
            % Simulation has not been stopped
            ctr = ctr+1; % Increase iteration counter
            [Value,Suit] = DealEm(nGames, nSeats, Pkt,Flop); % Deal nGames new games
            
            Result = HandAnalyze(Value,Suit,C); % Determine what each hand is holding
            
            Won = WinCheck(Result, nSeats); %Determine winning/tying hands
            Wins = Wins+sum(reshape(Won,nSeats,nGames),2); %Combine wins for each seat
            Pct = Wins/ctr/nGames*100; %Determine win percentage
            
            %%% Display results %%%
            fh = find(H.Hin); % Get indices of hands in game
            if get(H.hRadio(1), 'Value') 
                % Show win percentages
                for a=1:length(fh)
                    set(H.hHandText(fh(a)),'String',sprintf('%0.2f',Pct(a)))
                end
            else 
                % Show expected values
                for a=1:length(fh)
                    set(H.hHandText(fh(a)),'String',sprintf('%0.3f',nSeats*Pct(a)/100))
                end
            end
            
            set(H.hHandText(11),'String',num2str(ctr*nGames)) %Set number of games text            
            drawnow %Pause to allow graphical commands to catch up
        end
    catch   
        %%% Error occurred %%%
        [errstr ID]=lasterr;
        data=ver('matlab');        
        if strcmp(errstr,'Invalid handle object.') || strcmp(errstr(end-14:end),'Invalid handle.')
        %if false && strcmp(ID,'MATLAB:UndefinedFunction')
            %Error'd because window was closed --> exit
            return
        else
            %Legitimite error
            error(errstr, ID);
        end
    end    
else 
    % Simulation is running --> stop it
    set(H.hSimButton,'String','Simulate') %Change label of simulate button
    set(H.hClearButton,'Enable','on') %Re-enable clear button
    set(H.hDealButton,'Enable','on') %Re-enable deal button
    set(H.curCard,'LineWidth',2.5); %Set focusborder to current card
end
if isempty(ID) %If window wasn't closed
    guidata(H.hFig, H) %Save app data
end


function [Value,Suit] = DealEm(nDecks,nSeats,Pkt,Flop)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Deal all cards not already assigned%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin<4,Pkt=[];Flop=[];end % Check inputs

tmp = rand(52,nDecks); % Generate random integers
[ignore Deck] = sort(tmp); % Generate linear rep of deck and Flop

ctr = 0; % Counter
for m=1:size(Pkt,2)
    % For every hand
    for n = 1:2
        % For both cards
        ctr = ctr+1; %Increase counter
        if Pkt(n,m) > 0
            % Card is currently assigned --> Remove that card from deck
            I1 = find(Deck==Pkt(n,m)); % Index of assigned card
            Deck(I1) = Deck(ctr,:); % Get assigned card
            Deck(ctr,:) = Pkt(n,m); % Reassign deck card
        end
    end
end

nCard = numel(Pkt); % # of Cards in game
for n = 1:length(Flop)
    % For every flop card
    if Flop(n)
        % Flop card is currently assigned --> Remove that card from deck
        I1 = find(Deck==Flop(n)); % Index of assigned card
        Deck(I1) = Deck(nCard+n,:); % Get assigned card
        Deck(nCard+n,:) = Flop(n); % Reassign deck card
    end
end

%%% Deal Pockets (2 cards in a row to one seat)
tmp = Deck(1:2*nSeats,:);
Pocket = zeros(2,nSeats*nDecks);
Pocket(:) = tmp(:);

Flop = Deck(2*nSeats+(1:5),:); %Deal each flop

%%% Seperate suits and values %%%
pSuit = ceil(Pocket./13);
pValue = Pocket-(pSuit-1)*13;
fSuit = ceil(Flop./13);
fValue = Flop-(fSuit-1)*13;

%%% Create all hands (Add flop to each hand) %%%
tmp = ceil((1:nDecks*nSeats)/nSeats);
Value = [pValue;fValue(:,tmp)]+1;
Suit = [pSuit;fSuit(:,tmp)];


function Result = HandAnalyze(HandVals,HandSuits,C)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Analyze what each hand evaluates to%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[nCards nHands] = size(HandVals);

%%% Indicators %%%
PairInd=100;Pair2Ind=200;TripInd=300;StraightInd=400;
FlushInd=500;HouseInd=600;FourInd=700;StraightFlushInd=800;

%%% Algorithm constants (can be used as input rather than generated each time) %%%
if nargin < 3
    C.IhVals = 13*repmat(0:nHands-1, nCards, 1);
    C.IhSuits = 4*repmat(0:nHands-1, nCards, 1);
    C.IH = 5*repmat(0:nHands-1, 13, 1) + 1;
end

%%% Use constants for indexing %%%
HandVals = HandVals - 1;
hValsI = 14-HandVals + C.IhVals;
hSuitsI = HandSuits + C.IhSuits;
HandHist = histc(14 - HandVals, 1:13); % Histogram values
SuitHist = histc(HandSuits, 1:4); % Histogram suits

%%% Handle all combinations 4kind, fullhouse, 3kind, 2pair, pair %%%
HandHist((cumsum(HandHist==2).*(HandHist==2))==3) = 1; %Set third pair to no pair
HandHist((cumsum(HandHist==3).*(HandHist==3))==2) = 2; %Set second trip to pair% 
PairHist(3:5, :) = histc(HandHist, 2:4); % Find how many of each type occur
% If have 4kind with pair or trips, remove them --> causes prob in algorithm 
PairHist(3:4, PairHist(5, :)>0) = 0; 
Scores = zeros(size(PairHist)); % Initialize scores matrix
Scores(5, PairHist(5, :)>0) = FourInd; % Set 4kind indicator
Scores(4, PairHist(4, :)==1) = TripInd; % Set trip indicator
Scores(4, PairHist(4, :)>0 & PairHist(3, :)>0) = HouseInd; % Set House indicator
Scores(3, PairHist(3, :)>0) = PairInd; % Set pair indicator
Scores(3, PairHist(3, :)>1 & PairHist(4, :)==0) = Pair2Ind; % Set 2pair indicator
Scores = Scores(HandHist + C.IH); % Add in constant indexing matrix
Result = Scores(hValsI); % Assign scores

%%% Handle straights %%%
% Create temp image of remaining HandVals, add an Ace low row, and pad end with 0s
tmp = [HandHist; HandHist(1, :); zeros(1, nHands)]; 
iZero = [0; find(~tmp)]; % Get indices of all zero elements of tmp
iStraight = iZero(diff(iZero)>5); % Get indices of iZero where next is more than 5 away
% Convert from 15-by-nHands indexing to 13-by-nHands indexing
iStraight = iStraight - 2*floor((iStraight+1)/15) + 1; 
% Assign straightInd to highest card in straight
Result(ismember(hValsI, iStraight)) = StraightInd; 

%%% Handle flushes %%%
Result(SuitHist(hSuitsI)>4) = FlushInd; 

%%% Handle straight flushes %%%
% This line only difference from straight method
HandHist(:) = 0; HandHist(hValsI(SuitHist(hSuitsI)>=5)) = 1; 
% Create temp image of remaining HandVals and add an Ace low row and pad end with 0s
tmp = [HandHist; HandHist(1, :); zeros(1, nHands)]; 
iZero = [0; find(~tmp)]; % Get indices of all zero elements of tmp
iStraight = iZero(diff(iZero)>5); % Get indices of iZero where next is more than 5 away
% Convert from 15-by-nHands indexing to 13-by-nHands indexing
iStraight = iStraight - 2*floor((iStraight+1)/15) + 1; 
%Assign StraightFlushInd to highest card in straight flush
Result(ismember(hValsI, iStraight)) = StraightFlushInd; 

% Combine values and result matrix and sort result
Result = flipud(sort(Result + HandVals, 1)) + 1; 

%Must adjust for case:  Straight with pairs in middle --> only represent
%straight with highest card
Result(2:end, (Result(1,:)>400 & Result(1,:)<500) | Result(1,:)>800) = 0; 


function WinAmt = WinCheck(Result, nSeats)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Determine winning hands for each game%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nGames = size(Result,2)/nSeats; % Determine number of games
[ignore ignore gRank] = unique(Result(1:5,:).','rows'); % Rank each hand
gRank = reshape(gRank, nSeats, nGames); % Reshape ranking to seperate games
F = max(gRank); % Determine best in each game
WinAmt = gRank==repmat(F,nSeats,1); % Fine others in game with same rank
WinAmt = WinAmt./repmat(sum(WinAmt),nSeats,1); % Calculate win amount per game
WinAmt = WinAmt(:).'; % Assign win amount to row vector


function HelpCallback(varargin)
% Open text document
!notepad PokerHelp.txt
