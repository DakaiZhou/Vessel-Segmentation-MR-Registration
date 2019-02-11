function [tr_img, rot_img] = RigidTransTriLinear(img, p)
% new version
% rigid transformation only consider translation and rotation. The two
% transformations are processed seperately, which leads to faster speed(
% when translation needs to be performed) compared to vesion 1, but has 
% the same result as version 1. The speed advantage is more obvious when
% more translations are performed.
% Input:
% img        input image
% p          six-element array, first three are translation along x,y,z;
%            last three are rotation degree along x,y,z
% Output:
% out        transformed image
% rot_img    rotated image
%
%
% Dakai Zhou

[x,y,z] = size(img);
p = p(:);

% image rotation
if sum(p(4:6) == 0) ~= 3
    % center of the original image
    if x/2-floor(x/2) == 0, Xcenter = x/2+0.5; else, Xcenter = x/2; end
    if y/2-floor(y/2) == 0, Ycenter = y/2+0.5; else, Ycenter = y/2; end
    if z/2-floor(z/2) == 0, Zcenter = z/2+0.5; else, Zcenter = z/2; end
    
    % add one more layer(copy the boundary to the new boundary) to each
    % dimension for boundary condition
    tmp = zeros(x+1,y+1,z+1);
    tmp(1:x,1:y,1:z) = img;
    tmp(x+1,1:y,1:z) = img(x,:,:);
    tmp(1:x,y+1,1:z) = img(:,y,:);
    tmp(1:x,1:y,z+1) = img(:,:,z);
    img = tmp;
    
    % convert degree to radians
    p(4:6) = p(4:6)/180*pi;
    % rotation matrix
    % mine
    R = [cos(p(6))*cos(p(5)),...
         sin(p(6))*cos(p(4))-cos(p(6))*sin(p(5))*sin(p(4)), ...
         sin(p(6))*sin(p(4))+cos(p(6))*sin(p(5))*cos(p(4));...
         -sin(p(6))*cos(p(5)),...
         cos(p(6))*cos(p(4)+sin(p(6))*sin(p(5))*sin(p(4))),...
         cos(p(6))*sin(p(4))-sin(p(6))*sin(p(5))*cos(p(4));...
         -sin(p(5)), -cos(p(5))*sin(p(4)), cos(p(5))*cos(p(4))];
    
    % size of the image after rotation
    nx = round([x,y,z]*abs(R(1,:)'));
    ny = round([x,y,z]*abs(R(2,:)'));
    nz = round([x,y,z]*abs(R(3,:)'));
    rot_img = zeros(nx,ny,nz);
    
    % center of image after rotation
    if nx/2-floor(nx/2) == 0, tXcenter = nx/2+0.5; else, tXcenter = nx/2; end
    if ny/2-floor(ny/2) == 0, tYcenter = ny/2+0.5; else, tYcenter = ny/2; end
    if nz/2-floor(nz/2) == 0, tZcenter = nz/2+0.5; else, tZcenter = nz/2; end
    
    %inverse rotation matrix
    invR = R';
    
    % loop over each pixel in the rotated image, to check wether it is in the
    % original after apply inverse rotation
    for k = 1 : nz
        % Cartesian indix
        C_z = k - tZcenter;
        % seprate inverse rotation matrix-vector production to reduce
        % calculations. Z potion of the indices x,y,z after rotation. 
        % Use three multiplications instead of scaler vector multiplication 
        % to speed up the code. This reason also applies to the following
        % additions and multiplications
        % zp = C_z*invR(:,3);  % slower
        zpx = C_z*invR(1,3);
        zpy = C_z*invR(2,3);
        zpz = C_z*invR(3,3);
        for j = 1 : ny
            C_y = j - tYcenter;
            ypx = C_y*invR(1,2);
            ypy = C_y*invR(2,2);
            ypz = C_y*invR(3,2);
            % add them one step ahead to reduce calculations
            yzpx = ypx+zpx;
            yzpy = ypy+zpy;
            yzpz = ypz+zpz;
            for i = 1 : nx
                C_x = i - tXcenter;
                xpx = C_x*invR(1,1);
                xpy = C_x*invR(2,1);
                xpz = C_x*invR(3,1);
                % Cartesian indices of the pixel after it's inverse
                % rotation
                frac_x = xpx+yzpx;
                frac_y = xpy+yzpy;
                frac_z = xpz+yzpz;
                frac_x_ori = frac_x + Xcenter;
                frac_y_ori = frac_y + Ycenter;
                frac_z_ori = frac_z + Zcenter;
                int_x_ori = floor(frac_x_ori);
                int_y_ori = floor(frac_y_ori);
                int_z_ori = floor(frac_z_ori);
                if (int_x_ori>0 && int_x_ori<=x &&...
                        int_y_ori>0 && int_y_ori<=y &&...
                        int_z_ori>0 && int_z_ori<=z)
                    
                    delta_x = frac_x_ori - int_x_ori;
                    delta_y = frac_y_ori - int_y_ori;
                    delta_z = frac_z_ori - int_z_ori;
                    
                    int_x1_ori = int_x_ori+1;
                    int_y1_ori = int_y_ori+1;
                    int_z1_ori = int_z_ori+1;
                    
                    rot_img(i,j,k) = ...
                        img(int_x_ori,int_y_ori,int_z_ori)*(1-delta_x)*(1-delta_y)*(1-delta_z)...
                        + img(int_x1_ori,int_y_ori,int_z_ori)*delta_x*(1-delta_y)*(1-delta_z)...
                        + img(int_x_ori,int_y1_ori,int_z_ori)*(1-delta_x)*delta_y*(1-delta_z)...
                        + img(int_x_ori,int_y_ori,int_z1_ori)*(1-delta_x)*(1-delta_y)*delta_z...
                        + img(int_x1_ori,int_y1_ori,int_z_ori)*delta_x*delta_y*(1-delta_z)...
                        + img(int_x1_ori,int_y_ori,int_z1_ori)*delta_x*(1-delta_y)*delta_z...
                        + img(int_x_ori,int_y1_ori,int_z1_ori)*(1-delta_x)*delta_y*delta_z...
                        + img(int_x1_ori,int_y1_ori,int_z1_ori)*delta_x*delta_y*delta_z;
                end
            end
        end
    end
else
    nx = x;
    ny = y;
    nz = z;
    rot_img = img;
end

% image translation
if sum(p(1:3) == 0) ~= 3
    tr_img = zeros(nx+abs(p(1)), ny+abs(p(2)), nz+abs(p(3)));
    if p(1) > 0, x1 = 1+p(1); x2 = nx+p(1); else, x1 = 1; x2 = nx; end
    if p(2) > 0, y1 = 1+p(2); y2 = ny+p(2); else, y1 = 1; y2 = ny; end
    if p(3) > 0, z1 = 1+p(3); z2 = nz+p(3); else, z1 = 1; z2 = nz; end
    tr_img(x1:x2,y1:y2,z1:z2) = rot_img;
else
    tr_img = rot_img;
end
end