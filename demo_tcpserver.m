%% 服务器代码
%% 与第一个请求连接的客户机建立连接，端口号为5174，类型为服务器。
% Server=tcpip('localHost',5174,'LocalPort',8086,'NetworkRole','server');
Server=tcpip('0.0.0.0',2233,'NetworkRole','server');
%% 定义接收的信息，在定时器函数中接收数据
global messageRecv;
messageRecv='';

%% 打开服务器，直到建立一个TCP连接才返回；
fopen(Server);
disp("成功与客户机建立连接");
disp(" ");

%% 设定定时器，定时调用获取消息的函数
% Period=0.01，即每0.01尝试接收一次
% ExcutionMode=fixedRate，即固定频率循环接收
% TimerFcn：定义我们需要定时回调的函数
% UserData=Server：把服务器句柄传送给函数，用以接收数据
% t=timer('Period',0.01,'ExecutionMode','fixedRate','TimerFcn',@GetMessage ,'UserData',Server);
% start(t);

%% 等待用户输入消息，直到遇到stop
% uincode2native把需要发送的汉字转成Ascii码形式
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

%% 关闭服务器
% stop(t);
fclose(Server);
disp("关闭定时器和服务器");
