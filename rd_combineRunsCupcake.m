% function rd_combineRunsCupcake(subjectID, runs)

%% setup
behavDir = '/Local/Users/denison/Data/Cupcake/Behavior';
subjectID = 'R1507_20190425';
runs = 1:8;
nRuns = numel(runs);

analysisFileName = sprintf('%s/%s/%s_CupcakeAperture_runs%d-%d.mat', behavDir, subjectID, subjectID, runs(1), runs(end));

%% initialize variables to combine
trials = [];
staircase.stairValues = [];
staircase.reversalValues = [];

%% runs
for iRun = 1:nRuns
    %% load data
    behavFile = dir(sprintf('%s/%s/%s_run%02d_Cupcake*.mat', behavDir, subjectID, subjectID, iRun));
    
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