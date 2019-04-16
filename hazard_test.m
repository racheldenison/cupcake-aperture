% hazard_test.m

%% generate distributions
p = .2;

itis = 1:0.05:2.5;
x = 0:numel(itis)-1;

f = p.*(1-p).^x; % pdf

S = (1-p).^x; % survival function
F = 1-S; % cdf
h = f./S; % hazard function

%% generate samples
n = 1000;
samples = rd_sampleDiscretePDF(f, n);
c = hist(samples,1:numel(f))/n;

%% check samples
s = samples;
for i = 1:numel(itis)
    isiti = s==i;
    pITI(i) = mean(isiti);
    s(isiti) = [];
end

%% figure
clf
hold on
plot(x, f);
plot(x, F, 'r');
plot(x, c, 'k');
plot(x, h, 'g');
plot(x, pITI, '.--k')
legend('pdf','cdf','pdf of samples','theoretical hazard','hazard of samples','Location','best')

