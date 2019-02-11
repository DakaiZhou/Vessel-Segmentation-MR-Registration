function gtm = GTM(vFWHM, varargin)
% GTM (geometric transfer matrix) method for Partial Volume Correction
% Input:
% vFWHM               vector of FWHM of all direction
% varargin            ROIs(regions of interest), binary map
% Output:
% gtm                 geometric transfer matrix
%
%
% Dakai Zhou

n = nargin-1; % number of ROIs
% stand deviations for gaussian
vstd = vFWHM/(2*sqrt(2*log(2)));
% GTM matrix
gtm = zeros(n);
% calculate GTM
for i = 1:n
    % convolve ROI with the PSF
    if numel(vstd) == 2 || numel(vstd) == 1
    cnvol = imgaussfilt(varargin{i}, vstd);
    elseif numel(vstd) == 3
        cnvol = imgaussfilt3(varargin{i}, vstd);
    end
    % calculate entries of GTM
    for j = 1:n
        spill = cnvol.*varargin{j};
        gtm(j,i) = sum(spill(:))/sum(varargin{j}(:));
    end
end
end


    