function [Carotid1, Carotid2, CarodidBoth] = CarotidSegmentation(vol, Alpha, Beta, CC, Sigma, mode)
% Carotids segmentation
% Input:
% vol               Volume contains vessels
% Alpha             Controls sensitity to tubular-like structure and plate-
%                   like structure. Smaller Alpha enhances vessels more
% Beta              Controls sensitivity to blob-like structure. Smaller
%                   Beta suppresses blob-like structure.
% CC                Controls sensitivity to background and structures.
%                   Smaller CC enhances structure better
% Sigma             Scales which the algorithm running with
% mode              There are three modes: 0: enhance the whole image; 1: 
%                   enhance part of the registered MR image which contains 
%                   carotids; 2: enhance part of original MR image which
%                   contains carotids.
% Output:
% Carotid1, Carotid2, CarodidBoth
%                   They are three images, first two of which with single 
%                   carotid and last one include two carotids
%
%
% Dakai Zhou

disp('Enhancing tubular structure in multiscale...')
[vol_enhanced] = enhancement_filter(vol, Alpha, Beta, CC, Sigma, mode);
disp('Done.')

disp('Converting image to bit depth 8 bit...')
vol_enhanced = im2uint8(vol_enhanced);
disp('Done.')

disp('Binarizing image...')
[vol_enhanced_binary] = ImgBinarization(vol_enhanced);
disp('Done.')

disp('Seperating carotids...')
[Carotid1, Carotid2, CarodidBoth] = connect_component_allCarotids(vol_enhanced_binary);
disp('Done.')

% Matlab build-in function to view 3D image
disp('Carotids 3D Visualization...')
volumeViewer(CarodidBoth);
end