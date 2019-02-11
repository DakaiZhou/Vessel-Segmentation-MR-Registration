function [f, stpz, prot_img] = FuncEval1(R, F, prot_img, p0, stpz, dir)
% Input:
% R          reference image
% F          floating image
% prot_img   privious rotated image
% p0         initial guess
% stpz       stepsize of the transformation
% dir        transformation direction
% Output:
% f          mutual information
% stpz       stepsize of the transformation
% prot_img   the most previous rotated image
%
%
% Dakai Zhou



if sum(dir(1:3)) ~= 0, stpz = round(stpz); end
p = p0+stpz*dir;
p1 = [0;0;0;p(4:6)];

% if without rotation in this direction(only translation), reuse the 
% privious rotated image to avoid the same rotation calculation
if sum(dir(4:6)) == 0
    sz = size(R);
    img = ChopImg2(prot_img, sz, p(1:3));
    
    f = -MutualInfo(R, img);
else
% if has rotation do the whole process
    [~, rot_img] = RigidTransTriLinear(F, p1);
    sz = size(R);
    img = ChopImg2(rot_img, sz, p(1:3));
    prot_img = rot_img;
    
    f = -MutualInfo(R, img);
end
end
