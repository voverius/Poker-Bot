function ConvertedCards = ConvertToRange(HeldCards)

FirstCardNumeric = ConvertCards(HeldCards(1:2));
SecondCardNumeric = ConvertCards(HeldCards(4:5));

if SecondCardNumeric > FirstCardNumeric
    ConvertedCards = [HeldCards(4),HeldCards(1)];
else
    ConvertedCards = [HeldCards(1),HeldCards(4)];
end


if rem(FirstCardNumeric,10) == rem(SecondCardNumeric,10)
    ConvertedCards = [ConvertedCards,'s'];
else
    ConvertedCards = [ConvertedCards,'o'];
end


end