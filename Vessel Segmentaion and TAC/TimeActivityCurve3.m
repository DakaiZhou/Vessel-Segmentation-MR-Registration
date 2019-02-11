function TAC = TimeActivityCurve3(img, v1, v2, plotnum,vFWHM)
% use vessel mask and the dynamic PET image to generate the time activity 
% curves.
% Input:
% img                  the input image, i.e. dynamic PET image
% v1,v2,v3             they are vessel masks, v1,v2 contain one single
%                      carotic vessel, v3 has both vessels
% plotnum              number of time frames to be plotted
% Output:
% TAC                  time activity curves with unit KBq/cc

numImg = size(img, 4);
c1 = zeros(numImg,1);
c2 = zeros(numImg,1);
c3 = zeros(numImg,1);

if numImg == 16
    %t = [60;60;60;60;60;180;180;180;180;180;300;300;300;300;300;300];
    minute = [0.5,1.5,2.5,3.5,4.5,6.5,9.5,12.5,15.5,18.5,22.5,27.5,32.5,37.5,42.5,47.5]';
end

if numImg == 23
    %t=[5;5;5;5;5;5;5;5;10;10;15;15;30;60;120;300;300;300;300;300;600;600;600];
    minute=[5/60,7.5/60,12.5/60,17.5/60,22.5/60,27.5/60,32.5/60,37.5/60,45/60,55/60,67.5/60,82.5/60,105/60,150/60,240/60,450/60,750/60,1050/60,1350/60,1650/60,2100/60,2700/60,3300/60];
end

% Choose a small region of interest to reduces calculations
[v1, x1, y1, z1] = SmallROI(v1);
[v2, x2, y2, z2] = SmallROI(v2);

for i = 1 : numImg
    s = img(:,:,:,i);
    s1 = s(x1(1):x1(2), y1(1):y1(2), z1(1):z1(2));
    s2 = s(x2(1):x2(2), y2(1):y2(2), z2(1):z2(2));
    c1(i) = sum(s1(:).*v1(:)) / sum(v1(:));
    c2(i) = sum(s2(:).*v2(:)) / sum(v2(:));
    c3(i) = (sum(s1(:).*v1(:))+sum(s2(:).*v2(:))) / (sum(v1(:))+sum(v2(:)));
end
clear s nii img
TAC = [c1,c2,c3];
% large memory requirement
% v1_16 = repmat(vessel1, [1,1,1,numImg]);
% c1 = squeeze(sum(sum(sum(v1_16.*img,1),2),3));%./t/sum(vessel1(:));
% clear v1_16
% v2_16 = repmat(vessel2, [1,1,1,numImg]);
% c2 = squeeze(sum(sum(sum(v2_16.*img,1),2),3));%./t/sum(vessel2(:));
% clear v2_16
% vb_16 = repmat(vessel_both, [1,1,1,numImg]);
% cb = squeeze(sum(sum(sum(vb_16.*img,1),2),3));%./t/sum(vessel_both(:));
% clear vb_16


% figures;
figure
plot(minute(1:plotnum),c1(1:plotnum), minute(1:plotnum), c2(1:plotnum), minute(1:plotnum), c3(1:plotnum))
title(strcat(strcat('First ', num2str(plotnum)), ' Time Frames(Without PVC)'))
xlabel('Minutes')
ylabel('SUV Dyn')
legend('Carotid1', 'Carotid2', 'Both')

figure
plot(minute, c1, minute, c2, minute, c3)
title('Full Time Frames(Without PVC)')
xlabel('Minutes')
ylabel('SUV Dyn')
legend('Carotid1', 'Carotid2', 'Both')
end
