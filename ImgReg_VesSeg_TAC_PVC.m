function [p0, p,f,img,vf,Carotid1, Carotid2, CarodidBoth, TAC,TACPVC] =...
    ImgReg_VesSeg_TAC_PVC(R, F, tol, Alpha, Beta, CC, Sigma, mode, plotnum, vFWHM)
% Perform the MR/PET coregistration, vessel segmaentation and time activity
% curve generation.
%
% Input:
% R                 reference image structure
% F                 floating image structure
% tol               six elements vector, tolerances for each transformation
%                   parameter, first three for translations, the other
%                   three for rotations with unit degree. Recommend
%                   (0,0,0,0.01,0.01,0.01).
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
% plotnum           number of time frames to be plotted
% vFWHM             vector contains FWHM in all dimension
% Output:
% p0                initial guess
% p                 final transformation parameters
% f                 final mutual information
% img               registered image
% vf                vector contains mutual information in each iteration
% v1,v2,vb          carotid1, carotid2 and both of the carotids
% TAC               time activity curves with unit KBq/cc
% TACpvc            partial volume corrected values
%
%
% Dakai Zhou

[p0, p,f, img, vf] = ImgCoreg(R, F, tol);

[Carotid1, Carotid2, CarodidBoth] = CarotidSegmentation...
    (img, Alpha, Beta, CC, Sigma, mode);

disp('Generating time activity curve...')
TAC = TimeActivityCurve3(R.img, Carotid1, Carotid2, plotnum,vFWHM);
disp('Done.')

disp('Performing partial volume correction...')
TACPVC = PVC(R.img, plotnum, vFWHM,Carotid1, Carotid2);
disp('Done.')

end
