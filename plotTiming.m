function plotTiming(expt)

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

figure('Position',[100 100 1400 400])
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


% staircase
stairValues = expt.staircase.stairValues;
for i = 1:numel(stairValues)
    vals(i) = p.stairs(stairValues(i));
end

figure('Position',[300 300 930 350])
subplot(1,2,1)
plot(vals)
xlabel('trial')
ylabel('luminance')
title('staircase')
subplot(1,2,2)
semilogy(1-vals)
ylim([10^-1.5 1])
xlabel('trial')
ylabel('1 - log(luminance)')

