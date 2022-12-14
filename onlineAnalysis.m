function result = onlineAnalysis(rawdata,stimTime,chanum,freq)
%
% -------------------------------------------------------------------------
% 参数
global sampleRate;

condition = length(freq);
lDelay = 0.14;
% N1 = 1000*(stimTime + lDelay);
% -------------------------------------------------------------------------
for chan = 1:chanum
   % markData = rawdata(:,10);
   % Diffmark = diff(markData,1);
   % indexsMin = find(Diffmark~=0);
   % iMin = max(indexsMin);
   % downsdata = downsample(rawdata(round(iMin+1):round(iMin+N1),chan),4);
   downsdata = downsample(rawdata(:,chan),4);
   bpdata(:,chan) = bp40(downsdata,sampleRate/4);
end
% -------------------------------------------------------------------------
rfs = sampleRate/4;%降采样后的采样率
latencyDelay = lDelay*rfs;%延时采样点数
N = round(stimTime*rfs);
n = [1:N]/rfs;
condY = zeros(N, 2, condition);
% condY是CCA中的参考频率Y
for ii = 1:condition
    s1 = sin(2*pi*freq(ii)*n);
    s2 = cos(2*pi*freq(ii)*n);
    %  s3 = sin(2*pi*2*freq(ii)*n);
    % s4 = cos(2*pi*2*freq(ii)*n);
    % s5 = sin(2*pi*3*freq(ii)*n);
    %  s6 = cos(2*pi*3*freq(ii)*n);
    %  condY(:,:,ii) = cat(2,s1',s2',s3',s4',s5',s6');
    condY(:,:,ii) = cat(2,s1',s2'); % 按行拼接，例如2*3和2*4的矩阵变成2*7的矩阵
    
    condY(:,:,ii) = condY(:,:,ii) - repmat(mean(condY(:,:,ii),1), N, 1);% remove mean
end


X = bpdata(1+latencyDelay:N+latencyDelay,:);

rr = zeros(1, condition);
for cond = 1:condition
    [~,~,r,~,~] = canoncorr(X,condY(:,:,cond)); % 典型相关分析
    rr(cond) = max(r);
end
maxindex = find(rr==max(rr)); 
result = maxindex;