function [p0, p,f, img, vf] = ImgCoreg(R, F, tol)
% Image Registration
% Input:
% R                  reference image structure
% F                  floating image structure
% tol                six elements vector, tolerances of each transformation
%                    parameter, first three for translations, the other
%                    three for rotations with unit degree. Recommend
%                    (0,0,0,0.01,0.01,0.01).
% Output:
% p0                 initial guess
% p                  final transformation parameters
% f                  final mutual information
% img                registered image
% vf                 vector contains mutual information in each iteration
%
%
% Dakai Zhou

disp('Doing image registration...')
[p0, p,f, img, vf] = ImReg(R, F, tol);
disp('Done')
end