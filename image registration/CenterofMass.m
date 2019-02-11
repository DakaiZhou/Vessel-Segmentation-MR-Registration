function [x,y,z] = CenterofMass(I)
% Compute the center of mass of the image based on the image intensity
% Input: 
% I          image
% Output:
% x,y,z      indices of the center of mass
%
%
% Dakai Zhou

[x,y,z] = size(I);
xw = 0;
zw = 0;
yw = 0;
w = sum(I(:));
for k = 1:z
    for j = 1:y
        for i = 1:x
            xw = xw + i*I(i,j,k);
            yw = yw + j*I(i,j,k);
            zw = zw + k*I(i,j,k);
        end
    end
end
x = round(xw/w);
y = round(yw/w);
z = round(zw/w);
end