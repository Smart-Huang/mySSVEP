function showFix(wptr,wrect,fix,time,sx,sy)
%showFix.m

% wptr是屏幕编号
% wrect是屏幕尺寸
% fix是提示符对象
% time是提示显示时间
% sx

if nargin<5
    sx=wrect(3)/2;
    sy=wrect(4)/2;
end
if nargin<6 
    sy=wrect(4)/2;
end
if strcmp(sx,'center')
    sx=wrect(3)/2;
end
if strcmp(sy,'center')
    sy=wrect(4)/2;
end
if ~isnan(fix.ptr)
    Screen('CopyWindow',fix.ptr,wptr,fix.rect,CenterRect(fix.rect,[sx-5 sy-5 sx+5 sy+5]));
end
Screen('Flip',wptr); 
% 提示音
if ~isnan(fix.sound)
    beep;
end
WaitSecs(time);
