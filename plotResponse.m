%% pilot response check plots
% April 15, 2019
% karen tian

% function plotResponse(expt, saveFigs)
% 
% subjectID = expt.subjectID;
% run = expt.run;

figure('Position',[1 100 1200 650]);
histColor = [.7 .7 .7]; % grey

%% plot response and target state by time
subplot(2,1,1)
responseIdx = strcmp(expt.trials_headers,'response');
resp = expt.trials(:,responseIdx);
targetIdx = strcmp(expt.trials_headers,'targetState');
target = expt.trials(:,targetIdx);
numTrials = max(size(expt.trials));
sResponse = scatter(expt.timing.timeResp-expt.timing.startTime, resp); % plot response (1 response, 0 no response)
hold on
cFill = [ones(numTrials,1) ones(numTrials,1) ones(numTrials,1)];
for i =1:numTrials
    if target(i)==1 % target
        cFill(i, :) = [1 0 0]; % red
        ntarget = ntarget + 1;
        if resp(i)==1 % correct reponse 
            hit = hit + 1; 
        end
    elseif target(i)==2 % not target
        cFill(i, :) = [1 1 1]; % white
        nnottarget = nnottarget + 1;
        if resp(i)==1 % false alarm
            FA = FA + 1; 
        end
    end
    sTarget = scatter(expt.timing.timeResp-expt.timing.startTime, target, 10 ,cFill, 'filled'); % if target, fill red
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
hitRate = hit/ntarget;
faRate = FA/nnottarget;
title(sprintf('Responses; target proportion = %0.2f, hit rate = %0.2f, false alarm rate = %0.2f', expt.p.propTargetPresent, hitRate, faRate))

%% check presented ITIs against hazard 
% figure('Position',[60 320 1200 200]);
subplot(2,1,2)
iti = [expt.trialsPresented.iti]; % store presented itis 
itiSteps = expt.p.itis; % edges of hist bins = requested itis
histITI = histogram(iti, itiSteps, 'FaceColor', histColor, 'Normalization', 'probability'); % default count, normalization probability 
histITI.BinEdges = histITI.BinEdges - histITI.BinWidth/2;

hold on % fit hazard 
itiPDF = expt.p.hazardProb.*(1-expt.p.hazardProb).^(0:numel(itiSteps)-1); % f = p.*(1-p).^x;
plot(itiSteps,itiPDF)

set(gca, ...
  'Box'         , 'off'     , ...
  'XTick'       , itiSteps       ...
);
ylim([0,0.4])
xlabel('Time (s)')
ylabel('Proportion')
title(sprintf('ITIs; hazard probability = %0.2f', p.hazardProb))

%% plot stim params 
figure

% orientation
subplot(2,1,1)
orientation = [expt.trialsPresented.orientation];
histOrientation = histogram(orientation, [expt.p.gratingOrientations 180], 'FaceColor', histColor, 'Normalization', 'probability');
histOrientation.BinEdges = histOrientation.BinEdges - histOrientation.BinWidth/2;
set(gca, ...
  'Box'         , 'off'     , ...
  'XTick'       , expt.p.gratingOrientations       ...
);
xlabel('Orientation (degree)')
ylabel('Proportion')
xrange = [-12.5, 170];
hold on
orientationRef = 1/max(size(expt.p.gratingOrientations)); 
plot(xrange, [orientationRef, orientationRef], 'r', 'LineWidth', 1)
title('Stimuli Presented')

% phase
subplot(2,1,2)
phase = [expt.trialsPresented.phase];
histPhase = histogram(phase, [expt.p.gratingPhases  max(expt.p.gratingPhases)+pi/2], 'FaceColor', histColor, 'Normalization', 'probability');
histPhase.BinEdges = histPhase.BinEdges - histPhase.BinWidth/2;
set(gca, ...
  'Box'         , 'off'     , ...
  'XTick'       , expt.p.gratingPhases       ...
);
xlabel('Phase')
ylabel('Proportion')
xrange = [-1, 5.5];
ylim([0,0.35])
hold on
phaseRef = 1/max(size(expt.p.gratingPhases)); 
plot(xrange, [phaseRef, phaseRef], 'r', 'LineWidth', 1)

