function p = cupcakeApertureParams

p.testingLocation = 'CarrascoL1'; % 'CarrascoL1','desk'

switch p.testingLocation
    case {'desk'}
        p.keyNames = {'1!'};
        p.refRate = 60;
        p.screenSize = [13 9]; % (in)
        p.screenRes = [1280 1024];
        p.viewDist = 36; % (in)
        p.eyeTracking = 0;
    case 'CarrascoL1'
        p.keyNames = {'1!'};
        p.refRate = 60;
        p.screenSize = [40 30];
        p.screenRes = [1280 960];
        p.viewDist = 56;
        p.eyeTracking = 0; 
    otherwise
        error('Testing location not found.')
end

p.keyCodes = KbName(p.keyNames);
p.backgroundColor = 0.5;
p.nReps = 1;
p.nTrialsPerBlock = 72;
% p.eyeRad = 1.5; % allowed fixation radius (degrees)   

% Text
p.font = 'Verdana';
p.fontSize = 24;

% Placeholders
p.showPlaceholders = 1;
p.phLineWidth = 2; % (pixels)
p.phCushion = 1; % degrees, expand ph by this amount relative to the image

% Fixation
p.fixColor = 1; %[1; p.backgroundColor]; % [inner; outer] 
p.fixDiameter = .35; %[.35 .7]; % deg

% Timing
p.itiType = 'hazard'; % 'uniform','hazard'
switch p.itiType
    case 'uniform'
        p.itis = 0.6:0.05:1;
    case 'hazard'
        p.itis = 0.6:0.05:2;
        p.hazardProb = 0.2; % at every time step, the probability of the event is 0.2
        p.itiPDF = p.hazardProb.*(1-p.hazardProb).^(0:numel(p.itis)-1); % f = p.*(1-p).^x;
    otherwise
        error('p.itiType not recognized')
end
p.extraITI = 0.5; % insert after a button press or feedback tone

p.gratingDur = 0.05; 
p.toneDur = 0.2;
p.responseWindowDur = 0.5;
p.eyeSlack = 0.12; % cushion between last fixation check and next stimulus presentation

% Images
p.imPos = [0 0];
p.imSize = [17 17]; % this is the size of the image container that holds the stim
p.gratingDiameter = [16 1]; % [outer inner] 
p.gratingSF = 1.5; % cpd
p.gratingOrientations = 0:20:179; %0:5:179; %0:20:179; 
p.gratingPhases = [0 pi/2 pi 3*pi/2]; % eg. 0, or [0 pi/2 pi 3*pi/2]
p.gratingContrasts = 1; 
p.aperture = 'radial-sine-ring'; % 'cosyne-ring','radial-sine-ring'
p.apertureEdgeWidth = 1; % half of a period, so sf of radial-sine aperture is 1/(2*width)
if strfind(p.aperture,'radial')
    p.apertureSF = 1/(2*p.apertureEdgeWidth);
end

% Task
p.targetStates = [1 0]; % 1=present, 0=absent
p.propTargetPresent = .2;

% Staircase
p.staircase = 1;
p.stairs = 1-logspace(-1.5,0,15); % hard (~1) to easy (0)
if p.staircase
    p.targetContrast = 0;
    fprintf('\nStaircase is ON\n')
end

% Sounds
p.Fs = 44100;
p.toneNames = {'miss','fa'};
p.toneFreqs = [523 784]; % [lower C, higher G]
for iTone = 1:numel(p.toneFreqs)
    tone = MakeBeep(p.toneFreqs(iTone), p.toneDur, p.Fs);
    p.tones(iTone,:) = applyEnvelope(tone, p.Fs);
end
p.toneOnsetSOA = 0.01; % 10 ms
% 10^0.5 for every 10dB

