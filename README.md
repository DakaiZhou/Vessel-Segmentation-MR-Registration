# Automatic-Segmentation-of-Blood-Vessels-in-MR-Brain-Images
This project aims to automatically segment carotid from 3D MR brain image, and use the segmented carotid to extract Time-Activity-Curve from PET images. It mainly involves 3D image coregistration, vessel segmentation, partial valume correction.

The vessel segmentation algorithm based on the algorithm proposed by Frangi et al. in 'Multiscale vessel enhancement filtering'. Image coregistration algoritm applied Powell's algorithm, Brent's method and mutual information. Partial volume correction applied Geometric Transfer Matrix(GTM) method.

This project produced better results than PMOD did, in terms of the quality of vessel segmentation and the accuracy of image co-registration.

## How to use?
Read the images first. DICOM file use DICOMSlices2Vol.m, NIfTI file use load_nii().

ImgCoreg.m requires input image structures read by DICOMSlices2Vol.m and load_nii() function. The recommanded tol is (0,0,0,0.01,0.01,0.01). The first three are tanslation tolarences, they can be exactly 0. The last three are rotation tolarences, they can be 0 for register identical image. But for multimodaliy image, they are recommanded to be 0.01(degree). The registration accuracy can be adjusted by rotation tolarences.

The input vol for CarotidSegmentation.m is image data, not a structure. Mode depends on the image to be processed. For mode 0, it requires the most memory and running time.

The carotid 3D visualization uses MATLAB build in app volumeViewer(). Old version MATLAB may do not have it. Then, this visualization app can be deactivated in CarotidSegmentation.m line 42. Functions in folder 'visualization plan B' can be used to have some basic views of a 3D volume.

Examples:

[Carotid1, Carotid2, CarodidBoth] = CarotidSegmentation(FE390M_MR.img, 0.5, 0.5, 0.1, 0.5:0.5:2, 2);

[p0, p, f, img, vf,v1,v1,vb]= ImgReg_VesSeg_TAC_PVC(FE390M_filter, FE390M_MR, [0,0,0,0.01,0.01,0.01], 0.5,0.5,0.1,0.5:0.5:1.5,1,16,[3,3,3]);

[p0, p,f, img, vf] = ImgCoreg(FE390M_filter, FE390M_MR, [0,0,0,0.01,0.01,0.01]);

## Some Results:
The three images below are the projections of original MR iamge, vessels segmentated from original MR image and vessels segmented from co-registered MR image.
![screenshot from 2019-02-11 19-19-26](https://user-images.githubusercontent.com/47189577/52584473-718fc200-2e32-11e9-8263-32146f020a3b.png)
![screenshot from 2019-02-11 19-19-58](https://user-images.githubusercontent.com/47189577/52584798-56718200-2e33-11e9-8285-4657cd82e587.png)
![screenshot from 2019-02-11 19-20-17](https://user-images.githubusercontent.com/47189577/52584850-77d26e00-2e33-11e9-8c06-c529813730a2.png)

The images below is the Time-Activity-Curve(full time and first 8 minutes) of without and with partial volume correction
![screenshot from 2019-02-11 19-20-41](https://user-images.githubusercontent.com/47189577/52584994-ea434e00-2e33-11e9-950c-60dc88c199f2.png)
![screenshot from 2019-02-11 19-20-57](https://user-images.githubusercontent.com/47189577/52585044-0cd56700-2e34-11e9-936d-0885e8244851.png)
![screenshot from 2019-02-11 19-21-16](https://user-images.githubusercontent.com/47189577/52585068-18289280-2e34-11e9-89eb-b66aa7dc1f5a.png)
![screenshot from 2019-02-11 19-21-40](https://user-images.githubusercontent.com/47189577/52585072-1a8aec80-2e34-11e9-9970-0143d0ad7144.png)
