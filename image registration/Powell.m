function [p,f, vf] = Powell(R, F, prot_img, p, dir, tol)
% Powell's method
% Input:
% R F        reference image and floating image
% prot_img   the most previous rotated image
% p          initial parameters for rigid transformation, has six elements
% dir        matrix, each column is the direction of line search
% tol        tolerance
% Output:
% p          parameters of the minimum
% f          the minimum of the evaluated function
% vf         vector contains mutual information in each iteration
%
%
% Dakai Zhou

p = p(:);
f = FuncEval2(R, F, p);

vf(1) = f; 
j = 2;

i = 0;
while i < 500
    p0 = p;
    fp0 = f;
    ur = numel(p); % the direction of the maximum decrease
    r = 0; % the maximum decrease in f
    
    % loop over each parameter
    for k = 1:numel(p)
       % k
        fp = f;
        [p,f,prot_img] = Linmin(R, F, prot_img, p, dir(:,k), f, tol(k));
        
        vf(j) = f;
        j = j+1;
        
        if fp-f > r 
            r = fp-f;
            ur = k;
        end 
    end
    % stopping criteria
   % p
    %if sum(abs(p-p0)) < 6*sqrt(eps), return; end
    if fp0-f < sqrt(eps), return; end
    
    i = i+1;
    ftmp = FuncEval2(R, F, 2*p-p0);
    if ftmp < fp0 && 2*(fp0-2*f+ftmp)*(fp0-f-r)^2 < r*(fp0-ftmp)^2
        un = p-p0;
        dir(:,ur) = un;
        [p,f] = Linmin(R,F,prot_img,p0, un, fp0, sum(tol));
        
        vf(j) = f;
        j = j+1;
        
        % stopping criteria
        %if abs(fp0-f) <= tol, return; end
    end
end
end
