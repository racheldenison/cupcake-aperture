function plotTiming(expt, saveFigs)

subjectID = expt.subjectID;
run = expt.run;

p = expt.p;
trials_headers = expt.trials_headers;
trials = expt.trials;
timing = expt.timing;

itiRequested = trials(:,strcmp(trials_headers,'iti2'));
itiActual = timing.iti;
itiActual(itiActual > 2) = NaN; % between blocks
allITIs = [itiRequested; itiActual];
itiLims = [min(allITIs)*.9 max(allITIs)*1.1];

missedTrials = trials(:,strcmp(trials_headers,'targetState'))==1 & trials(:,strcmp(trials_headers,'correct'))==0;

nc = 5; % num columns

%% stimulus timing
fh(1) = figure('Position',[100 100 1400 400]);
subplot(1,nc,1)
hold on
hist(timing.imDur)
vline(p.gratingDur,'r')
xlabel('Image duration (s)')
ylabel('Number of trials')

subplot(1,nc,2)
hold on
plot(itiLims,itiLims)
scatter(itiRequested, itiActual)
xlabel('Requested ITI (s)')
ylabel('Actual ITI (s)')
axis square
xlim(itiLims)
ylim(itiLims)

subplot(1,nc,3)
hold on
hist(itiActual-itiRequested)
vline(0,'r')
xlabel('Difference from requested ITI (s)')
ylabel('Number of trials')

subplot(1,nc,4)
hold on
hist(timing.respToneSOA)
vline(p.toneOnsetSOA,'r')
xlabel('Response-tone SOA, FAs (s)')
ylabel('Number of trials')

subplot(1,nc,5)
hold on
hist(timing.imToneSOA(missedTrials))
vline(p.responseWindowDur + p.toneOnsetSOA,'r')
xlabel('Image-tone ITI, misses (s)')
ylabel('Number of trials')

%% trigger timing
fh(2) = figure('Position',[60 320 750 210]);
plot(timing.triggers(:,2)-timing.startTime,timing.triggers(:,1),'.-')
ylim([0,17])
xlabel('Time (s)')
ylabel('Trigger')

%% save figs
if saveFigs
    rd_saveAllFigs(fh, {'timing', 'triggers'}, sprintf('%s_run%02d', subjectID, run))
end

