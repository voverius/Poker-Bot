
Resize = [10 6];
[NumberedIMG, CharacterCount] = bwlabel(IMG);
[Pos1,Pos2] = find(NumberedIMG == 5);
CharacterIMG = IMG(min(Pos1):max(Pos1),min(Pos2):max(Pos2));
CharacterIMG = imresize(CharacterIMG, [Resize(1) Resize(2)]);
figure(1);
subimage(CharacterIMG);

















