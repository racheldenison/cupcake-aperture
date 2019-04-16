function [imout, ap] = rd_aperture(im, type, rad, w)

% function [imout, ap] = rd_aperture(im, type, rad, w)
%
% type is the type of aperture:
%   'square','gaussian','cosyne','cosyne-ring','radial-sine','radial-sine-ring'
%
% rad is the radius of the aperture opening 
%   for 'gaussian', sigma = rad
%   for 'cosyne-ring' aperture, rad = [outer inner]
%
% w is the width of the aperture edge ('cosyne*','radial*')
%   frequency of sine wave = 1/(2*w)
%   for 'radial*', also controls the spatial frequency

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
        
    case 'cosyne'
        p = w*2; % period
        f = 1/p; % frequency
        phase = (p/4 - rad)/p * 2*pi;
        
        ap = cos(2*pi*f*r + phase);
        ap(r > rad + w/2) = -1;
        ap(r < rad - w/2) = 1;
        
        ap = ap/2 + .5; % set range 0-1
        
    case 'cosyne-ring'
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
        
    otherwise
        error('type not recognized')
end

%% Mask with aperture
imout = (im - .5).*ap + .5;

