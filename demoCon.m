clear;
clc;
sca;

global sampleRate;
channelNum = 7;
sampleRate = 1024;
params.ipAddress = '10.20.8.184';
params.serverPort = 4455;

circBuff = zeros(sampleRate, channelNume + 1);

dataBuff = ( (channelNum+1) * 4 * (200*sampleRate/1000) + 20 );

% 开始传输数据指令
startheader = initHeader('CTRL',...
    controlCode('CTRL_FromClient'),...
    requestType('RequestStreamingStart'),...
    0,0,0);


% 停止传输数据指令
stopheader = initHeader('CTRL',...
    controlCode('CTRL_FromClient'),...
    requestType('RequestStreamingStop'),...
    0,0,0);

con = tcpip(params.ipAddress, params.serverPort);
set(con,'InputBufferSize',dataBuffer);
set(con,'ByteOrder','littleEndian');
fopen(con); 


try
    fixTime = timer('Period', 0.02);
    set(fixTime, 'ExecutionMode', 'FixedRate');
    set(fixTime,'TimerFcn',['newset=pGetData_curry8(con,dataBuffer,chanum,sampleRate);','if ~isempty(newset)',...
        'circBuff =[circBuff(0.2*sampleRate+1:end,:);newset];','end']);
    start(fixTime); % 启动计时器
    
    for i = 1:10
        
        fwrite(con, startheader, 'uchar');
        
        WaitSecs(1);
        
        fwrite(con, stopheader, 'uchar');
        
    end
    

    
    stop(fixTime);
    fclose(con);
    delete(con);
catch
    stop(fixTime);
    fclose(con);
    delete(con);
    sca;
    psychrethrow(psychlasterror);
end

KbStrokeWait;

sca;












