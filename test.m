tic

frequencySet=[8:0.2:15.8];
nConditions = length(frequencySet);
condition = 1:nConditions;

a = ['huang' 'xiao' 'dong'];

toc

tic

fs = 256;
fo = 50;
q = 35;
bw = (fo/(fs/2))/q;
[b,a] = iircomb(floor(fs/fo),bw,'notch'); % Note type flag 'notch'
fvtool(b, a);

toc
