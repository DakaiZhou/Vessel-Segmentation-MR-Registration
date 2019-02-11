function f = FuncEval2(R, F, p)
% Input:
% R          reference image
% F          floating image
% p          transformation parameters
% Output:
% f          mutual infomation
%
%
% Dakai Zhou

p1 = zeros(6,1);
p1(4:6) = p(4:6);
[~, rot_img] = RigidTransTriLinear(F, p1);
sz = size(R);
img = ChopImg2(rot_img, sz, p(1:3));

f = -MutualInfo(R, img);
end