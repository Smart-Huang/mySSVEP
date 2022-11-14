function texture = setTexture(inputArg1,inputArg2)

% 载入闪烁箭头的图片
rawLeftFlicker = imread('左闪烁2.png');

% 图片的大小
widthLeftFlicker = size(rawLeftFlicker, 2);
heightLeftFlicker = size(rawLeftFlicker, 1);

% 设置箭头位置
leftFlickerLocation = [screenXpixels*0.25, yCenter-heightLeftFlicker/2,...
    screenXpixels*0.25+widthLeftFlicker, yCenter+heightLeftFlicker/2];
rightFlickerLocation = [screenXpixels*0.75-widthLeftFlicker, yCenter-heightLeftFlicker/2,...
    screenXpixels*0.75, yCenter+heightLeftFlicker/2 ];

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





end

