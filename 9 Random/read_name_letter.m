function letter=read_name_letter(imagn,num_letras)
% Computes the correlation between template and input image
% and its output is a string containing the letter.
% Size of 'imagn' must be 42 x 24 pixels
% Example:
% imagn=imread('D.bmp');
% letter=read_letter(imagn)
global NameTemplates
comp=[ ];
for n=1:num_letras
    sem=corr2(NameTemplates{1,n},imagn);
    comp=[comp sem];
end
vd=find(comp==max(comp));
%disp(comp);
%*-*-*-*-*-*-*-*-*-*-*-*-*-
if vd==1
    letter='a';
elseif vd==2
    letter='A';
elseif vd==3
    letter='b';
elseif vd==4
    letter='B';
elseif vd==5
    letter='c';
elseif vd==6
    letter='C';
elseif vd==7
    letter='d';
elseif vd==8
    letter='D';
elseif vd==9
    letter='e';
elseif vd==10
    letter='E';
elseif vd==11
    letter='f';
elseif vd==12
    letter='F';
elseif vd==13
    letter='g';
elseif vd==14
    letter='G';
elseif vd==15
    letter='h';
elseif vd==16
    letter='H';
elseif vd==17
    letter='i';
elseif vd==18
    letter='I';
elseif vd==19
    letter='j';
elseif vd==20
    letter='J';
elseif vd==21
    letter='k';
elseif vd==22
    letter='K';
elseif vd==23
    letter='l';
elseif vd==24
    letter='L';
elseif vd==25
    letter='m';
elseif vd==26
    letter='M';
elseif vd==27
    letter='n';
elseif vd==28
    letter='N';
elseif vd==29
    letter='o';
elseif vd==30
    letter='O';
elseif vd==31
    letter='p';
elseif vd==32
    letter='P';
elseif vd==33
    letter='q';
elseif vd==34
    letter='Q';
elseif vd==35
    letter='r';
elseif vd==36
    letter='R';
elseif vd==37
    letter='s';
elseif vd==38
    letter='S';
elseif vd==39
    letter='t';
elseif vd==40
    letter='T';
elseif vd==41
    letter='u';
elseif vd==42
    letter='U';
elseif vd==43
    letter='v';
elseif vd==44
    letter='V';
elseif vd==45
    letter='w';
elseif vd==46
    letter='W';
elseif vd==47
    letter='x';
elseif vd==48
    letter='X';
elseif vd==49
    letter='y';
elseif vd==50
    letter='Y';
elseif vd==51
    letter='z';
elseif vd==52
    letter='Z';
    
elseif vd==53
    letter='1';
elseif vd==54
    letter='2';
elseif vd==55
    letter='3';
elseif vd==56
    letter='4';
elseif vd==57
    letter='5';
elseif vd==58
    letter='6';
elseif vd==59
    letter='7';
elseif vd==60
    letter='8';
elseif vd==61
    letter='9';
elseif vd==62
    letter='0';
    
    
% disp('$ & - # ~ _ < > . ? |')
    
elseif vd==63
    letter='$';
elseif vd==64
    letter='&';
elseif vd==65
    letter='-';
elseif vd==66
    letter='#';
elseif vd==67
    letter='~';
elseif vd==68
    letter='_';
elseif vd==69
    letter='>';
elseif vd==70
    letter='<';
elseif vd==71
    letter='.';
elseif vd==72
    letter='?';
elseif vd==73
    letter='?';
elseif vd==74
    letter='|';
elseif vd==75
    letter='Reserved';
elseif vd==76
    letter='TakeSeat';
elseif vd==77
    letter='i';
elseif vd==78
    letter='j';
elseif vd==79
    letter='K';
elseif vd==80
    letter='K';
else
    letter='No OCR Match';
end

