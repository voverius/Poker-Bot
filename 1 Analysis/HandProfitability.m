function FinalSummary = HandProfitability(gs, OriginalGS, FinalSummary)

for i = 1:6
    Position = gs{1,i};
    Profits = FinalSummary{Position,2};
    Cards = gs{3,i};
    
    if rem(Cards(1),10) == rem(Cards(2),10)
        maxValue = max(Cards);
        minValue = min(Cards);
        Cards = [maxValue,minValue];
    else
        maxValue = max(Cards);
        minValue = min(Cards);
        Cards = [minValue,maxValue];
    end

    Cards(1) = round(Cards(1)/10);
    Cards(2) = round(Cards(2)/10);

    Profits(15 - Cards(1),15 - Cards(2)) = Profits(15 - Cards(1),15 - Cards(2)) + gs{2,i} - OriginalGS{2,i};
    FinalSummary{Position,2} = Profits;
end
end