function GetMessage(t,~)
%% �������ܣ� ��ȡ�ͻ������߷������Ľ�����Ϣ
% ���������
%           t: ��ʱ���ľ����������Ҫ�õ�����UserData

%% ���������Ϣ��ȫ�ֱ����ͽ��������������������ǵķ��������߿ͻ�����
buffer=t.UserData;
global messageRecv;

%% ������������߿ͻ����յ���Ϣ����ô������Ϣ
% native2unicode�ѽ��յ���ASCII��ת��ΪUnicode������ʽ
if buffer.BytesAvailable>0
    messageRecv=fread(buffer,buffer.BytesAvailable, 'unicode');
    messageRecv=native2unicode(messageRecv);
    messageRecv=messageRecv';
    disp(" ");
    disp("���յ�����ϢΪ�� "+messageRecv);
    disp("������Ҫ���͵����ݣ�  ");
end
