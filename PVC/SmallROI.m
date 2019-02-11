function [nimg, x, y, z] = SmallROI(ROI)
% Reduce the size of ROI 

[xroi,yroi,zroi] = size(ROI);
minr = xroi;
minc = yroi;
minl = zroi;
maxr = 0;
maxc = 0;
maxl = 0;
for l = 1:zroi
    [r,c] = find(ROI(:,:,l));
    if numel(r) > 0
        if l > maxl, maxl = l; end 
        if l < minl, minl = l; end
        if min(r) < minr, minr = min(r); end
        if max(r) > maxr, maxr = max(r); end
    end
    
    if numel(c) > 0
        if l > maxl, maxl = l; end 
        if l < minl, minl = l; end
        if min(c) < minc, minc = min(c); end
        if max(c) > maxc, maxc = max(c); end
    end
end

x = [minr-10, maxr+10];
x(x<1) = 1;
x(x>xroi) = xroi;
y = [minc-10, maxc+10];
y(y<1) = 1;
y(y>yroi) = yroi;
z = [minl-10, maxl+10];
z(z<1) = 1;
z(z>zroi) = zroi;
nimg = ROI(x(1):x(2), y(1):y(2), z(1):z(2));

end