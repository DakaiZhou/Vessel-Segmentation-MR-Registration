function [xmin, fmin, prot_img] = BrentMethod(R, F, prot_img, p0, T, tol, dir)
% Given a bracketing triplet abscissas T such that T(2).x is between T(1).x
% and T(3).x, T(2).f is between T(1).f and T(3).f. Use this triplet find
% the minimum via Brent method
% Input:
% R                reference image
% F                floating image
% prot_image       the most privious rotated image
% p0               initial guess
% T                triplet which brackets a minimum
% tol              tolerance, should generally be no smaller than the 
%                  square root of your machine’s floating-point precision
% dir              direction which rent method is working in
% Output:
% xmin             the abscissa of the minimum
% fmin             minimum function value
% prot_img         the most privious rotated image
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Method based on the description in 10.3 Parabolic Interpolation and 
% Brent’s Method in One Dimension of Numerical Recipes(The Art of 
% Scientific Computing) and SPM12
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%
% Dakai Zhou


itermax = 150;
gold = 1-(sqrt(5)-1)/2;

% sort T in ascending order along T.f	
[~, idx] = sort(cat(1, T.f));
T = T(idx);
% a,b are interval
minx = min(cat(1, T.x));
maxx = max(cat(1, T.x));
d = inf;
pd = inf;

for iter = 1:itermax
    if abs(maxx-minx) <= tol %|| abs(abs(T(1).f-T(3).f)) <= sqrt(eps)
        fmin = T(1).f;
        xmin = T(1).x;
        return
    end
    
    ppd = pd;
    pd = d;
    
    % fit a polynomial to T
    tmp = cat(1, T.x);
    pol = pinv([ones(3,1), tmp, tmp.^2]) * cat(1, T.f);
    
    % the minimum of the polynomial is where the gradient is zeros
    u.x = -pol(2)/(2*pol(3)+eps); % in case pol(3) is zero
    d = u.x - T(1).x;
    
    % check the acceptability of the polynomial fit
    % the new displacement to T(1).x should be less than the last two 
    % displacement, the new point should be in the interval, the point
    % should be a minimum rather than a maximim
    tol2 = 2*eps*abs(T(1).x)+eps;
    if abs(d)>abs(ppd)/2 || u.x < minx+tol2 || u.x > maxx-tol2 || pol(3) <= 0
        % if the  conditions above are not met, take the golden section
        % step into the larger of the two segments.
        if T(1).x >= 0.5*(minx+maxx)
            d = gold*(minx-T(1).x);
        else
            d = gold*(maxx-T(1).x);
        end
        u.x = T(1).x+d;
    end
    
    
    % Function evaluation 
    [u.f, u.x, prot_img] =  FuncEval1(R, F, prot_img, p0, u.x, dir);
    %u.f = TestFunc(p0,u.x);
    %u
    % doing updates for the triplet and interval
    if u.f < T(1).f 
        T(3) = T(2);
        T(2) = T(1);
        T(1) = u;
    else
        if u.f < T(2).f
            T(3) = T(2);
            T(2) = u;
        elseif u.f < T(3).f
            T(3) = u;
        else
            % Do not complain one iteration since there are many iteration
            % left to make it up. This step can avoid of infinit loop.
            % Because the mutual information of image registration is not 
            % a smooth function. The initial braccked minimun may have a
            % local minimun(T1.f<T2.f<T3.f, T1.x<T3.x<T2.x), in this case
            % the loop will not stop.
            fmin = T(1).f;
            xmin = T(1).x;
            return
        end
    end
    minx = min(cat(1, T.x));
    maxx = max(cat(1, T.x));
end
end
    
