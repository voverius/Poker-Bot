function Output = CtR(Input)

    if rem(Input(1),10) == rem(Input(2),10)
        suit = 's';
    else
        suit = 'o';
    end

    Input(1) = round(Input(1)/10);
    Input(2) = round(Input(2)/10);

    if Input(1) > Input(2)
        BC = 1;
    else
        BC = 2;
    end

    
    if Input(1) == 2
        Card1 = '2';
    elseif Input(1) == 3
        Card1 = '3';
    elseif Input(1) == 4
        Card1 = '4';    
    elseif Input(1) == 5
        Card1 = '5';    
    elseif Input(1) == 6
        Card1 = '6';    
    elseif Input(1) == 7
        Card1 = '7';    
    elseif Input(1) == 8
        Card1 = '8'; 
    elseif Input(1) == 9
        Card1 = '9';    
    elseif Input(1) == 10
        Card1 = 'T';
    elseif Input(1) == 11
        Card1 = 'J';
    elseif Input(1) == 12
        Card1 = 'Q';
    elseif Input(1) == 13
        Card1 = 'K';
    elseif Input(1) == 14
        Card1 = 'A';
    end


    if Input(2) == 2
        Card2 = '2';
    elseif Input(2) == 3
        Card2 = '3';
    elseif Input(2) == 4
        Card2 = '4';    
    elseif Input(2) == 5
        Card2 = '5';    
    elseif Input(2) == 6
        Card2 = '6';    
    elseif Input(2) == 7
        Card2 = '7';    
    elseif Input(2) == 8
        Card2 = '8'; 
    elseif Input(2) == 9
        Card2 = '9';    
    elseif Input(2) == 10
        Card2 = 'T';
    elseif Input(2) == 11
        Card2 = 'J';
    elseif Input(2) == 12
        Card2 = 'Q';
    elseif Input(2) == 13
        Card2 = 'K';
    elseif Input(2) == 14
        Card2 = 'A';
    end



    if BC == 1
        Output = [Card1, Card2, suit];
    elseif BC == 2
        Output = [Card2, Card1, suit];
    end


end