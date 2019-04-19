function colIndex = drawPhotodiode(window, screenSizePx, maxValue, colIndex)
%
% drawPhotodiode(window, sz, maxValue, [colIndex=1])
%
% Draws a square trigger to sync eCog recording with stimulus 
%
% window is the window pointer
% screenSizePx is 2x1 vector [x, y]
% maxValue is the maximum luminance value in 0-255
% colIndex: 0 for black, 1 for white

if nargin < 2, colIndex = 1; end;

x = screenSizePx(1);
y = screenSizePx(2);

% lower right
%trigRect = round([.93*x .91*y x y]);

% upper right
%trigRect = round([.93*x 0*y x .09*y]);

% upper left
% trigRect = round([0*x 0*y .07*x .09*y]); % square
trigRect = round([0*x 0*y .07*x .18*y]); % rectangle, for NYU MEG

black = round(maxValue * .1);  
white = round(maxValue * .9); 

if colIndex == 0, trigger_color = black; else trigger_color = white; end
    
Screen('FillRect', window, trigger_color, trigRect);
    

return