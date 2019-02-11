function [p0, p,f, img, vf] = ImReg(R, F, tol)
% Image registration via Powell;s method
% Input:
% R    reference image
% F    floating image
% tol  tolerance of each transformaiton parameter, six elements vector.
%      First three for tanslations, the other three for rotations.
%      Recommand (0,0,0,0.01,0.01,0.01)
% Output:
% p0   initial guess
% p    final transformation parameters
% f    final mutual information
% img  registered image
% vf   vector of mutual information in each iteration
%
%
% Dakai Zhou

% Read voxel size
Rvoxel = abs(R.original.hdr.dime.pixdim(2:4));
Fvoxel = F.info.VoxelSize;

% Adjust images to the same orientation
[R, F] = AdjOrientation(R, F);

% Size of transformed image 
new_size = round(size(F)./(Rvoxel./Fvoxel'));
% Scaling float image to have same voxel size as reference
F = TrilinearInterpolation(F, new_size);


% convert images to bitdepth 2^8
if max(R(:)) > 255
    mxr = max(R(:));
    mnr = min(R(:));
    u8R = round(255*(R-mnr)./(mxr-mnr+eps));
else
    u8R = R;
end

if max(F(:)) > 255
    mxf = max(F(:));
    mnf = min(F(:));
    u8F = round(255*(F-mnf)./(mxf-mnf+eps));
else
    u8F = F;
end

% The initial most previous rotated image
prot_img = u8F;

% Initial guess
[p] = InitialGuess2(u8R, u8F);
p0 = p;

% Searching direction matrix
dir = diag(ones(1,6)); 

% Registration via Powell method
[p,~, vf] = Powell(u8R, u8F, prot_img, p, dir, tol);

% Transform the original floating image to get the registered image
p1 = zeros(6,1);
p1(4:6) = p(4:6);
[~, rot_img] = RigidTransTriLinear(F, p1);
sz = size(R);
img = ChopImg2(rot_img, sz, p(1:3));
f = MutualInfo(R,img);
end