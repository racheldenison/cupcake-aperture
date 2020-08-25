function plotStaircase(expt, saveFigs)

subjectID = expt.subjectID;
run = expt.run;

p = expt.p;
stairValues = expt.staircase.stairValues;

vals = [];
for i = 1:numel(stairValues)
    vals(i) = p.stairs(stairValues(i));
end

figure('Position',[300 300 930 350])
subplot(1,2,1)
plot(vals)
xlabel('trial')
ylabel('luminance')
title(sprintf('staircase threshold = %0.2f', expt.staircase.threshold))
subplot(1,2,2)
semilogy(1-vals)
ylim([10^-1.5 1])
xlabel('trial')
ylabel('1 - log(luminance)')

if saveFigs
    rd_saveAllFigs(gcf, {'staircase'}, sprintf('%s_run%02d', subjectID, run))
end