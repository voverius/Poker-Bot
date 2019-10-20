function HandCount = karas
acards = [20 20 30 30 40 40 50 50 60 60 70 70 80 80 90 90 100 100 110 110 120 120 130 130 140 140];
bcards = [20 20 30 30 40 40 50 50 60 60 70 70 80 80 90 90 100 100 110 110 120 120 130 130 140 140];

Dealta = zeros(1,26);
Dealtb = zeros(1,26);
HandCount = 0;

for i = 1:26
    position = randi(size(acards,2));
    Dealta(i) = acards(position);
    acards(position) = [];
end

for i = 1:26
    position = randi(size(bcards,2));
    Dealtb(i) = bcards(position);
    bcards(position) = [];
end

%Game
while size(Dealta,2) > 0 && size(Dealta,2) < 52
    if Dealta(1) > Dealtb(1)
        Dealta(size(Dealta,2)+1) = Dealta(1);
        Dealta(size(Dealta,2)+1) = Dealtb(1);
        Dealta(1) = [];
        Dealtb(1) = [];
    elseif Dealta(1) == Dealtb(1)
        if size(Dealta,2) < 3 || size(Dealtb,2) < 3
            Dealta(size(Dealta,2)+1) = Dealta(1);
            Dealtb(size(Dealtb,2)+1) = Dealtb(1);
            Dealta(1) = [];
            Dealtb(1) = []; 
            continue
        end
        if Dealta(3) > Dealtb(3)
            Dealta(size(Dealta,2)+1) = Dealta(1);
            Dealta(size(Dealta,2)+1) = Dealtb(1);            
            Dealta(size(Dealta,2)+1) = Dealta(2);
            Dealta(size(Dealta,2)+1) = Dealtb(2);
            Dealta(size(Dealta,2)+1) = Dealta(3);
            Dealta(size(Dealta,2)+1) = Dealtb(3);            
            Dealta(3) = [];
            Dealtb(3) = []; 
            Dealta(2) = [];
            Dealtb(2) = [];     
            Dealta(1) = [];
            Dealtb(1) = [];    
        elseif Dealta(3) == Dealtb(3)
            if Dealta(5) > Dealtb(5)
                Dealta(size(Dealta,2)+1) = Dealta(1);
                Dealta(size(Dealta,2)+1) = Dealtb(1);            
                Dealta(size(Dealta,2)+1) = Dealta(2);
                Dealta(size(Dealta,2)+1) = Dealtb(2);
                Dealta(size(Dealta,2)+1) = Dealta(3);
                Dealta(size(Dealta,2)+1) = Dealtb(3);
                Dealta(size(Dealta,2)+1) = Dealta(4);
                Dealta(size(Dealta,2)+1) = Dealtb(4);
                Dealta(size(Dealta,2)+1) = Dealta(5);
                Dealta(size(Dealta,2)+1) = Dealtb(5);                
                Dealta(5) = [];
                Dealtb(5) = []; 
                Dealta(4) = [];
                Dealtb(4) = [];     
                Dealta(3) = [];
                Dealtb(3) = [];             
                Dealta(2) = [];
                Dealtb(2) = [];            
                Dealta(1) = [];
                Dealtb(1) = [];     
            elseif Dealta(5) == Dealtb(5)
                Dealta(size(Dealta,2)+1) = Dealta(1);
                Dealtb(size(Dealtb,2)+1) = Dealtb(1);
                Dealta(1) = [];
                Dealtb(1) = [];        
                continue
            else
                Dealtb(size(Dealtb,2)+1) = Dealta(1);
                Dealtb(size(Dealtb,2)+1) = Dealtb(1);            
                Dealtb(size(Dealtb,2)+1) = Dealta(2);
                Dealtb(size(Dealtb,2)+1) = Dealtb(2);
                Dealtb(size(Dealtb,2)+1) = Dealta(3);
                Dealtb(size(Dealtb,2)+1) = Dealtb(3);
                Dealtb(size(Dealtb,2)+1) = Dealta(4);
                Dealtb(size(Dealtb,2)+1) = Dealtb(4);
                Dealtb(size(Dealtb,2)+1) = Dealta(5);
                Dealtb(size(Dealtb,2)+1) = Dealtb(5);                
                Dealta(5) = [];
                Dealtb(5) = []; 
                Dealta(4) = [];
                Dealtb(4) = [];     
                Dealta(3) = [];
                Dealtb(3) = [];             
                Dealta(2) = [];
                Dealtb(2) = [];            
                Dealta(1) = [];
                Dealtb(1) = [];
            end
        else
            Dealtb(size(Dealtb,2)+1) = Dealta(1);
            Dealtb(size(Dealtb,2)+1) = Dealtb(1);            
            Dealtb(size(Dealtb,2)+1) = Dealta(2);
            Dealtb(size(Dealtb,2)+1) = Dealtb(2);
            Dealtb(size(Dealtb,2)+1) = Dealta(3);
            Dealtb(size(Dealtb,2)+1) = Dealtb(3);            
            Dealta(3) = [];
            Dealtb(3) = []; 
            Dealta(2) = [];
            Dealtb(2) = [];     
            Dealta(1) = [];
            Dealtb(1) = [];             
        end
    else
        Dealtb(size(Dealtb,2)+1) = Dealta(1);
        Dealtb(size(Dealtb,2)+1) = Dealtb(1);
        Dealta(1) = [];
        Dealtb(1) = [];      
    end
%     disp(size(Dealta,2));
    HandCount = HandCount + 1;
    
    if rem(HandCount,100) == 0
        Mixa = Dealta;
        for i = 1:size(Mixa,2)
            position = randi(size(Dealta,2));
            Mixa(i) = Dealta(position);
            Dealta(position) = [];
        end    
        Dealta = Mixa;
 
        Mixb = Dealtb;
        for i = 1:size(Mixb,2)
            position = randi(size(Dealtb,2));
            Mixb(i) = Dealtb(position);
            Dealtb(position) = [];
        end    
        Dealtb = Mixb;
    end
end





