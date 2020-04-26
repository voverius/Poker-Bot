function Output = PercentileRange(Input)



% a = cell(169,1); %PURE EV CALCULATED RANGE
% a(1:13,1)  = {'AAo', 'KKo', 'QQo', 'JJo', 'TTo', '99o', '88o', 'AKs', '77o', 'AQs', 'AJs', 'AKo', 'ATs'};
% a(14:26,1) = {'AQo', 'AJo', 'KQs', '66o', 'A9s', 'ATo', 'KJs', 'A8s', 'KTs', 'KQo', 'A7s', 'A9o', 'KJo'};
% a(27:39,1) = {'55o', 'QJs', 'K9s', 'A5s', 'A6s', 'A8o', 'KTo', 'QTs', 'A4s', 'A7o', 'K8s', 'A3s', 'QJo'};
% a(40:52,1) = {'K9o', 'A5o', 'A6o', 'Q9s', 'K7s', 'JTs', 'A2s', 'QTo', '44o', 'A4o', 'K6s', 'K8o', 'Q8s'};
% a(53:65,1) = {'A3o', 'K5s', 'J9s', 'Q9o', 'JTo', 'K7o', 'A2o', 'K4s', 'Q7s', 'K6o', 'K3s', 'T9s', 'J8s'};
% a(66:78,1) = {'33o', 'Q6s', 'Q8o', 'K5o', 'J9o', 'K2s', 'Q5s', 'T8s', 'K4o', 'J7s', 'Q4s', 'Q7o', 'T9o'};
% a(79:91,1) = {'J8o', 'K3o', 'Q6o', 'Q3s', '98s', 'T7s', 'J6s', 'K2o', '22o', 'Q2s', 'Q5o', 'J5s', 'T8o'};
% a(92:104,1)= {'J7o', 'Q4o', '97s', 'J4s', 'T6s', 'J3s', 'Q3o', '98o', '87s', 'T7o', 'J6o', '96s', 'J2s'};
% a(105:117,1)={'Q2o', 'T5s', 'J5o', 'T4s', '97o', '86s', 'J4o', 'T6o', '95s', 'T3s', '76s', 'J3o', '87o'};
% a(118:130,1)={'T2s', '85s', '96o', 'J2o', 'T5o', '94s', '75s', 'T4o', '93s', '86o', '65s', '84s', '95o'};
% a(131:143,1)={'T3o', '92s', '76o', '74s', 'T2o', '54s', '85o', '64s', '83s', '94o', '75o', '82s', '73s'};
% a(144:156,1)={'93o', '65o', '53s', '63s', '84o', '92o', '43s', '74o', '72s', '54o', '64o', '52s', '62s'};
% a(157:169,1)={'83o', '42s', '82o', '73o', '53o', '63o', '32s', '43o', '72o', '52o', '62o', '42o', '32o'};


a = cell(169,1); %PURE SIMULATION ON FULL-RING GAME 
a(1:13,1)  = {'AAo', 'KKo', 'QQo', 'AKs', 'JJo', 'AQs', 'KQs', 'AJs', 'KJs', 'TTo', 'AKo', 'ATs', 'QJs'};
a(14:26,1) = {'KTs', 'QTs', 'JTs', '99o', 'AQo', 'A9s', 'KQo', '88o', 'K9s', 'T9s', 'A8s', 'Q9s', 'J9s'};
a(27:39,1) = {'AJo', 'A5s', '77o', 'A7s', 'KJo', 'A4s', 'A3s', 'A6s', 'QJo', '66o', 'K8s', 'T8s', 'A2s'};
a(40:52,1) = {'98s', 'J8s', 'ATo', 'Q8s', 'K7s', 'KTo', '55o', 'JTo', '87s', 'QTo', '44o', '22o', '33o'};
a(53:65,1) = {'K6s', '97s', 'K5s', '76s', 'T7s', 'K4s', 'K2s', 'K3s', 'Q7s', '86s', '65s', 'J7s', '54s'};
a(66:78,1) = {'Q6s', '75s', '96s', 'Q5s', '64s', 'Q4s', 'Q3s', 'T9o', 'T6s', 'Q2s', 'A9o', '53s', '85s'};
a(79:91,1) = {'J6s', 'J9o', 'K9o', 'J5s', 'Q9o', '43s', '74s', 'J4s', 'J3s', '95s', 'J2s', '63s', 'A8o'};
a(92:104,1)= {'52s', 'T5s', '84s', 'T4s', 'T3s', '42s', 'T2s', '98o', 'T8o', 'A5o', 'A7o', '73s', 'A4o'};
a(105:117,1)={'32s', '94s', '93s', 'J8o', 'A3o', '62s', '92s', 'K8o', 'A6o', '87o', 'Q8o', '83s', 'A2o'};
a(118:130,1)={'82s', '97o', '72s', '76o', 'K7o', '65o', 'T7o', 'K6o', '86o', '54o', 'K5o', 'J7o', '75o'};
a(131:143,1)={'Q7o', 'K4o', 'K3o', '96o', 'K2o', '64o', 'Q6o', '53o', '85o', 'T6o', 'Q5o', '43o', 'Q4o'};
a(144:156,1)={'Q3o', '74o', 'Q2o', 'J6o', '63o', 'J5o', '95o', '52o', 'J4o', 'J3o', '42o', 'J2o', '84o'};
a(157:169,1)={'T5o', 'T4o', '32o', 'T3o', '73o', 'T2o', '62o', '94o', '93o', '92o', '83o', '82o', '72o'};


b = cell(1326,1);
bPosition = 1;

for i=1:169
    
    temp = a{i,1};
    
    if strcmp(temp(1),temp(2))
        b(bPosition:(bPosition+5),1) = a(i,1);
        bPosition = bPosition + 6;
    elseif strcmp(temp(3),'o')
        b(bPosition:(bPosition+11),1) = a(i,1);
        bPosition = bPosition + 12;
    elseif strcmp(temp(3),'s')
        b(bPosition:(bPosition+3),1) = a(i,1);
        bPosition = bPosition + 4;
    end
end

Output = b(1:int16(Input/100*1326),1);
Output = unique(Output);


end



