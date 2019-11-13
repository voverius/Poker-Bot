function  ConvertedCards = ConvertCards(ReadCards)


if isnumeric(ReadCards) == 0
    RA = size(ReadCards,2); %Run Amount
    if RA >= 5
        RA = (RA+1)/3;
    else 
        RA = 1;
    end
    ConvertedCards = zeros(1,RA);
    Marker = 1;
    for i = 1:RA
        RC = ReadCards(Marker:(Marker+1));
        if isstrprop(RC(1),'digit')
            temp = str2double(RC(1))*10;
        elseif strcmp(RC(1),'T') == 1
            temp = 100;
        elseif strcmp(RC(1),'J') == 1
            temp = 110;
        elseif strcmp(RC(1),'Q') == 1
            temp = 120;    
        elseif strcmp(RC(1),'K') == 1
            temp = 130;
        elseif strcmp(RC(1),'A') == 1
            temp = 140;
        else 
            disp('Unknown Card Value');
        end


        if strcmp(RC(2),'h') == 1
            temp = temp + 1; 
        elseif strcmp(RC(2),'d') == 1
            temp = temp + 2; 
        elseif strcmp(RC(2),'c') == 1
            temp = temp + 3; 
        elseif strcmp(RC(2),'s') == 1
            temp = temp + 4; 
        else
            disp('Unknown Card Suit');
        end

        ConvertedCards(i) = temp;
        Marker = Marker + 3;
    end
    ConvertedCards = uint8(ConvertedCards);
else
    ReadCards = uint8(ReadCards);
    RA = size(ReadCards,2);
    Size = RA*3-1;
    ConvertedCards = blanks(Size);
    Marker = 1;
    
    for i = 1:RA
        AC = ReadCards(i); %Analyzed Card
 
        %Analyzing the Card
        Card = AC/10;
        if Card < 10
            ConvertedCards(Marker) = sprintf('%d', Card);
        elseif Card == 10
            ConvertedCards(Marker) = 'T';
        elseif Card == 11
            ConvertedCards(Marker) = 'J';
        elseif Card == 12
            ConvertedCards(Marker) = 'Q';
        elseif Card == 13
            ConvertedCards(Marker) = 'K';
        elseif Card == 14
            ConvertedCards(Marker) = 'A';
        else
            disp('Unknown Card Value');
        end     
        
        %Analyzing the Suit
        Marker = Marker + 1;
        Suit = rem(AC,10);
        if Suit == 1
            ConvertedCards(Marker) = 'h';
        elseif Suit == 2
            ConvertedCards(Marker) = 'd';
        elseif Suit == 3
            ConvertedCards(Marker) = 'c';
        elseif Suit == 4
            ConvertedCards(Marker) = 's';
        else
            disp('Unknown Card Suit');
        end        
        
        Marker = Marker + 2;
    end
end
