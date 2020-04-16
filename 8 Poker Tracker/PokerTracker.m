GameRakeMatrix = 0;

for l = CurrentLine:size(Text, 1);

   Row = Text{CurrentLine};
      
      if strfind(Row ,'PokerStars Hand #') > 0;
          
         HandNumber = Row(strfind(Row, '#')+1:strfind(Row, '#')+12);
         CurrentLine = CurrentLine+1;
         TableHistoryV2;
         CreateNW
%          StatCounterV2;
         for VP = 1:6
            if ~isempty(HH{4,VP,1}) && strcmp(HH{1,VP,1},'Metaliuga')
                AnalHHV2;
%                 
%                  if NW(1,1,4) == 3 && NW(1,2,4) == 1 && NW(1,9,4) == 1
%                     disp(NW(:,:,4))
%                  end
            end
         end
         HandCount = HandCount + 1;

      end

   CurrentLine = CurrentLine+1;   
   
   if CurrentLine >= size(Text,1);
       break
   end

end




















