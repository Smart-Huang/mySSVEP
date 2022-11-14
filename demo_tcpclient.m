client = tcpip("127.0.0.1", 5174, 'NetworkRole', 'client');
global messageRecv;
messageRecv='';
client.OutputBuffersize=100000;

fopen(client);
t=timer('Period',0.01,'ExecutionMode','fixedRate','TimerFcn',@GetMessage,'UserData',client);
start(t);

messageInput='';
while(string(messageInput)~="stop")
    messageInput=input('请输入要发送的内容： \n','s');
    if strtrim(messageRecv)=="stop"
        break;
    end
    messageSend=unicode2native(messageInput);
    fwrite(Server,messageSend);
    % Waitsecs(2);
end


fclose(client);