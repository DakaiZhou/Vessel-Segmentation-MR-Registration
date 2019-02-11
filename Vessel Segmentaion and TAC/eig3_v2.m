function [lambda1, lambda2, lambda3] = eig3_v2(Dxx,Dyy,Dzz, Dxy, Dxz,Dyz)
% Calculate the eigenvalues of Hessian matrix. This algorithm uses matrix 
% operations to calculate the eigenvalues of each pixel simultaneously.
% Input:
% D**              the second partial derivatives
% Output:
% lambda*          the eigenvalues
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This algorithm is base on the algorithm in Eigenvalue Algorithm form 
% Wikipedia
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%
% Dakai Zhou

% This hessian matrix is symmetric and perform calculation element wisely
A = [Dxx, Dxy, Dxz; Dxy, Dyy, Dyz; Dxz, Dyz, Dzz];
p1 = Dxy.^2 + Dxz.^2 + Dyz.^2;
clear Dxy Dxz Dyz

[x, y, z] = size(Dxx);
A = reshape(A, [x*y*z*9,1]);

if p1 == 0
    % hessian matrix is diagonal
    mu1 = reshape(Dxx, [x*y*z,1]);
    mu2 = reshape(Dyy, [x*y*z,1]);
    mu3 = reshape(Dzz, [x*y*z,1]);
    %p1 = reshape(p1, [x*y*z,1]);
else
    q1 = (Dxx + Dyy + Dzz) / 3;                                         
    q = [q1, zeros(x,y,z), zeros(x,y,z);
         zeros(x,y,z), q1, zeros(x,y,z);
         zeros(x,y,z), zeros(x,y,z), q1];                                  
    q = reshape(q, [x*y*z*9,1]);
     
    p2 = (Dxx - q1).^2 + (Dyy -q1).^2 + (Dzz - q1).^2 + 2*p1;          
    clear Dxx Dyy Dzz 
    
    p = sqrt(p2 / 6);                                                   
    clear p2
    P_entry = 1 ./ p;                                                   
    P = [P_entry, P_entry, P_entry;
         P_entry, P_entry, P_entry;
         P_entry, P_entry, P_entry];                                    
    P = reshape(P, [x*y*z*9, 1]);
    clear P_entry
    
    B = P .* (A - q);                                                 
    
    clear q P
    
    B = reshape(B, [x*3, y*3, z]);
    b1 = reshape(B(1:x, 1:y, :), [x*y*z,1]);
    b2 = reshape(B(1:x, y+1:2*y, :), [x*y*z,1]);
    b3 = reshape(B(1:x, 2*y+1:3*y, :), [x*y*z,1]);
    b4 = reshape(B(x+1:2*x, 1:y, :), [x*y*z,1]);
    b5 = reshape(B(x+1:2*x, y+1:2*y, :), [x*y*z,1]);
    b6 = reshape(B(x+1:2*x, 2*y+1:3*y, :), [x*y*z,1]);
    b7 = reshape(B(2*x+1:3*x, 1:y, :), [x*y*z,1]);
    b8 = reshape(B(2*x+1:3*x, y+1:2*y, :), [x*y*z,1]);
    b9 = reshape(B(2*x+1:3*x, 2*y+1:3*y, :), [x*y*z,1]);
    clear B
    
    det_B = b1 .* b5 .* b9 + b4 .* b8 .* b3 + b2 .* b6 .* b7...
          - b3 .* b5 .* b7 - b1 .* b6 .* b8 - b9 .* b2 .* b4;
    R = det_B / 2;
    clear det_B b1 b2 b3 b4 b5 b6 b7 b8 b9
    
    
    % In exact arithmetic for a symmetric matrix  each element r in R 
    % satisfy -1 <= r <= 1. But computation error can leave it slightly 
    % outside this range.
    phi = zeros(x*y*z, 1);
    check = R <= -ones(x*y*z, 1);
    phi(check) = pi / 3;
    check = and(-ones(x*y*z,1)<R, R<ones(x*y*z,1));
    phi(check) = acos(R(check)) / 3;
    
    % Calculate engeivalues and mu3<=mu2<=mu1
    q1 = reshape(q1, [x*y*z,1]);
    p = reshape(p, [x*y*z, 1]);
    mu1 = q1 + 2 * p .* cos(phi);
    mu2 = q1 + 2 * p .* cos(phi + (2*pi/3));
    mu3 = 3 * q1 - mu1 - mu2;
end

clear phi q1 p

% sort eigenvalues to order abs(lambda1)<abs(lambda2)<abs(lambda3)
lambda1 = mu1;
lambda2 = mu2;
lambda3 = mu3;

check1 = and(abs(mu2) < abs(mu1), abs(mu2) < abs(mu3));
lambda1(check1) = mu2(check1);

check2 = and(abs(mu3) < abs(mu1), abs(mu3) < abs(mu2));
lambda1(check2) = mu3(check2);

check3 = and(abs(mu2) > abs(mu1), abs(mu2) > abs(mu3));
lambda3(check3) = mu2(check3);

check4 = and(abs(mu1) > abs(mu2), abs(mu1) > abs(mu3));
lambda3(check4) = mu1(check4);

check = xor(or(check1, check2), check4);
lambda2(check) = mu1(check);

check = xor(or(check3, check4), check2);
lambda2(check) = mu3(check);

clear mu1 mu2 mu3 check check1 check2 check3 check4

end

