function plot_image(immat_3D)
% look into image slice by slice
% Input:
% immat_3D          input image
%
%
% Dakai Zhou

[x,y,z] = size(immat_3D);
iptsetpref('ImshowBorder','loose');

while 1
    View = input('View: axial(A), sagittal(S) coronal(C) or exit(E)?');
    if strcmp(View, 'S')
        for i = 1 : z
            I = immat_3D(:, :, i);
            high = max(max(I));
            imshow(I, [0, high]);
            title(['View: sagittal; Image NO.', num2str(i)]);
            
            % waiting for a key press to show the next image
            w = waitforbuttonpress;
            if w == 0
                disp('Button click')
            else
                disp('Key press')
            end
            
        end
        
    else
        if strcmp(View, 'A')
            for i = 1 : x
                I = permute(immat_3D(i, :, :), [3,2,1]);
                high = max(max(I));
                imshow(I, [0, high]);
                title(['View: axial; Image NO.', num2str(i)]);
                
                % waiting for a key press to show the next image
                w = waitforbuttonpress;
                if w == 0
                    disp('Button click')
                else
                    disp('Key press')
                end
            end
            
        else
            if strcmp(View, 'C')
                for i = 1 : y
                    I = permute(immat_3D(:, i, :), [1,3,2]);
                    high = max(max(I));
                    imshow(I, [0, high]);
                    title(['View: coronal; Image NO.', num2str(i)]);
                    
                    % waiting for a key press to show the next image
                    w = waitforbuttonpress;
                    if w == 0
                        disp('Button click')
                    else
                        disp('Key press')
                    end
                end
            else
                break
                
            end
        end
    end
end
end