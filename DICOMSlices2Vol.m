
function [mr, ini_dim] = DICOMSlices2Vol(file_path)
% read dicom MRI images in to 3D matrix, each fram stored
% in one layer of the matrix
% new version
% Input:
% file_path         path of the file to be read
% Output:
% mr                output image
% ini_dim           the size of the output image
%
%
% Dakai Zhou

% list folder contents
dicomlist = dir(fullfile(file_path, '*.IMA'));

% initialize the 3-D matrix for the 3-D image
img = dicomread(fullfile(file_path, dicomlist(1).name));
[x, y] = size(img);
img = zeros(x, y, numel(dicomlist));

% read the image and store the matrix into the 3-D matrix
for i = 1 : numel(dicomlist)
    info  = dicominfo(fullfile(file_path, dicomlist(i).name));
    img(:, :, info.InstanceNumber) = dicomread(fullfile(file_path, dicomlist(i).name));
end

mr.img = img;
mr.info.VoxelSize = [info.PixelSpacing; info.SliceThickness]; % unit mm
mr.info.ImageOrientationPatient = info.ImageOrientationPatient;
mr.info.ImagePositionPatient = info.ImagePositionPatient;

ini_dim = size(img);

clear dicomlist info x y img

%ini_dim = size(immat_3D);
%immat_3D = immat_3D(20:170,50:246,20:180);
%immat_3D = immat_3D(20:256,50:246,20:180); % LK1
%immat_3D = immat_3D(101:256,71:150,31:150);
%immat_3D = immat_3D(:,91:160,31:150); %PAT2_2
end