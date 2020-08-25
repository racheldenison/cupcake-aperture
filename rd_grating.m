function grating = rd_grating(pixelsPerDegree, sizeDegrees, ...
    spatialFrequency, tiltDegrees, phase, contrast)

% function grating = rd_grating(pixelsPerDegree, sizeDegrees, ...
%     spatialFrequency, tiltDegrees, phase, contrast)
%
% Inputs:
% pixelsPerDegree [=99]: pixels per degree of visual angle
% sizeDegrees [=2]: side length in degrees of visual angle
% spatialFrequency [=3]
% tiltDegrees [=0]
% phase [=0]
% contrast [=1]: contrast of the grating, 0-1
%
% Outputs:
% grating image scaled 0-1

%% inputs
if nargin==0
    pixelsPerDegree = 100; 
    sizeDegrees = 2;
    spatialFrequency = 1;
    tiltDegrees = 0; 
    phase = 0;
    contrast = 1;
end

%% Make meshgrid
sizePixels = round(sizeDegrees * pixelsPerDegree);

grid = linspace(-sizeDegrees/2, sizeDegrees/2, sizePixels);

[x, y] = meshgrid(grid, grid);

%% Make grating
a = cos(tiltDegrees * pi/180) * spatialFrequency * 2*pi;
b = sin(tiltDegrees * pi/180) * spatialFrequency * 2*pi;

sinwav = sin(a*x+b*y+phase);

grating = .5 + .5*(contrast * sinwav);

%% Show grating
% imshow(grating)

