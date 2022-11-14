% 清空屏幕
clear;
clc;
sca;

% 添加路径
addpath('fun');
addpath('source');

% 笔记本需要跳过检测，台式机不需要
Screen('Preference', 'SkipSyncTests', 1);

% 获取屏幕编号
screens = Screen('Screens');
screenNumber = 1;


% 检测屏幕的刷新频率是否为60Hz
global screenFreq;
screenFreq = 60;
if Screen('FrameRate',screenNumber)~=screenFreq
    disp(['屏幕刷新频率不是', num2str(screenFreq), 'Hz']);
    return;
end

%%
% 基本参数
channelNum = 7; %通道数量（不包含事件通道MGFP），c3,c4,p3,p4,o1,o2,cz
freq = [7.5, 6.0]; % 箭头的闪烁频率，左箭头7.5Hz，右箭头6Hz
blankTime = 2; % 空屏的持续时间
crossTime = 0.4; % 十字持续时间
arrowTime = 2; % 箭头持续时间
trialNum = 10; % 实验次数

%--------------------------------------------------------------------------
global sampleRate;
sampleRate = 1024;
dataLength = crossTime + arrowTime;
ipAddress = '10.20.8.184';
serverPort = 4455;

buffSize = round(dataLength * sampleRate);
circBuff = zeros(buffSize, channelNum + 1);
% 需要注释,20是数据头，200是采集时间200ms，4是4个字节，一个通道数据是8位16进制数表示
dataBuffer = ( (channelNum+1) * 4 * (200*sampleRate/1000) + 20);

%%
% tcpip的设置
% [con, startheader, stopheader] = tcpipConfig(ipAddress, serverPort, dataBuffer);

% fopen(con); 
%%
% PTB的基本设置和基本参数
% 获得屏幕编号，设置黑白值

white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);
grey = white / 2;

%%
try
   
    AssertOpenGL;
    
    HideCursor;   % 隐藏鼠标
    
    % Open an on screen window
    [window, windowRect] = PsychImaging('OpenWindow', screenNumber, black);
    
    % 获得屏幕尺寸、坐标和刷新率信息
    [screenXpixels, screenYpixels] = Screen('WindowSize', window);
    [xCenter, yCenter] = RectCenter(windowRect);
    ifi = Screen('GetFlipInterval', window);
    
    % 将优先级设置为最高
    topPriorityLevel = MaxPriority(window);
    Priority(topPriorityLevel);
    
    % 设置字体颜色
    Screen('TextColor', window, white);
    % 设置字体大小
    Screen('TextSize', window, 64);
    
    % 抗锯齿
    Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
    %------------------------------------------------------------------------
    
    % 设置图片基本参数
    % 随机生成trialNum个箭头
    data = cell(1, trialNum);
    for i = 1:trialNum
        if unidrnd(2) == 1
            data{1, i} = '←';
        else
            data{1, i} = '→';
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

    
    %%
    
    
    % 预分配内存
    leftFlicker = cell(1, 60);
    % temp = cell(1, 60);
    leftFlickerTexture = zeros(1, 60);
    rightFlicker = cell(1, 60);
    rightFlickerTexture = zeros(1, 60);
    
    % 设置每一帧的亮度值
    for frame = 1 : 60
        leftFlicker{frame} = (1/2)*(1+sin(2*pi*leftFlickerFreq*(frame/screenFreq)))*rawLeftFlicker;
        % temp{frame} = (1/2)*(1+sin(2*pi*leftFlickerFreq*(frame/screenFreq)));
        leftFlickerTexture(frame)=Screen('MakeTexture',window,leftFlicker{frame});
        
        rightFlicker{frame} = (1/2)*(1+sin(2*pi*rightFlickerFreq*(frame/screenFreq)))*rawLeftFlicker;
        rightFlickerTexture(frame)=Screen('MakeTexture',window,rightFlicker{frame});
    end
    
    crossTexture = Screen('MakeTexture', window, rawCross);

    %%
    % 设置计时器
    % 计时器的间隔为0.02s
    % 时间函数为从curry8中最近的0.2s的数据，然后存入circBuff
    % 计时器的功能就是每0.02s往
%     fixTime = timer('Period', 0.02);
%     set(fixTime, 'ExecutionMode', 'FixedRate');
%     set(fixTime,'TimerFcn',['newset=pGetData_curry8(con,dataBuffer,chanum,sampleRate);','if ~isempty(newset)',...
%         'circBuff =[circBuff(0.2*sampleRate+1:end,:);newset];','end']);
%     fixTime = timerConfig();
%     start(fixTime); % 启动计时器
    
    
    
    
    waitFrames = 1;
    results = cell(1, trialNum);
    for trial = 1 : trialNum
     
        % 开始从tcp中读取数据
        % fwrite(con, startheader, 'uchar');
   
        % 显示2s十字
        Screen('DrawTexture', window, crossTexture, [], crossLocation, 0);
        vbl = Screen('Flip', window);
        WaitSecs(crossTime);
        
        % 显示6s箭头
        for j = 1 : arrowTime
      
            for i = 1 : 60
                DrawFormattedText(window, data{1, trial}, 'center', 'center', white);
                Screen('DrawTexture', window, leftFlickerTexture(i), [], leftFlickerLocation, 0);
                Screen('DrawTexture', window, rightFlickerTexture(i), [], rightFlickerLocation, 180);
                vbl=Screen('Flip',window);
            end      
        end
        
        % fwrite(con, stopheader, 'uchar');
        
        % remove baseline
        % median(circBuff,2)返回每一行的中位数
        % repmat(A, a, b)的作用是将矩阵A的行和列分别复制a次和b次
        % 这段代码的作用是将circBuff的各个通道的数值减去各自的中位数
%         circBuff = circBuff';
%         circBuff = circBuff - repmat(median(circBuff,2),1,buffSize);
%         circBuff = circBuff';
        
        
        % 在线分析
%         resultnum = onlineAnalysis(circBuff,arrowTime,channelNum,freq);
        
%         if resultnum == 1
%             results(trial) = '←';
%         else
%             results(trial) = '→';
%         end


 
    end % trial
   
%     correctNum = sum(data == results);
%     correctRate = correctNum / trialNum;
    
    
    Priotity(0);
    % 关闭计时器
%     stop(fixTime);
%     % 关闭与服务端连接，停止接收脑电数据
%     fclose(con);
%     delete(con);
    
    
catch
    ShowCursor;
    % 关闭计时器
%     stop(fixTime);
%     fclose(con);
%     delete(con);
    sca;
    psychrethrow(psychlasterror);  %抛出最后一条错误
end


KbStrokeWait;
sca;











