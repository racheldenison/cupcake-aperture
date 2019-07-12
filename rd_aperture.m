function [imout, ap] = rd_aperture(im, type, rad, w, af)

% function [imout, ap] = rd_aperture(im, type, rad, w, af)
%
% type is the type of aperture:
%   'square','gaussian','cosine','cosine-ring','radial-sine','radial-sine-ring','vignette-ring'
%
% rad is the radius of the aperture opening 
%   for 'gaussian', sigma = rad
%   for 'cosine-ring' aperture, rad = [outer inner]
%
% w is the width of the aperture edge ('cosine*','radial*')
%   frequency of sine wave = 1/(2*w)
%   for 'radial*', also controls the spatial frequency
%
% af is the angular frequency, for 'vignette' only

%% Check inputs
if any(strfind(type, 'ring'))
    if length(rad)~=2
        rad = [rad 0];
    end
else
    if length(rad)==2
        rad = rad(1);
    end
end

if nargin < 5
    af = [];
end

%% Setup
sz = size(im);

%% Make polar meshgrid
grid1 = linspace(-sz(1)/2, sz(1)/2, sz(1));
grid2 = linspace(-sz(2)/2, sz(2)/2, sz(2));

[x, y] = meshgrid(grid2, grid1);
[th, r] = cart2pol(x,y);

%% Make aperture
switch type
    case 'square'
        ap = zeros(sz);
        ap(r.^2 < rad^2) = 1;
        
    case 'gaussian'
        ap = exp(-r.^2/(2*rad^2)); % sigma = rad, ~4 SDs are visible at full contrast
        
    case 'cosine'
        p = w*2; % period
        f = 1/p; % frequency
        phase = (p/4 - rad)/p * 2*pi;
        
        ap = cos(2*pi*f*r + phase);
        ap(r > rad + w/2) = -1;
        ap(r < rad - w/2) = 1;
        
        ap = ap/2 + .5; % set range 0-1
        
    case 'cosine-ring'
        p = w*2; % period
        f = 1/p; % frequency
        phase = (p/4 - rad)/p * 2*pi;
        
        for i = 1:numel(rad)
            a = cos(2*pi*f*r + phase(i));
            a(r > rad(i) + w/2) = -1;
            a(r < rad(i) - w/2) = 1;
            ap0{i} = a/2 + .5;
        end
        
        ap = ap0{1} - ap0{2};
        
    case 'radial-sine'
        p = w*2; % period
        f = 1/p; % frequency
        phase = (p/4 - rad)/p * 2*pi;
        
        ap = cos(2*pi*f*r + phase);
        ap(r > rad + w/2) = -1;
        
        ap = ap/2 + .5; % set range 0-1
        
    case 'radial-sine-ring'
        p = w*2; % period
        f = 1/p; % frequency
        phase = (p/4 - rad)/p * 2*pi;
        
        ap1 = cos(2*pi*f*r + phase(1));
        ap1(r > rad(1) + w/2) = -1;
        ap1 = ap1/2 + .5; 
        
        ap2 = cos(2*pi*f*r + phase(2));
        ap2(r > rad(2) + w/2) = -1;
        ap2(r < rad(2) - w/2) = 1;
        ap2 = ap2/2 + .5; 
        
        ap = ap1.*(1-ap2);
        
    case 'vignette-ring'
        %% Roth radial scaled eccentricity vignette
        p = w*2; % period
        f = 1/p; % frequency
        phase = (p/4 - rad)/p * 2*pi;
        
        % radial modulator that scales by eccentricity, adapted from Roth 2018
%         af = 8.25; % angFreq
        a = ((4*af+pi)/(4*af-pi))^(2/pi);
        modulator = cos(log(r)/log(a));
        
        im = (im - .5).*modulator + .5; % range 0 to 1
        
        % take absolute value of modulator so blacks and whites become 1,
        % greys 0.5
        ap1 = abs(modulator);
        ap1(r > rad(1) + w/2) = 0;
        
        % change 0.5 to determine grating space ratio
        ap1(ap1 > 0.5) = 1;
        ap1(ap1 < 0.5) = 0;
        
        ap2 = cos(2*pi*f*r + phase(2)); % aperture for center cutout
        ap2(r > rad(2) + w/2) = -1;
        ap2(r < rad(2) - w/2) = 1;
        ap2 = ap2/2 + .5;
        
        ap = ap1.*(1-ap2);
        
        ap(ap > 0.5) = 1;
        ap(ap < 0.5) = 0;
        
    otherwise
        error('type not recognized')
end

%% Mask with aperture
imout = (im - .5).*ap + .5;

