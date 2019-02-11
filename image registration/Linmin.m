function [p,f,prot_img] = Linmin(R, F, prot_img, p0, dir, f, tol)
% Line search for minimum via Brent method
% Input:
% R, F              reference image and floating image
% prot_img          the most previous rotated image
% p0                initial parameter
% dir               search direction
% f                 function of the initial parameter
% tol               tolorance
% Output:
% p                 result parameter
% f                 result function value
% prot_img          the most previous rotated image
%
%
% Dakai Zhou

 p0 = p0(:);
 T = Bracketmin(R, F, prot_img, p0, f, dir);
 
 % If there is rotation
 if sum(dir(4:5)) ~= 0, prot_img = F; end
 
 [xmin, f, prot_img] = BrentMethod(R, F, prot_img, p0, T, tol, dir);
 p =  p0+xmin*dir;
 p(1:3) = round(p(1:3));
end