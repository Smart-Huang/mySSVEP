function fixTime = timerConfig()
%TIMERCONFIG �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

fixTime = timer('Period', 0.02);
set(fixTime, 'ExecutionMode', 'FixedRate');
set(fixTime,'TimerFcn',['newset=pGetData_curry8(con,dataBuffer,chanum,sampleRate);','if ~isempty(newset)',...
    'circBuff =[circBuff(0.2*sampleRate+1:end,:);newset];','end']);

end

