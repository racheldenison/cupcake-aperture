function plotTiming(expt)

trials_headers = expt.trials_headers;
trials = expt.trials;
timing = expt.timing;

itiRequested = trials(:,strcmp(trials_headers,'iti2'));
itiActual = [NaN timing.iti'];
itiActual(itiActual > 2) = NaN; % between blocks

figure
hold on
plot([.5 1.5],[.5 1.5])
scatter(itiRequested, itiActual)
xlabel('Requested ITI')
ylabel('Actual ITI')
axis square