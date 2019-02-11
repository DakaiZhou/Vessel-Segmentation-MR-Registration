function MI = MutualInfo(A, B)
% calculate mutual information for two images
% Input:
% A, B           input images with same dimension
% bin            bin for the joint histogram
% Output:        
% MI             mutual information
%
%
% Dakai Zhou

% make image same size
% dimA = size(A);
% dimB = size(B);
% if sum(dimA==dimB) ~= 3
%     dim = max([dimA;dimB]);
%     imgA = zeros(dim);
%     imgB = zeros(dim);
%     imgA(1:dimA(1), 1:dimA(2), 1:dimA(3)) = A;
%     imgB(1:dimB(1), 1:dimB(2), 1:dimB(3)) = B;
% end
[jh, n] = JointHist(A,B);
p = jh ./ n;
marg_A = sum(p,2);
marg_B = sum(p,1);
MI = p .* log2(p ./ (marg_A * marg_B));
% define 0log(0) = 0 (log(0) = -Inf, 0*-Inf = nan) 
MI(isnan(MI)) = 0;
MI = sum(MI(:));
end