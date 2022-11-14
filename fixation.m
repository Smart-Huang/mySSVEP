function fix=fixation(wptr,type,color,backgroundcolor)
% fixation.m
% 该函数与showFix.m配合使用
% 该函数返回提示符对象，提示符默认是十字
% 可以以‘提示符+s’的格式在显示提示符的同时添加声音提示
% wptr是屏幕编号
% type是提示符，默认是 '+'
% color是提示符颜色，默认是黑色
% backgroundcolor是提示符背景颜色，默认是白色

%设置默认参数
if nargin<2
    type='+';
    color=0;
    backgroundcolor=255;
end
if nargin<3
    color=0;
    backgroundcolor=255;
end
if nargin<4
    backgroundcolor=255;
end   


wrect=Screen('Rect',wptr);
fixationSize=min(wrect(3),wrect(4))*10/100; % 提示符的尺寸
txtSize=floor(fixationSize);
if ~mod(fixationSize,2)
    fixationSize=fixationSize+1;
end
offptr=Screen('OpenOffscreenWindow',wptr,backgroundcolor,[0,0,fixationSize,fixationSize]);
switch lower(type)
    case {'.' '.+s'}
        Screen('FillOval',offptr,color);
        fix.ptr=offptr;
        fix.rect=[0 0 fixationSize fixationSize];
    case {'o' 'o+s'}
        Screen('FrameArc',offptr,color,[],0,360,fixationSize/2-2);
        fix.ptr=offptr;
        fix.rect=[0 0 fixationSize fixationSize];
    case {'*' '*+s'}
        oldsize=Screen('TextSize',offptr,txtSize);
        DrawFormattedText(offptr,'*','center','center',color);
        Screen('TextSize',offptr,oldsize);
        fix.rect=[0 0 fixationSize fixationSize];
        fix.ptr=offptr;
    case {'s'}
        fix.sound=1;
        fix.ptr=NaN;
    otherwise
        Screen('DrawLine',offptr,color,0,fixationSize/2,fixationSize,fixationSize/2,3);
        Screen('DrawLine',offptr,color,fixationSize/2,0,fixationSize/2,fixationSize,3);
        fix.ptr=offptr;
        fix.rect=[0 0 fixationSize fixationSize];
end
if contains(lower(type),'s')
    fix.sound=1;
else
    fix.sound=NaN;
end
end
