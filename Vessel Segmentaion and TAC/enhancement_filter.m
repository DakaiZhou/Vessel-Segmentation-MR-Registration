function [immat_3D_out] = enhancement_filter(immat_3D, Alpha, Beta, CC, Sigma, mode)
% Vessel enhancement algorithm
% Input:
% immat_3D          Volume contains vessels
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
% immat_3D_out      enhanced image
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This algorithm based on the algorithm proposed by Frangi et al. in 
% 'Multiscale vessel enhancement filtering'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%
% Dakai Zhou

[x,y,z]= size(immat_3D);

% Choose the mode 
if mode == 0
    % Whole image
else
    if mode == 1
        % Registrated image
        immat_3D = immat_3D(round(x*0.35):round(x*0.65), round(y*0.35):round(y*0.65), 1:round(z*0.65));
        
        %immat_3D = immat_3D(round(x*0.45):round(x*0.7), round(y*0.3):round(y*0.65), round(z*0.3):round(z*0.8));
    else
        if mode ==2
            % Original MR
            immat_3D = immat_3D(round(x*0.45):round(x*1), round(y*0.3):round(y*0.65), round(z*0.2):round(z*0.8));
        else
            error('Mode eror: this mode is not available');
        end
    end
end

max_Pvalue = max(immat_3D(:));

C = max_Pvalue * CC;

for i = 1:length(Sigma)
    
    % convolut image with gaussian
    immat_3D_conv = imgaussfilt3(immat_3D, Sigma(i));
    
    % Calculate second partial derivatives
    [Dxx, Dyy, Dzz, Dxy, Dxz, Dyz] = Hessian3D(immat_3D_conv);
    
    dim = size(Dxx);
    
    if Sigma(i)>0
        gamma = Sigma(i)^2;
        Dxx = gamma*Dxx;
        Dyy = gamma*Dyy;
        Dzz = gamma*Dzz;
        Dxy = gamma*Dxy;
        Dxz = gamma*Dxz;
        Dyz = gamma*Dyz;
    end
    
    % Calculate eigenvalues
    [lambda1,lambda2, lambda3] = eig3_v2(Dxx,Dyy,Dzz, Dxy, Dxz,Dyz);
    
    clear Dxx Dyy  Dzz Dxy  Dxz Dyz;
    
    abslambda1 = abs(lambda1);
    abslambda2 = abs(lambda2);
    abslambda3 = abs(lambda3);
    
    % Three ratios
    Rb = abslambda1 ./ sqrt(abslambda2.*abslambda3);
    Ra = abslambda2 ./ abslambda3;
    S = sqrt(lambda1.^2 + lambda2.^2 + lambda3.^2);
    
    a = 2 * Alpha^2;
    b = 2 * Beta^2;
    c = 2 * C^2;
    
    clear abslambda1 abslambda2 abslambda3;
    
    p1 = (1 - exp(-Ra.^2/a));
    p2 = exp(-Rb.^2 / b);
    p3 = (1 - exp(-S.^2/c));
    
    clear Ra Rb S a b c;
    
    % Enhancement function
    V0 = p1 .* p2 .*p3;
    %   V0 = p1 .* p3;
    
    clear p1 p2 p3
    
    % Set pixels form non-vessel structure to 0
    V0(lambda2>0) = 0;
    V0(lambda3>0) = 0;
    V0(~isfinite(V0)) = 0;
    
    if i == 1
        immat_3D_out = V0;
    else
        % Assign the maximum response to pixels
        immat_3D_out = max(immat_3D_out, V0);
    end
end

immat_3D_out = reshape(immat_3D_out, dim);
tmp = zeros(x,y,z);

% Recover the whole size image
if mode == 0
    tmp = immat_3D_out;
end

if mode ==1
tmp(round(x*0.35):round(x*0.65), round(y*0.35):round(y*0.65), 1:round(z*0.65)) = immat_3D_out;
end
%tmp(round(x*0.45):round(x*0.7), round(y*0.3):round(y*0.65), round(z*0.3):round(z*0.8)) = immat_3D_out;

if mode ==2
tmp(round(x*0.45):round(x*1), round(y*0.3):round(y*0.65), round(z*0.2):round(z*0.8)) = immat_3D_out;
end

immat_3D_out = tmp;

clear tmp
end