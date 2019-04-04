function plotTiming(expt)

p = expt.p;
trials_headers = expt.trials_headers;
trials = expt.trials;
timing = expt.timing;

itiRequested = trials(:,strcmp(trials_headers,'iti2'));
itiActual = [NaN timing.iti'];
itiActual(itiActual > 2) = NaN; % between blocks

figure
subplot(1,2,1)
hold on
histogram(timing.imDur)
vline(p.gratingDur,'k')
xlabel('Image duration (s)')
ylabel('Number of trials')

subplot(1,2,2)
hold on
plot([.5 1.5],[.5 1.5])
scatter(itiRequested, itiActual)
xlabel('Requested ITI (s)')
ylabel('Actual ITI (s)')
axis square