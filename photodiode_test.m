function photodiode_test(run)

if nargin==0
    run = [];
end

% addpath(genpath('../PTBWrapper'))

% addpath(genpath('PTBWrapper'))

% Screen('Preference', 'SkipSyncTests', 1);

%% Set up stim tracker
PTBInitStimTracker;
global PTBTriggerLength
PTBTriggerLength = 0.001;

trigger = 1;

%% Set up screen
screenNumber = max(Screen('Screens'));

multisample = 8;
[window, rect] = Screen('OpenWindow', screenNumber,[127 127 127],[],[],[],[],multisample);

white = WhiteIndex(window);  
[cx, cy] = RectCenter(rect);

%% Run
timeFlip = GetSecs;
timeFlips(1) = timeFlip;
for i = 1:1000
    fprintf('\n\nTrial %d\n', i)
    
    tic
    drawPhotodiode(window, [cx cy]*2, white, mod(i,2)); 
    toc
    
    tic
%     timeFlip = Screen('Flip', window); % 17-34 ms? % as fast as possible
    timeFlip = Screen('Flip', window, timeFlip + 0.1 - 0.016); % every 100 ms
    toc
    timeFlips(i+1) = timeFlip;
    
    tic
    PTBSendTrigger(trigger, 0);
    toc
end

%% Clean up
Screen('CloseAll')

%% Save
if ~isempty(run)
    save(sprintf('data/pdtest_run%d.mat', run), 'timeFlips')
end


