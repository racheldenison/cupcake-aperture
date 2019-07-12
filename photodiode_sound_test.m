function photodiode_sound_test(run)

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

%% Sound
% Make tone
Fs = 44100;
toneDur = 0.01;
toneFreq = 500;
tone = MakeBeep(toneFreq, toneDur, Fs);
% tones = applyEnvelope(tone, Fs);

% Perform basic initialization of the sound driver
InitializePsychSound(1); % 1 for precise timing

% Open audio device for low-latency output
reqlatencyclass = 2; % Level 2 means: Take full control over the audio device, even if this causes other sound applications to fail or shutdown.
pahandle = PsychPortAudio('Open', [], [], reqlatencyclass, Fs, 1); % 1 = single-channel

%% Run
timeFlip = GetSecs;
timeFlips(1) = timeFlip;
for i = 1:1000
    fprintf('\n\nTrial %d\n', i)
    
    % draw
    tic
    drawPhotodiode(window, [cx cy]*2, white, mod(i,2)); 
    toc
    
    % flip
    tic
%     timeFlip = Screen('Flip', window); % 17-34 ms? % as fast as possible
    timeFlip = Screen('Flip', window, timeFlip + 0.1 - 0.016); % every 100 ms
    toc
    timeFlips(i+1) = timeFlip;
    
    % play tone
    tic
    PsychPortAudio('FillBuffer', pahandle, tone);
    PsychPortAudio('Start', pahandle, [], [], 1);
    toc
    
    % send trigger
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


