% �����Ļ
clear;
clc;
sca;

% �ʼǱ���Ҫ������⣬̨ʽ������Ҫ
Screen('Preference', 'SkipSyncTests', 1);

% �����Ļ��ˢ��Ƶ���Ƿ�Ϊ60Hz
screenFreq = 60;
if Screen('FrameRate',0)~=screenFreq
    disp(['��Ļˢ��Ƶ�ʲ���', num2str(screenFreq), 'Hz']);
    return;
end
frame_rate = screenFreq;

%%
% ��������
channelNum = 7; %ͨ���������������¼�ͨ��MGFP����c3,c4,p3,p4,o1,o2,cz
freq = [7.5, 6.0]; % ��ͷ����˸Ƶ�ʣ����ͷ7.5Hz���Ҽ�ͷ6Hz
blankTime = 2; % �����ĳ���ʱ��
crossTime = 0.4; % ʮ�ֳ���ʱ��
arrowTime = 2; % ��ͷ����ʱ��
trialNum = 10; % ʵ�����

%--------------------------------------------------------------------------
% ʵʱ���ݴ�����صĲ���
% params.channelNum = channelNum;

global sampleRate;
sampleRate = 1024;
params.dataLength = crossTime + arrowTime;
params.ipAddress = '192.168.163.213';
params.serverPort = 4455;

buffSize = round(params.dataLength * sampleRate);
circBuff = zeros(buffSize, channelNum + 1);
% ��Ҫע��,20������ͷ��200�ǲɼ�ʱ��200ms��4��4���ֽڣ�һ��ͨ��������8λ16��������ʾ
dataBuffer = ((channelNum+1)*4*(200*sampleRate/1000)+20);

%%
% ��ʼ��������ָ��
startheader = initHeader('CTRL',...
    controlCode('CTRL_FromClient'),...
    requestType('RequestStreamingStart'),...
    0,0,0);
% -------------------------------------------------------------------------
% ֹͣ��������ָ��
stopheader = initHeader('CTRL',...
    controlCode('CTRL_FromClient'),...
    requestType('RequestStreamingStop'),...
    0,0,0);

% -------------------------------------------------------------------------
% tcpip�˿�����
con = tcpip(params.ipAddress, params.serverPort);
set(con,'InputBufferSize',dataBuffer);
set(con,'ByteOrder','littleEndian');
fopen(con); 
%%
% PTB�Ļ������úͻ�������
% �����Ļ��ţ����úڰ�ֵ
screens = Screen('Screens');
screenNumber = 0;
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);
grey = white / 2;




%%
try
   
    AssertOpenGL;
    
    HideCursor;   % �������
    
    % Open an on screen window
    [window, windowRect] = PsychImaging('OpenWindow', screenNumber, black);
    
    % �����Ļ�ߴ硢�����ˢ������Ϣ
    [screenXpixels, screenYpixels] = Screen('WindowSize', window);
    [xCenter, yCenter] = RectCenter(windowRect);
    ifi = Screen('GetFlipInterval', window);
    % ���÷�ת���
    presSecs = 2;
    waitframes = round(presSecs / ifi);
    
    % �����ȼ�����Ϊ���
    topPriorityLevel = MaxPriority(window);
    Priority(topPriorityLevel);
    
    % ����������ɫ
    Screen('TextColor', window, white);
    % ���������С
    Screen('TextSize', window, 64);
    
    % �����
    Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
    %------------------------------------------------------------------------
    % ����ͼƬ��������
    % �������trialNum����ͷ
    data = cell(1, trialNum);
    for i = 1:trialNum
        if unidrnd(2) == 1
            data{1, i} = '��';
        else
            data{1, i} = '��';
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
    leftFlickerFreq = 7.5;
    rightFlickerFreq = 6.0;
    
    leftFlickerFrames = round(1 / leftFlickerFreq / ifi);
    rightFlickerFrames = round(1 / rightFlickerFreq / ifi);
    
    %%
    
    %for frame = 1 : round(screenFreq * arrowTime)
    
    % Ԥ�����ڴ�
    leftFlicker = cell(1, 60);
    temp = cell(1, 60);
    leftFlickerTexture = zeros(1, 60);
    rightFlicker = cell(1, 60);
    rightFlickerTexture = zeros(1, 60);
    
    % ����ÿһ֡������ֵ
    for frame = 1 : 60
        leftFlicker{frame} = (1/2)*(1+sin(2*pi*leftFlickerFreq*(frame/screenFreq)))*rawLeftFlicker;
        temp{frame} = (1/2)*(1+sin(2*pi*leftFlickerFreq*(frame/screenFreq)));
        leftFlickerTexture(frame)=Screen('MakeTexture',window,leftFlicker{frame});
        
        rightFlicker{frame} = (1/2)*(1+sin(2*pi*rightFlickerFreq*(frame/screenFreq)))*rawLeftFlicker;
        rightFlickerTexture(frame)=Screen('MakeTexture',window,rightFlicker{frame});
    end
    
    crossTexture = Screen('MakeTexture', window, rawCross);

    %%
    % ���ü�ʱ��
    % ��ʱ���ļ��Ϊ0.02s
    % ʱ�亯��Ϊ��curry8�������0.2s�����ݣ�Ȼ�����circBuff
    % ��ʱ���Ĺ��ܾ���ÿ0.02s��
    fixTime = timer('Period', 0.02);
    set(fixTime, 'ExecutionMode', 'FixedRate');
    set(fixTime,'TimerFcn',['newset=pGetData_curry8(con,dataBuffer,chanum,sampleRate);','if ~isempty(newset)',...
        'circBuff =[circBuff(0.2*sampleRate+1:end,:);newset];','end']);
    start(fixTime); % ������ʱ��
    
    
    
    waitFrames = 1;
    results = cell(1, trialNum);
    for trial = 1 : trialNum
      
        % count1 = 0;
        fwrite(con, startheader,'uchar');
        % ��ʾ2sʮ��
        Screen('DrawTexture', window, crossTexture, [], crossLocation, 0);
        vbl = Screen('Flip', window);
        WaitSecs(crossTime);
   
        % ��ʾ6s��ͷ
        for j = 1 : arrowTime
            % count1 = count1 + 1;
            
            for i = 1 : 60
                DrawFormattedText(window, data{1, trial}, 'center', 'center', white);
                Screen('DrawTexture', window, leftFlickerTexture(i), [], leftFlickerLocation, 0);
                Screen('DrawTexture', window, rightFlickerTexture(i), [], rightFlickerLocation, 180);
                vbl=Screen('Flip',window);
            end      
        end
        
        fwrite(con, stopheader, 'uchar');
        
        % remove baseline
        % median(circBuff,2)����ÿһ�е���λ��
        % repmat(A, a, b)�������ǽ�����A���к��зֱ���a�κ�b��
        % ��δ���������ǽ�circBuff�ĸ���ͨ������ֵ��ȥ���Ե���λ��
        circBuff = circBuff';
        circBuff = circBuff - repmat(median(circBuff,2),1,buffSize);
        circBuff = circBuff';
        
        
        % ���߷���
        resultnum = onlineAnalysis(circBuff,arrowTime,channelNum,freq);
        
        if resultnum == 1
            results(trial) = '��';
        else
            results(trial) = '��';
        end
 
    end % trial
   
    
    correctNum = sum(data == results);
    correctRate = correctNum / trialNum;
    
    
    Priotity(0);
    % �رռ�ʱ��
    stop(fixTime);
    
 
    % �ر����������ӣ�ֹͣ�����Ե�����
    fclose(con);
    delete(con);
catch
    ShowCursor;
    % �رռ�ʱ��
    stop(fixTime);
    sca;
    psychrethrow(psychlasterror);  %�׳����һ������
end

KbStrokeWait;
sca;











