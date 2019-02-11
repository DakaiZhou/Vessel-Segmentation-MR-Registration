function [p] = InitialGuess2(R, F)
% Initial guess of image registration, to move the center of mass together
% Input:
% R, F       reference image and floating image
% Output:
% img        initial gusess image
% p          initial parameter
%
%
% Dakai Zhou

% centers of two images
[CRx,CRy,CRz] = CenterofMass(R);
[CFx,CFy,CFz] = CenterofMass(F);

% calculate initial parameter
p1 = [CRx,CRy,CRz]'-[CFx,CFy,CFz]';
p = zeros(6,1);

% In ordet toonly get a image has same size as reference image, do rtation 
% in RigidTrans and do translation in ChopImg.
% [~, rot_img] = RigidTrans_v2(F, p);
% sz = size(R);
% img = ChopImg(F, rot_img, sz, p1);
p(1:3) = p1;
end