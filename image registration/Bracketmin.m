function T = Bracketmin(R, F, prot_img, p0, f, dir)
% bracket minimum in a interval T(2) between T(1) and T(3), based on spm
% Input:
% f               initial function value(mutual information)
% dir             direction which bracket is working in
% p0              initial  parameter
% R               reference image
% F               floating image
% prot_img        the most privous rotated image
% Output:
% T               triplet, the interval and corresponding function value
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Method based on the description in 10.1 Initially Bracketing a Minimum of
% Numerical Recipes(The Art of Scientific Computing) and SPM12
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%
% Dakai Zhou


gold = (1+sqrt(5))/2;
T = struct('x', 0, 'f',f);
T(2).x = 1;
[T(2).f, T(2).x, ~] = FuncEval1(R, F, prot_img, p0, T(2).x, dir);

if T(2).f > T(1).f
    T(3) = T(1);
    T(1) = T(2);
    T(2) = T(3);
end

% generate the third point by golden ratio
T(3).x = T(2).x + gold*(T(2).x-T(1).x);
[T(3).f, T(3).x, ~] =  FuncEval1(R, F, prot_img, p0, T(3).x, dir);


while T(2).f > T(3).f
    % fit a polynomial to T
    tmp = cat(1,T.x);
    pol = pinv([ones(3,1), tmp, tmp.^2]) * cat(1, T.f);
    
    % minimum is where gradient of polynomial is zero and the second
    % derivertive should be positive, which means pol(3)>0
    if pol(3)>0
        % minimum is at where gradient is zero, d is the distance to T(2)
        tmin = -pol(2)/(2*pol(3));
        d = tmin-T(2).x;
        absd = abs(d);
        % distance limit by golden ratio selection
        dlim = T(3).x + gold*(T(3).x-T(2).x) - T(2).x;
        absdlim = abs(dlim);
        if absd > absdlim
            d = dlim;
        end
        u.x = d + T(2).x;
    else
        % if there is no minimum, extend by goldn ratio
        u.x = T(3).x + gold*(T(3).x-T(2).x);
    end

    % function evaluation
    [u.f, u.x, ~] =  FuncEval1(R, F, prot_img, p0, u.x, dir);
    
    
    if (T(2).x < u.x && u.x < T(3).x) || (T(2).x > u.x && u.x > T(3).x)
        % minimum u is between T(2) and T(3)
        if u.f < T(3).f
            T(1) = T(2);
            T(2) = u;
            return
        elseif u.f > T(2).f
            % minimum is between T(1) and u
            T(3) = u;
            return
        end
    end
    
    % arrange the order of the points
    T(1) = T(2);
    T(2) = T(3);
    T(3) = u;
end
end