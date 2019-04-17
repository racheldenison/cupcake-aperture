%% pilot response check plots
% April 15, 2019
% karen tian

function plotResponse(expt, saveFigs)

subjectID = expt.subjectID;
run = expt.run;

%% plot response and target state by time
cFill = [ones(max(size(expt.trials)), 1), ones(max(size(expt.trials)), 1), ones(max(size(expt.trials)),1)];
figure('Position',[60 320 1000 200]);
sResponse = scatter(expt.timing.timeResp-expt.timing.startTime, expt.trials(:,9)); % plot response (1 response, 0 no response)
hold on
for i =1:max(size(expt.trials))
    if expt.trials(i,4)==2 % not a target
        cFill(i, :) = [1 1 1]; % white
    else % target
        cFill(i, :) = [1 0 0]; % red
    end
    sTarget = scatter(expt.timing.timeResp-expt.timing.startTime, expt.trials(:,4), 10 ,cFill, 'filled'); % conditional color target state
end
set(gca, ...
  'Box'         , 'off'     , ...
  'YTick'       , -1:1:2       ...
);
ylim([0,2])
xlim([min(expt.timing.timeResp)-expt.timing.startTime-2,max(expt.timing.timeResp)-expt.timing.startTime+2])
xlabel('Time (s)')
ylabel('Response and Target State')
legend( ...
  [sResponse, sTarget], ...
  'Response' , ...
  'Target' , ...  % change to red from white
  'location', 'NorthWest' );

%% check ITI 
iti = [expt.trialsPresented.iti]; % store ITI's in array
figure
, p.itiPDF)




% itiPlot.FaceColor = [.9 .9 .9];

xlabel('ITI (s)')
ylabel('Frequency')

% histfit(p.itiPDF)
xgrid = linspace(min(iti),0.05,max(iti))';

hold on
p.itis = 1:0.05:2.5; 
p.hazardProb = 0.2; % at every time step, the probability of the event is 0.2
p.itiPDF = p.hazardProb.*(1-p.hazardProb).^(0:numel(p.itis)-1); % f = p.*(1-p).^x;


line(p.itis,p.itiPDF,'Color','r');
set(gca, ...
  'Box'         , 'off'      ......
);

[freq_count, bin_value] = hist(iti); %the y and x axis, respectively
bar(bin_value,freq_count./length(iti)) %normalized y-axis with x axis the bins

% hold on
figure
p.itis = 1:0.05:2.5; 
p.hazardProb = 0.2; % at every time step, the probability of the event is 0.2
% p.itiPDF = p.hazardProb.*(1-p.hazardProb).^(0:numel(p.itis)-1); % f = p.*(1-p).^x;
p.itiPDF = p.hazardProb.*(1-p.hazardProb).^(0:numel(p.itis)-1); % f = p.*(1-p).^x;
plot(x

