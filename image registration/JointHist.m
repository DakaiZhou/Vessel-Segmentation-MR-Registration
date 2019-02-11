function [jh, n] = JointHist(A, B)
% function for a joint histogram of two images
% Input:
% A, B          images with same dimensions
% bin           bins for joint histogram
% Output:
% jh            joint histogram
% n             number of pixels
%
%
% Dakai Zhou

A = round(A(:));
B = round(B(:));
numrow = max(A) + 1;
numcol = max(B) + 1;
jh = zeros(numrow, numcol);

n = numel(A);
for i = 1:n
    jh(A(i)+1, B(i)+1) = jh(A(i)+1, B(i)+1) + 1;
end
end