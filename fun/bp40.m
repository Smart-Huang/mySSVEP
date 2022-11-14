function  y=bp40(x,fs)
% 设计一个切比雪夫I型滤波器
% 
fs=fs/2;

% 
%Wp=[35/fs];%25Hz
%Ws=[50/fs];%10
%Wp=[5/fs];%25Hz
%Ws=[1/fs];%10

 %Wp=[4/fs 50/fs];%3 7
 %Ws=[1/fs 60/fs];%1 1
 
%  Wp=[5/fs 70/fs];
%  Ws=[3/fs 80/fs];

 Wp=[7/fs 70/fs];%3 7
 Ws=[5/fs 80/fs];%1 1
 
  %Wp=[4/fs 55/fs];%3 7
  %Ws=[1/fs 65/fs];%1 1
% Wp=[8/fs 15/fs];%12
% Ws=[2/fs 20/fs];%10

% Wp=[0.5/fs 35/fs];%12
% Ws=[0.05/fs 120/fs];%10
% 
% Wp=[2/fs 25/fs];%12
% Ws=[.05/fs 60/fs];%10
% % 

%[N,Wn]=cheb1ord(Wp,Ws,5,30);
N = cheb1ord(Wp,Ws,3,40);

% cheby1(n, Rp, Wp)返回一个n阶低通数字切比雪夫I型滤波器的传递函数系数
% Wp是归一化通带边沿频率，Rp分贝的峰峰值通带波纹
[B,A] = cheby1(N,0.5,Wp);
y = filtfilt(B,A,x);


 