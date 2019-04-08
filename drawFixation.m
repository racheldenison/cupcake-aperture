function drawFixation(window, cx, cy, size, color, strokeWidth, strokeColor)

% function drawFixation(window, cx, cy, size, color, [strokeWidth==1], [strokeColor==0])
%
% size is a 1- or 2-element vector, [inner outer] diameter. if 1-element,
% will only draw inner fixation dot
%
% stroke is the width of the outline, which lies inside the dot diameters
%
% color is in RGB or grayscale 0-255, [inner; outer]

if nargin < 7
    strokeColor = 0;
end
if nargin < 6
    strokeWidth = 1;
end

if numel(size)==2
    drawOuter = 1;
elseif numel(size)==1
    drawOuter = 0;
    size(2) = NaN;
else
    error('size must be a 1 or 2 element vector [inner outer]')
end

rect1 = [0 0 size(1) size(1)];
rect2 = [0 0 size(2) size(2)];

if drawOuter
    % outer ring
    Screen('FillOval', window, color(2,:), CenterRectOnPointd(rect2, cx, cy))
    Screen('FrameOval', window, strokeColor, CenterRectOnPointd(rect2, cx, cy), strokeWidth)
end
% inner dot
Screen('FillOval', window, color(1,:), CenterRectOnPointd(rect1, cx, cy))
Screen('FrameOval', window, strokeColor, CenterRectOnPointd(rect1, cx, cy), strokeWidth)




