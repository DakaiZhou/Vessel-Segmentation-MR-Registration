function [t] = OtsuMethod(img)
% Based on matlab build-in function otsuthresh
% Input:
% img               input image
% Output:
% t                 threshold intensity of the inout image
%
%
% Dakai Zhou

I = nonzeros(img(:));
counts = imhist(I,max(I));
num_bin = numel(counts);
p = counts./sum(counts);
omega = cumsum(p);
tmp = cumsum((1:num_bin)'.*p);
mu = tmp./omega;
mu_T = mu(end);
sigma_b_squared = omega.*(1-omega).*(mu-(mu_T-tmp)./(1-omega)).^2;

maxval = max(sigma_b_squared);
isfinite_maxval = isfinite(maxval);
if isfinite_maxval
    idx = mean(find(sigma_b_squared == maxval));
    t = idx;
    % Normalize the threshold to the range [0, 1].
    %t = (idx - 1) / (num_bin - 1);
else
    t = 0.0;
end