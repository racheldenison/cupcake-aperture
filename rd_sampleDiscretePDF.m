function [samples, v, cushion] = rd_sampleDiscretePDF(f, nSamples, maxCushion)

% function [samples, v, cushion] = rd_sampleDiscretePDF(f, nSamples, maxCushion)
%
% Inputs:
% f is f(x), a pdf defined over discrete indices x
% nSamples is the number of samples to generate from this pdf
% maxCushion determines how many total samples to use to get the requested
% number of samples. must be higher when nSamples is lower, due to rounding
% issues.
%
% Outputs:
% samples is a vector of sample indices x from the distribution f(x)
% v is all the samples that were generated
% cushion is the cushion that was needed to generate nSamples

% example f
% p = .2;
% t = 0:20;
% f = p.*(1-p).^t;

if nargin < 3
    maxCushion = 1.2;
end

cushion = 1;
samples = [];

while isempty(samples) && cushion < maxCushion
    ns = nSamples*cushion;
    
    v = [];
    for i = 1:numel(f)
        n = round(ns*f(i));
        v = [v ones(1,n)*i];
    end
    
    samplesAll = v(randperm(length(v)));
    
    if numel(samplesAll)>=nSamples
        samples = samplesAll(1:nSamples);
    else
        cushion = cushion + 0.01;
    end
end

if isempty(samples)
    error('Not enough samples were generated. Increase maxCushion.')
end

