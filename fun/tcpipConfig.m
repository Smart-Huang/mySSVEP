function [con, startheader, stopheader] = tcpipConfig( address, port, dataBuff)

startheader = initHeader('CTRL',...
    controlCode('CTRL_FromClient'),...
    requestType('RequestStreamingStart'),...
    0,0,0);
% -------------------------------------------------------------------------
% 停止传输数据指令
stopheader = initHeader('CTRL',...
    controlCode('CTRL_FromClient'),...
    requestType('RequestStreamingStop'),...
    0,0,0);

con = tcpip(address, port);
set(con,'InputBufferSize',dataBuff);
set(con,'ByteOrder','littleEndian');


end

