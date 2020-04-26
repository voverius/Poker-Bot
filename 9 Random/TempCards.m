
HMC = size(Photos,1); %how many cards
HMT = size(Photos,2);
Output = zeros(5,HMT);
MaxMatrix = zeros(5,HMT,2);

VariableName = ['CardTemplates',num2str(HMT)];
eval(['load ',VariableName]);
eval(['template = ',VariableName,';']);


for i = 1:HMT
    TempOutput = zeros(HMC,2);
    for k = 1:HMC
        if all(all(Photos{k,i,1} == 0) == 1) || isempty(Photos{k,i,1}) == 1
            continue
        end
        
        Temp = zeros(13,1);
        for j = 1:13
            Temp(j) = corr2(template{j},Photos{k,i,1}); 
        end

        MaxTemp = max(Temp);
        MaxMatrix(k,i,1) = MaxTemp;
        TempOutput(k,1) = find(Temp == MaxTemp);
    
        Temp2 = zeros(4,1);
        for j = 1:4
            Temp2(j) = corr2(template{j+13},Photos{k,i,2}); 
        end

        MaxTemp2 = max(Temp2);
        MaxMatrix(k,i,2) = MaxTemp2;
        TempOutput(k,2) = find(Temp2 == MaxTemp2);   
    end
    
    OutputTemp = 0;
    for k = 1:HMC
        if TempOutput(k,1) ~= 0
            OutputTemp = (TempOutput(k,1) + 1) * 10;
            Output(k,i) = OutputTemp + TempOutput(k,2);
        end
    end
end

disp(Output)
disp(MaxMatrix)
