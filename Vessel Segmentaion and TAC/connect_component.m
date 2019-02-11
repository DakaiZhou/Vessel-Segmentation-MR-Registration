function [immat_3D_conncomp] = connect_component(immat_3D_thres, n)
% select first n largest connect component and show them in one image
% Input: 
% immat_3D_thres      input binary image
% n                   the first n largest connect component, is a positive 
%                     integer
% Output: 
% immat_3D_conncomp   the first n largest connect component
%
%
% Dakai Zhou

CC = bwconncomp(immat_3D_thres);
numPixels = cellfun(@numel,CC.PixelIdxList);
dim = size(immat_3D_thres);
immat_3D_conncomp = zeros(dim);
new_numPixels = numPixels;

if CC.NumObjects < n
    n = CC.NumObjects;
end

for i = 1 : n
    % number of pixels of the largest component
    biggest = max(new_numPixels);
    % index of the largest componnent
    idx = (numPixels == biggest);
    % if several objects have the same size, find them and assign them to 1
    % in the inner for loop
    if sum(idx) > 1
        for j = 1 : sum(idx)
            sub_idx = zeros(size(idx));
            x = find(idx==1, 1,'first');
            sub_idx(x) = 1;
            sub_idx = logical(sub_idx);
            immat_3D_conncomp(CC.PixelIdxList{sub_idx}) = 1;
            n = n-1;
            idx(x) = 0;
        end
    else 
        % only one nth largest component
        immat_3D_conncomp(CC.PixelIdxList{idx}) = 1;
        new_numPixels = new_numPixels(new_numPixels ~= biggest);
    end
end
end