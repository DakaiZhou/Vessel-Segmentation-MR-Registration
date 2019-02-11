function wimg = ChopImg2(rimg, sz, p)
% It is the translation part of rigid transformation. Seperating it form 
% rigid transformatmion in order to only show the correct part of the image
% but not the whole translated image with larger size
%
% Input:
% rimg      rotated image
% sz        size of the window for showing the image
% p         transformation parameters
% Output:
% wimg      the correct part of image
%
%
% Dakai Zhou

[rx,ry,rz] = size(rimg);
wimg = zeros(sz);

% center of the rotated image and the window
if rx/2-floor(rx/2) == 0, xcen_r = rx/2+0.5; else, xcen_r = rx/2; end
if ry/2-floor(ry/2) == 0, ycen_r = ry/2+0.5; else, ycen_r = ry/2; end
if rz/2-floor(rz/2) == 0, zcen_r = rz/2+0.5; else, zcen_r = rz/2; end
if sz(1)/2-floor(sz(1)/2) == 0, xcen_w = sz(1)/2+0.5; else, xcen_w = sz(1)/2; end
if sz(2)/2-floor(sz(2)/2) == 0, ycen_w = sz(2)/2+0.5; else, ycen_w = sz(2)/2; end
if sz(3)/2-floor(sz(3)/2) == 0, zcen_w = sz(3)/2+0.5; else, zcen_w = sz(3)/2; end

% Create two cartisien systems at the center of orginal image and the window.
% The boundaries of each dimension of the window and rotated images
xlim1 = 1-xcen_w; xlim2 = sz(1)-xcen_w;
ylim1 = 1-ycen_w; ylim2 = sz(2)-ycen_w;
zlim1 = 1-zcen_w; zlim2 = sz(3)-zcen_w;
% rotated image
xlim3 = 1-xcen_r; xlim4 = rx-xcen_r;
ylim3 = 1-ycen_r; ylim4 = ry-ycen_r;
zlim3 = 1-zcen_r; zlim4 = rz-zcen_r;

% Apply translation p and q on the boundaries belong to rotated image
xlim3 = xlim3+(p(1));
xlim4 = xlim4+(p(1));
ylim3 = ylim3+(p(2));
ylim4 = ylim4+(p(2));
zlim3 = zlim3+(p(3));
zlim4 = zlim4+(p(3));

% Cartesian boundaries of the rotated image that shows in the window
xb1 = max([xlim3,xlim1]);
xb2 = min([xlim4,xlim2]);
yb1 = max([ylim3,ylim1]);
yb2 = min([ylim4,ylim2]);
zb1 = max([zlim3,zlim1]);
zb2 = min([zlim4,zlim2]);

% Convert the cartisien boundaries to pixel index boundaries
% window
xwb1 = floor(xb1+xcen_w);
xwb2 = floor(xb2+xcen_w);
ywb1 = floor(yb1+ycen_w);
ywb2 = floor(yb2+ycen_w);
zwb1 = floor(zb1+zcen_w);
zwb2 = floor(zb2+zcen_w);
% rotated image
xrb1 = floor(xb1-p(1)+xcen_r);
xrb2 = floor(xb2-p(1)+xcen_r);
yrb1 = floor(yb1-p(2)+ycen_r);
yrb2 = floor(yb2-p(2)+ycen_r);
zrb1 = floor(zb1-p(3)+zcen_r);
zrb2 = floor(zb2-p(3)+zcen_r);

wimg(xwb1:xwb2,ywb1:ywb2,zwb1:zwb2) = rimg(xrb1:xrb2,yrb1:yrb2,zrb1:zrb2);
