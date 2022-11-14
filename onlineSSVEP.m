function [title,result] = onlineSSVEP(window,trialNum, freq)
%ONLINESSVEP �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

[screenXpixels, ~] = Screen('WindowSize', window);
windowRect = Screen('Rect', window);
[xCenter, yCenter] = RectCenter(windowRect);

% ����ͼƬ��������
% �������trialNum����ͷ
title = cell(1, trialNum);
for i = 1:trialNum
    if unidrnd(2) == 1
        title{1, i} = '��';
    else
        title{1, i} = '��';
    end
end

% ��ʵ���õ��ز�����˸�ĺ�ɫ�ļ�ͷ��ָʾ�õĺ�ɫ��ͷ
% ������˸��ͷ��ͼƬ
rawLeftFlicker = imread('����˸2.png');
% leftFlicker = Screen('MakeTexture', window, rawLeftFlicker);
% �����ͷ��ͼ��ת180������Ҽ�ͷ
% rightArrow = Screen('MakeTexture', window, imread('�Ҽ�ͷ.png'));
rawCross = imread('ʮ��_��.png');

% ͼƬ�Ĵ�С
widthLeftFlicker = size(rawLeftFlicker, 2);
heightLeftFlicker = size(rawLeftFlicker, 1);
widthCross = size(rawCross, 2);
heightCross = size(rawCross, 1);
    
% ���ü�ͷλ��
leftFlickerLocation = [screenXpixels*0.25, yCenter-heightLeftFlicker/2,...
    screenXpixels*0.25+widthLeftFlicker, yCenter+heightLeftFlicker/2];
rightFlickerLocation = [screenXpixels*0.75-widthLeftFlicker, yCenter-heightLeftFlicker/2,...
    screenXpixels*0.75, yCenter+heightLeftFlicker/2 ];
crossLocation = [xCenter-widthCross/2, yCenter-heightCross/2,...
    xCenter+widthCross/2, yCenter+heightCross/2];


    
% ���ü�ͷ��˸Ƶ��
leftFlickerFreq = freq(1);
rightFlickerFreq = freq(2);

% leftFlickerFrames = round(1 / leftFlickerFreq / ifi);
% rightFlickerFrames = round(1 / rightFlickerFreq / ifi);


% Ԥ�����ڴ�
leftFlicker = cell(1, 60);
% temp = cell(1, 60);
leftFlickerTexture = zeros(1, 60);
rightFlicker = cell(1, 60);
rightFlickerTexture = zeros(1, 60);
    
% ����ÿһ֡������ֵ
global screenFreq;
for frame = 1 : screenFreq
    leftFlicker{frame} = (1/2)*(1+sin(2*pi*leftFlickerFreq*(frame/screenFreq)))*rawLeftFlicker;
    leftFlickerTexture(frame)=Screen('MakeTexture',window,leftFlicker{frame});
    
    rightFlicker{frame} = (1/2)*(1+sin(2*pi*rightFlickerFreq*(frame/screenFreq)))*rawLeftFlicker;
    rightFlickerTexture(frame)=Screen('MakeTexture',window,rightFlicker{frame});
end

end

