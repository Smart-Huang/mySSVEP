function GetMessage(t,~)
%% 函数功能： 获取客户机或者服务器的接收信息
% 输入参数：
%           t: 定时器的句柄，我们需要用到它的UserData

%% 定义接收信息的全局变量和接收器（接收器就是我们的服务器或者客户机）
buffer=t.UserData;
global messageRecv;

%% 如果服务器或者客户机收到消息，那么接收消息
% native2unicode把接收到的ASCII码转换为Unicode编码形式
if buffer.BytesAvailable>0
    messageRecv=fread(buffer,buffer.BytesAvailable, 'unicode');
    messageRecv=native2unicode(messageRecv);
    messageRecv=messageRecv';
    disp(" ");
    disp("接收到的消息为： "+messageRecv);
    disp("请输入要发送的内容：  ");
end
