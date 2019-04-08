

p = .1;

itis = 0.6:0.05:1;
x = 0:numel(itis);

f = p.*(1-p).^x;

S = (1-p).^x;
F = 1-S;

h = f./S;


figure
hold on
plot(x, f);
plot(x, F,'r');


