function p = cupcakeMEGParams

p.testingLocation = 'desk'; % 'CarrascoL1','desk'

switch p.testingLocation
    case {'desk'}
        p.keyNames = {'1!'};
        p.refRate = 60;
        p.screenSize = [9 13]; % (in)
        p.screenRes = [1280 1024];
        p.viewDist = 36; % (in)
        p.eyeTracking = 0;
    case 'CarrascoL1'
        p.keyNames = {'1!'};
        p.refRate = 60;
        p.screenSize = [40 30];
        p.screenRes = [1024 768];
        p.viewDist = 56;
        p.eyeTracking = 1; 
    otherwise
        error('Testing location not found.')
end

p.keyCodes = KbName(p.keyNames);
p.backgroundColor = 0.5;
p.nReps = 1;
p.nTrialsPerBlock = 72;
p.font = 'Verdana';
p.fontSize = 24;
p.fixColor = 1;
p.showPlaceholders = 1;
p.phLineWidth = 2; % (pixels)
p.eyeRad = 1.5; % allowed fixation radius (degrees)    

% Timing
p.gratingDur = 0.2; 
p.itis = 0.5:0.05:0.8; 
p.extraITI = 0.5; % insert after a button press or feedback tone
p.toneDur = 0.2;
p.eyeSlack = 0.12; % cushion between last fixation check and next stimulus presentation

% Images
p.imPos = [0 0];
p.imSize = [5 5]; % this is the size of the image container that holds the stim
p.gratingDiameter = [4 1]; % [outer inner] 
p.gratingSF = 1.5; % cpd
p.gratingOrientations = 1:180; 
p.gratingPhases = [0 pi/2 pi 3*pi/2]; % eg. 0, or [0 pi/2 pi 3*pi/2]
p.gratingContrasts = 0.05; 
p.aperture = 'cosyne-ring';
p.apertureEdgeWidth = 0.5;
if strfind(p.aperture,'radial')
    p.apertureSF = 1/(2*p.apertureEdgeWidth);
end

% Task
p.targetStates = [1 0]; % 1=present, 0=absent
p.propTargetPresent = 0.1;
p.responseWindowDur = 0.5;

% Staircase
p.staircase = 1;
p.stairs = [1 .8 .6 .4 .2 0]; % hard to easy
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
% 10^0.5 for every 10dB




