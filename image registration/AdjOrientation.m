function [adjpet, adjmr] = AdjOrientation(pet, mr)
% Adjust the PET image and MR image into the same orientation
% Input:
% pet, mr          structs contain PET/MR image and header
% Output:
% adjpet, adjmr    PET image amnd MR image in the same orientation
%
%
% Dakai Zhou

adjmr = MROTAdj(mr);
adjpet = PETOTAdj(pet);
adjmr = RigidTransTriLinear(adjmr, [0;0;0;0;90;0]);




function adjmr = MROTAdj(MR)
% Function to adjust MR image to default orientation

row_vector = MR.info.ImageOrientationPatient(1:3);
col_vector = MR.info.ImageOrientationPatient(4:6);

if row_vector(2) == 1 && col_vector(3) == -1
    adjmr = MR.img;
    disp('DICOM Orientation: done')
else
    error('More cases should be added in the code')
end
    


function adjpet = PETOTAdj(pet)
% Function to adjust PET image to default orientaion

% Add all the dynamic pet images together 
spet = AddPET(pet.img,23);

% method 1
if pet.original.hdr.hist.qform_code == 0
    pixdim = pet.original.hdr.dime.pixdim(2:4);
    if sum(pixdim < 0) ~= 0
        idx = find(pixdim);
        adjpet = spet;
        for i = 1:numel(idx)
            adjpet = filp(adjpet, idx(i));
        end
        disp('NIfTI Orientation: Method 1, flipped, done.')
    else
        disp('NIfTI Orientation: Method 1, did not change.')
        adjpet = spet;
    end
end

% method 2
if pet.original.hdr.hist.qform_code > 0
    b = pet.original.hdr.hist.quatern_b;
    c = pet.original.hdr.hist.quatern_c;
    d = pet.original.hdr.hist.quatern_d;
    a = sqrt(1-b*b-c*c-d*d);
    % Rotation matrix
    R = [a*a+b*b-c*c-d*d, 2*b*c-2*a*d, 2*b*d+2*a*c;
        2*b*c+2*a*d, a*a+c*c-b*b-d*d, 2*c*d-2*a*b;
        2*b*d-2*a*c, 2*c*d+2*a*b, a*a+d*d-c*c-d*d;];
   adjpet = RotationTriLinear(spet, R);
   disp('NIfTI Orientation: Method 2, done.')
end

% method 3
if pet.original.hdr.hist.sform_code > 0
    % Rotation matrix
    R = [pet.original.hdr.hist.srow_x(1:3);
        pet.original.hdr.hist.srow_y(1:3);
        pet.original.hdr.hist.srow_z(1:3)];
    R = R./diag(pet.original.hdr.dime.pixdim(2:4));
    adjpet = RotationTriLinear(spet, R);
    disp('NIfTI Orientation: Method 3, done.')
end

function out = AddPET(pet, i)

out = zeros(size(pet(:,:,:,1)));
for n = 1:i
    out = out+pet(:,:,:,n);
end
