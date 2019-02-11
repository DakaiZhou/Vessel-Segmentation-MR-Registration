function [mip] = MIP_plot(immat_3D_out)
% Maximum intensity projection of a volume from three directions
% Input:
% immat_3D_out          input image
% Output:
% mip                   maximum intensity projection
%
%
% Dakai Zhou

iptsetpref('ImshowBorder','tight');
View = input('View for maximun intensity projection: axial(A), sagittal(S) coronal(C) or exit(E)?');

if strcmp(View, 'A')
    mpiyz = max(immat_3D_out, [], 1);
    mip(:,:) = mpiyz(1,:,:);
    mip = mip';
    mip = flip(mip,1);
    figure
    imshow(mip, []);
    
else
    if strcmp(View, 'C')
        mpixz = max(immat_3D_out, [], 2);
        mip(:,:) = mpixz(:,1,:);
        mip = flip(mip,2);
        figure
        imshow(mip, []);
        
    else
        mpixy = max(immat_3D_out, [], 3);
        mip = mpixy;
        figure
        imshow(mip, []);
    end
end
clear mpixy
end