% function rd_combineRunsCupcake(subjectID, runs)

%% setup
% behavDir = '/Local/Users/denison/Data/Cupcake/Behavior';
behavDir = '/Volumes/purplab/EXPERIMENTS/1_Current_Experiments/Rachel/Cupcake/Cupcake_Aperture/Behavior'; % '/Local/Users/denison/Google Drive/Shared/Projects/Cupcake/Code/MEG_Expt/Pilot1_Aperture';
subjectID = 'R1507_20200311';
runs = [1 2 5 6 9 10]; %[3 4 7 8 11 12];
nRuns = numel(runs);

analysisFileName = sprintf('%s/%s/%s_CupcakeAperture_runs%d-%d.mat', behavDir, subjectID, subjectID, runs(1), runs(end));

%% initialize variables to combine
trials = [];
staircase.stairValues = [];
staircase.reversalValues = [];

%% runs
for iRun = 1:nRuns
    run = runs(iRun);
    
    %% load data
    behavFile = dir(sprintf('%s/%s/%s_disk_run%02d_Cupcake*.mat', behavDir, subjectID, subjectID, run));
    
    b = load(sprintf('%s/%s', behavFile.folder, behavFile.name));
    
    %% initialize expt
    if iRun==1
        expt = b.expt;
        expt.run = runs;
        expt.timing = [];
        expt.trials = [];
        expt.trialsPresented = [];
        expt.staircase = [];
        expt.whenSaved = [];
    elseif iRun==nRuns
        staircase.threshold = b.expt.staircase.threshold;
    end
    
    %% combine
    trials = [trials; b.expt.trials];
    staircase.stairValues = [staircase.stairValues b.expt.staircase.stairValues];
    staircase.reversalValues = [staircase.reversalValues b.expt.staircase.reversalValues];
    
end

%% store
expt.trials = trials;
expt.staircase = staircase;
expt.whenSaved = datestr(now);

%% save
save(analysisFileName,'expt')