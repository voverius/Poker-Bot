WC = 3;
Offset = 1920*(WC-1); 
Position = [360 + Offset, 159, 1220, 670];
f = 0;

while f == 0;
    
if GetAction(1, 1, WC) == 1
    IMG = SS(Position(1), Position(2), Position(3), Position(4), 0.8);
    imshow(IMG);
    while GetAction(1, 1, WC) == 1
    end
end
end