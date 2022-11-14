function texture = setTexture(inputArg1,inputArg2)

% ������˸��ͷ��ͼƬ
rawLeftFlicker = imread('����˸2.png');

% ͼƬ�Ĵ�С
widthLeftFlicker = size(rawLeftFlicker, 2);
heightLeftFlicker = size(rawLeftFlicker, 1);

% ���ü�ͷλ��
leftFlickerLocation = [screenXpixels*0.25, yCenter-heightLeftFlicker/2,...
    screenXpixels*0.25+widthLeftFlicker, yCenter+heightLeftFlicker/2];
rightFlickerLocation = [screenXpixels*0.75-widthLeftFlicker, yCenter-heightLeftFlicker/2,...
    screenXpixels*0.75, yCenter+heightLeftFlicker/2 ];

% ���ü�ͷ��˸Ƶ��
leftFlickerFreq = freq(1);
rightFlickerFreq = freq(2);


%%


% Ԥ�����ڴ�
leftFlicker = cell(1, 60);
% temp = cell(1, 60);
leftFlickerTexture = zeros(1, 60);
rightFlicker = cell(1, 60);
rightFlickerTexture = zeros(1, 60);

% ����ÿһ֡������ֵ
for frame = 1 : 60
    leftFlicker{frame} = (1/2)*(1+sin(2*pi*leftFlickerFreq*(frame/screenFreq)))*rawLeftFlicker;
    % temp{frame} = (1/2)*(1+sin(2*pi*leftFlickerFreq*(frame/screenFreq)));
    leftFlickerTexture(frame)=Screen('MakeTexture',window,leftFlicker{frame});
    
    rightFlicker{frame} = (1/2)*(1+sin(2*pi*rightFlickerFreq*(frame/screenFreq)))*rawLeftFlicker;
    rightFlickerTexture(frame)=Screen('MakeTexture',window,rightFlicker{frame});
end





end

