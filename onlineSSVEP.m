function [title,result] = onlineSSVEP(window,trialNum, freq)
%ONLINESSVEP 此处显示有关此函数的摘要
%   此处显示详细说明

[screenXpixels, ~] = Screen('WindowSize', window);
windowRect = Screen('Rect', window);
[xCenter, yCenter] = RectCenter(windowRect);

% 设置图片基本参数
% 随机生成trialNum个箭头
title = cell(1, trialNum);
for i = 1:trialNum
    if unidrnd(2) == 1
        title{1, i} = '←';
    else
        title{1, i} = '→';
    end
end

% 本实验用的素材有闪烁的红色的箭头和指示用的黑色箭头
% 载入闪烁箭头的图片
rawLeftFlicker = imread('左闪烁2.png');
% leftFlicker = Screen('MakeTexture', window, rawLeftFlicker);
% 将左箭头的图像翻转180°就是右箭头
% rightArrow = Screen('MakeTexture', window, imread('右箭头.png'));
rawCross = imread('十字_黑.png');

% 图片的大小
widthLeftFlicker = size(rawLeftFlicker, 2);
heightLeftFlicker = size(rawLeftFlicker, 1);
widthCross = size(rawCross, 2);
heightCross = size(rawCross, 1);
    
% 设置箭头位置
leftFlickerLocation = [screenXpixels*0.25, yCenter-heightLeftFlicker/2,...
    screenXpixels*0.25+widthLeftFlicker, yCenter+heightLeftFlicker/2];
rightFlickerLocation = [screenXpixels*0.75-widthLeftFlicker, yCenter-heightLeftFlicker/2,...
    screenXpixels*0.75, yCenter+heightLeftFlicker/2 ];
crossLocation = [xCenter-widthCross/2, yCenter-heightCross/2,...
    xCenter+widthCross/2, yCenter+heightCross/2];


    
% 设置箭头闪烁频率
leftFlickerFreq = freq(1);
rightFlickerFreq = freq(2);

% leftFlickerFrames = round(1 / leftFlickerFreq / ifi);
% rightFlickerFrames = round(1 / rightFlickerFreq / ifi);


% 预分配内存
leftFlicker = cell(1, 60);
% temp = cell(1, 60);
leftFlickerTexture = zeros(1, 60);
rightFlicker = cell(1, 60);
rightFlickerTexture = zeros(1, 60);
    
% 设置每一帧的亮度值
global screenFreq;
for frame = 1 : screenFreq
    leftFlicker{frame} = (1/2)*(1+sin(2*pi*leftFlickerFreq*(frame/screenFreq)))*rawLeftFlicker;
    leftFlickerTexture(frame)=Screen('MakeTexture',window,leftFlicker{frame});
    
    rightFlicker{frame} = (1/2)*(1+sin(2*pi*rightFlickerFreq*(frame/screenFreq)))*rawLeftFlicker;
    rightFlickerTexture(frame)=Screen('MakeTexture',window,rightFlicker{frame});
end

end

