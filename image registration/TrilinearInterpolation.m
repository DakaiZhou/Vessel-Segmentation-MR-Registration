
function [out] = TrilinearInterpolation(img, new_dim)
% Trilinear interpolation for image scaling
% Input:
% img             input image
% new_dim         size of the transformed image
% Output:
% out             scaled image
%
%
% Dakai Zhou

out = zeros(new_dim);
old_dim = size(img);
if numel(old_dim) == 2
    old_dim(3) = 1;
end
Sx = old_dim(1) / new_dim(1);
Sy = old_dim(2) / new_dim(2);
Sz = old_dim(3) / new_dim(3);

% loop over the pixels of the putput image, x1 y1 and z1 are the pixel
% indices in the original image. They are calculated speratedly due to the
% efficiency
for k = 1 : new_dim(3)
    zf = Sz * k;
    z1 = floor(zf);    
    % pixels out of the original image, set them to the nearst pixels
    % which is the lowest boundary
    if z1 == 0
        z1 = 1;
    end
    % pixels do not higher have neighbors(on highest boundary), set
    % them to the second highest layer
    if z1 == old_dim(3)
        z1 = old_dim(3) - 1;
    end
    
    delta_z = zf - z1;
    for j = 1 : new_dim(2)
        yf = Sy * j;
        y1 = floor(yf);
        delta_y = yf - y1;        
        % boundary
        if y1 == 0
            y1 = 1;
        end
        if y1 == old_dim(2)
            y1 = old_dim(2) - 1;
        end
        
        for i = 1 : new_dim(1)
            xf = Sx * i;
            x1 = floor(xf);
            delta_x = xf - x1;            
            % boundary
            if x1 == 0
                x1 = 1;
            end
            if x1 == old_dim(1)
                x1 = old_dim(1)-1;
            end
            
            if old_dim(3) ~=1
                
                x2 = x1+1;
                y2 = y1+1;
                z2 = z1+1;
                
                % 3D volume
                out(i,j,k) = img(x1,y1,z1)*(1-delta_x)*(1-delta_y)*(1-delta_z)...
                    + img(x2,y1,z1)*delta_x*(1-delta_y)*(1-delta_z)...
                    + img(x1,y2,z1)*(1-delta_x)*delta_y*(1-delta_z)...
                    + img(x1,y1,z2)*(1-delta_x)*(1-delta_y)*delta_z...
                    + img(x2,y2,z1)*delta_x*delta_y*(1-delta_z)...
                    + img(x2,y1,z2)*delta_x*(1-delta_y)*delta_z...
                    + img(x1,y2,z2)*(1-delta_x)*delta_y*delta_z...
                    + img(x2,y2,z2)*delta_x*delta_y*delta_z;
            else
                x2 = x1+1;
                y2 = y1+1;
                % 2D image
                out(i,j,k) = img(x1,y1)*(1-delta_x)*(1-delta_y)...
                    + img(x2,y1)*delta_x*(1-delta_y)...
                    + img(x1,y2)*(1-delta_x)*delta_y...
                    + img(x2,y2)*delta_x*delta_y;
            end
        end
    end
end