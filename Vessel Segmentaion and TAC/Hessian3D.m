function [Dxx, Dyy, Dzz, Dxy, Dxz, Dyz] = Hessian3D(immat_3D)
% Calculate the entries of Hessian matrix
% Input:
% immat_3D        input image
% Output:
% D**             the second derivative of the Hessian matrix
%
%
% Dakai Zhou


% to get the second derivative of the convoluted image
[Dx, Dy, Dz] = gradient(immat_3D);
[Dxx, Dxy, Dxz] = gradient(Dx);
[Dyx, Dyy, Dyz] = gradient(Dy); % is redundant since Dij = Dji here
[Dzx, Dzy, Dzz] = gradient(Dz); % possiable to write a more effient function for grasient

clear Dx Dy Dz Dyx Dzx Dzy immat_3D_conv;
end


