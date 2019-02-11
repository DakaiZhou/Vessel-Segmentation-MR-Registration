function TACpvc = PVC(pet, plotnum, vFWHM,varargin)
% Apply partial volume correction with GTM
% Input:
% pet                   PET image
% plotnum               number of time frames to be plotted
% vFWHM                 vector stores FWHM of the point spread function in
%                       each dimention
% Output:
% TACpvc                partial volume corrected values


n = nargin-3;

numpet = size(pet);
if numel(numpet) == 3
    numpet = 1;
elseif numel(numpet) == 4
    numpet = numpet(4);
end

c = zeros(numpet,1);
if n == 2
    TACpvc = zeros(numpet,3);
else
    TACpvc = zeros(numpet,n);
end

% ROIs masks
for i = 1:n
    
    %%%%%%%% Three regions %%%%%%%%%
%     tmp1 = imdilate(varargin{i}, se2);
%     tmp2 = tmp1-1;
%     tmp2(tmp2 == -1) = 1;
% 
%     roi1 = tmp1-varargin{i}; % tissue around vessel
%     roi2 = varargin{i}; % vessel
%     roi3 = tmp2; % background
%     gtm = GTM(vFWHM, roi1, roi2, roi3)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%%%%% Two regions %%%%%%%%%%%%%
    roi1 = varargin{i};
    [roi1, x, y, z] = SmallROI(roi1); % vessel
    roi2 = roi1-1;
    roi2(roi2 == -1) = 1; % background
    gtm = GTM(vFWHM, roi1, roi2);
    %gtm
    %inv(gtm)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    for j = 1:numpet
        s = pet(:,:,:,j);
        s = s(x(1):x(2), y(1):y(2), z(1):z(2));
        t1 = sum(s(:).*roi1(:))/sum(roi1(:));
        t2 = sum(s(:).*roi2(:))/sum(roi2(:));
        T = gtm\[t1;t2];
        c(j) = T(1);
    end
    TACpvc(:,i) = c;
end
if n == 2
    TACpvc(:,3) = (TACpvc(:,1)+TACpvc(:,2))/2;
end

if numpet == 16
    minute = [0.5,1.5,2.5,3.5,4.5,6.5,9.5,12.5,15.5,18.5,22.5,27.5,32.5,37.5,42.5,47.5]';
end
if numpet == 23
    minute=[5/60,7.5/60,12.5/60,17.5/60,22.5/60,27.5/60,32.5/60,37.5/60,45/60,55/60,67.5/60,82.5/60,105/60,150/60,240/60,450/60,750/60,1050/60,1350/60,1650/60,2100/60,2700/60,3300/60];
end

figure
plot(minute(1:plotnum), TACpvc(1:plotnum,1), minute(1:plotnum), TACpvc(1:plotnum,2), minute(1:plotnum), TACpvc(1:plotnum,3))
xlabel('Minutes')
ylabel('SUV Dyn')
legend('Carotid1', 'Carotid1', 'Both')
title(strcat(strcat('First ', num2str(plotnum)), ' Time Frames(After PVC)'))

figure
plot(minute, TACpvc(:, 1), minute, TACpvc(:, 2), minute, TACpvc(:, 3))
xlabel('Minutes')
ylabel('SUV Dyn')
legend('Carotid1', 'Carotid1', 'Both')
title('Full Time Frames(After PVC)')
end