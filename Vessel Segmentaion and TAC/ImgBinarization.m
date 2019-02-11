function [immat_3D_thres] = ImgBinarization(immat_3D_out)
% Image binarization
% Input:
% immat_3D_out          input image
% Output:
% immat_3D_thres        binarization
%
%
% Dakai Zhou

%level1 = iterative_thresholding(immat_3D_out)
level1 = OtsuMethod(immat_3D_out);
tmp1 = immat_3D_out;
tmp1(immat_3D_out<=level1) = 0;
tmp1(immat_3D_out>level1) = 1;

%mip_thres = MIP_plot(tmp1);
immat_3D_thres = tmp1;

end