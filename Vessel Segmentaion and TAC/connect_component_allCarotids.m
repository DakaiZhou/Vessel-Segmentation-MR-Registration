function [vessel1, vessel2, vessel_both] = connect_component_allCarotids(immat_3D_thres)
% Select first 2 largest connect component and show them in seperated 
% image. And combine the largest 2 connect component in one image
% Input:
% immat_3D_thres       input image
% Output:
% vessel1              the larget connect component 
% vessel2              the second largest connect componnent
% vessel_both          the one contains the largest two connect componnent
%
%
% Dakai Zhou


tmp = immat_3D_thres;
CC = bwconncomp(tmp);
numPixels = cellfun(@numel,CC.PixelIdxList);
dim = size(tmp);
vessel1 = zeros(dim);
vessel2 = zeros(dim);

[biggest,idx] = max(numPixels);
 vessel1(CC.PixelIdxList{idx}) = 1;


numPixels_1 = numPixels;

% Update the components
numPixels_2 = numPixels_1(numPixels_1 ~= biggest);
biggest = max(numPixels_2);
idx = (numPixels == biggest);
vessel2(CC.PixelIdxList{idx}) = 1;

vessel_both = double(or(vessel1,vessel2));

end