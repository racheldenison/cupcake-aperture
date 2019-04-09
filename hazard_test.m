% hazard_test.m

%% generate distributions
p = .2;

itis = 0.6:0.05:1.6;
x = 0:numel(itis)-1;

f = p.*(1-p).^x; % pdf

S = (1-p).^x; % survival function
F = 1-S; % cdf
h = f./S; % hazard function

%% generate samples
n = 50;
samples = rd_sampleDiscretePDF(f, n);
c = hist(samples,1:numel(f))/n;

%% figure
clf
hold on
plot(x, f);
plot(x, F, 'r');
plot(x, c, 'k');
legend('pdf','cdf','pdf of samples','Location','best')

