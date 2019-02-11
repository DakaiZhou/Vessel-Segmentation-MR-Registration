# Automatic-Segmentation-of-Blood-Vessels-in-MR-Brain-Images
This project aims to automatically segment carotid from MR brain image, and use the segmented carotid to extract Time-Activity-Curve from PET images. It mainly involves 3D image coregistration, vessel segmentation, partial valume correction.

The vessel segmentation algorithm based on the algorithm proposed by Frangi et al. in 'Multiscale vessel enhancement filtering'. Image coregistration algoritm applied Powell's algorithm, Brent's method and mutual information. Partial volume correction applied Geometric Transfer Matrix(GTM) method.

## How to use?
Read the images first. DICOM file use DICOMSlices2Vol.m, NIfTI file use load_nii().

ImgCoreg.m requires input image structures read by DICOMSlices2Vol.m and load_nii() function. The recommanded tol is (0,0,0,0.01,0.01,0.01). The first three are tanslation tolarences, they can be exactly 0. The last three are rotation tolarences, they can be 0 for register identical image. But for multimodaliy image, they are recommanded to be 0.01(degree). The registration accuracy can be adjusted by rotation tolarences.

The input vol for CarotidSegmentation.m is image data, not a structure. Mode depends on the image to be processed. For mode 0, it requires the most memory and running time.

The carotid 3D visualization uses MATLAB build in app volumeViewer(). Old version MATLAB may do not have it. Then, this visualization app can be deactivated in CarotidSegmentation.m line 42. Functions in folder 'visualization plan B' can be used to have some basic views of a 3D volume.

Examples:

[Carotid1, Carotid2, CarodidBoth] = CarotidSegmentation(FE390M_MR.img, 0.5, 0.5, 0.1, 0.5:0.5:2, 2);

[p0, p, f, img, vf,v1,v1,vb]= ImgReg_VesSeg_TAC_PVC(FE390M_filter, FE390M_MR, [0,0,0,0.01,0.01,0.01], 0.5,0.5,0.1,0.5:0.5:1.5,1,16,[3,3,3]);

[p0, p,f, img, vf] = ImgCoreg(FE390M_filter, FE390M_MR, [0,0,0,0.01,0.01,0.01]);

## Some Example Result:
[Patient3_ori_256_240_176.pdf](https://github.com/DakaiZhou/Automatic-Segmentation-of-Blood-Vessels-in-MR-Brain-Images/files/2852413/Patient3_ori_256_240_176.pdf)
