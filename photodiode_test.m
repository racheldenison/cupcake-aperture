% photodiode_test.m


%% Set up stim tracker
PTBInitStimTracker;
global PTBTriggerLength
PTBTriggerLength = 0.001;

trigger = 1;

%% Set up screen
screenNumber = max(Screen('Screens'));

multisample = 8;
[window, rect] = Screen('OpenWindow', screenNumber,[],[],[],[],[],multisample);

white = WhiteIndex(window);  
[cx, cy] = RectCenter(rect);

%% Run
timeFlip = [];
for i = 1:100
    fprintf('\n\nTrial %d\n', i)
    
    tic
    drawPhotodiode(window, [cx cy]*2, white, 1); % white
    toc
    
    tic
    timeFlip(i) = Screen('Flip', window); % 17-34 ms?
    toc
    
    tic
    PTBSendTrigger(trigger, 0);
    toc
end