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

%% check presented ITIs against hazard 
iti = [expt.trialsPresented.iti]; % store presented itis 
histogram(iti, 'Normalization', 'probability') % the y and x axis, respectively

hold on
p.itis = 1:0.05:2.5; 
p.hazardProb = 0.2; % at every time step, the probability of the event is 0.2
p.itiPDF = p.hazardProb.*(1-p.hazardProb).^(0:numel(p.itis)-1); % f = p.*(1-p).^x;
plot(p.itis,p.itiPDF)

