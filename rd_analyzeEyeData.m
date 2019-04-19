% rd_analyzeEyeData.m

%% setup
fileDir = 'eyedata';
fileName = 'kt_allButtons_run01_CupcakeAperture_20190416';

edfFile = sprintf('%s/%s.edf', fileDir, fileName);

%% load eye data
edf = edfmex(edfFile);

%% FSAMPLE
%% plot all fields
S = edf.FSAMPLE;
measures = fields(S);
% measures = measures(10:end);
nM = numel(measures);

figure
for iM = 1:nM
    m = measures{iM};
    vals = S.(m);
    
    plot(vals')
    title(m)
    pause(.5)
end

%% get useful measures
eyeIdx = 2;

% time
Fs = double(edf.RECORDINGS(1).sample_rate);
t0 = S.time;
t = double(t0 - t0(1))/Fs;

% pupil area
pa = S.pa(eyeIdx,:);

% gaze position
gx = S.gx(eyeIdx,:);
gy = S.gy(eyeIdx,:);

figure
subplot(2,1,1)
plot(t, [gx' gy'])
xlim([t(1) t(end)])
ylim([0 1280])
ylabel('position')
legend('x','y')
subplot(2,1,2)
plot(t, pa)
xlim([t(1) t(end)])
xlabel('time (s)')
ylabel('pupil size')

%% FEVENT
%% get events of interest
E = edf.FEVENT;
nEvents = numel(E);

% get message and event info
msg = {E.message};
msgTimes = [E.sttime];
evt = {E.codestring};

% get indices trialstart, trialend for the given data file
trialStartIdx = find(strcmp(msg, 'TRIAL_START'));
trialEndIdx = find(strcmp(msg, 'TRIAL_END'));
eventFixIdx = find(strcmp(msg, 'EVENT_FIX'));
eventImageIdx = find(strcmp(msg, 'EVENT_IMAGE'));
eventToneIdx = find(strcmp(msg, 'EVENT_TONE'));
eventRespIdx = find(strcmp(msg, 'EVENT_RESPONSE'));

% time stamps for trial start and end
nTrials = length(trialStartIdx);
startTimes =  msgTimes(trialStartIdx);
endTimes =  msgTimes(trialEndIdx);
fixTimes = msgTimes(eventFixIdx);
imTimes = msgTimes(eventImageIdx);
toneTimes = msgTimes(eventToneIdx);
respTimes = msgTimes(eventRespIdx);

trialDurs = double(endTimes - startTimes);

% sample plot
imt = double(imTimes - t0(1))/Fs;

figure
hold on
plot(t, pa)
plot(imt, mean(pa), '.', 'MarkerSize',20)
xlabel('time (s)')
ylabel('pupil size')

%% organize data into trials





