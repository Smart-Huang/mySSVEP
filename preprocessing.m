function [outputArg1,outputArg2] = preprocessing(inputArg1,inputArg2)
%PREPROCESSING 此处显示有关此函数的摘要

for k=1:numOfSubband
    Wp = [(8*k)/fs 90/fs];
    Ws = [(8*k-2)/fs 100/fs];
    [N,Wn] = cheb1ord(Wp,Ws,3,40);
    [subband(k).bpB,subband(k).bpA] = cheby1(N,0.5,Wn);
end






end

