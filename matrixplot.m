


load /Users/varunkapoor/IDLWorkspace/Default/newtraj_matrix5k.dat;
nvectors = 30;
ncols = 5000;

TrajVecnew = newtraj_matrix5k(:,1);

TrajMatnew = vec2mat(TrajVecnew,ncols);
figure;
for cnt=1:30
histogram(TrajMatnew(cnt,:))
Xh = hist(TrajMatnew(cnt,:))
Xh = Xh / sum(Xh(:));
i = find(Xh);
h = -sum(Xh(i) .* log2(Xh(i)));
Entropy = h;
display(Entropy);
EntropyVec(cnt) = Entropy;

hold on
end

load /Users/varunkapoor/IDLWorkspace/Default/masterkey5k.dat;

key = masterkey5k(:,1);

keynew = vec2mat((TrajVecnew - masterkey5k),ncols);
figure;
for cnt=1:30
histogram(keynew(cnt,:))
Xhkey = hist(keynew(cnt,:))
Xhkey = Xhkey / sum(Xhkey(:));
ikey = find(Xhkey);
hkey = -sum(Xhkey(ikey) .* log2(Xhkey(ikey)));
Entropykey = hkey;
display(Entropykey);
EntropyVeckey(cnt) = Entropykey;

hold on
end




load /Users/varunkapoor/IDLWorkspace/Default/origtraj_matrix5k.dat;


TrajVecold = origtraj_matrix5k(:,1);

TrajMatold = vec2mat(TrajVecold,ncols);
figure;
for cnt=1:30
histogram(TrajMatold(cnt,:))
Xhold = hist(TrajMatold(cnt,:))
Xhold = Xhold / sum(Xhold(:));
iold = find(Xhold);
hol = -sum(Xhold(iold) .* log2(Xhold(iold)));
Entropyold = hol;
display(Entropyold);
EntropyVecold(cnt) = Entropyold;
hold on
end

Entropymat = [EntropyVecold; EntropyVec];


dlmwrite('Entropy.txt',Entropymat, 'delimiter', '\n');

dlmwrite('Entropydiff.txt',(EntropyVecold-EntropyVec), 'delimiter', '\n');

dlmwrite('Entropykeydiff.txt',(EntropyVecold-EntropyVeckey), 'delimiter', '\n');




