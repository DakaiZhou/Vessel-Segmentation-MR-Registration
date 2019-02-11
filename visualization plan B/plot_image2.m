function plot_image2(immat_3D, immat_3D_out)
% look into two images slice by slice
% Input:
% immat_3D, immat_3D_out         input images
%
%
% Dakai Zhou

[x,y,z] = size(immat_3D);

while 1
    View = input('View: axial(A), sagittal(S) coronal(C) or exit(E)?');
    if strcmp(View, 'S')
        for i = 1 : z
            
            subplot(1,2,1)
            I = immat_3D(:, :, i);
            %high = max(max(I));
            imshow(I, []);
            title({'View: original sagittal', ['Image NO.', num2str(i)]});
            
            subplot(1,2,2)
            I = immat_3D_out(:, :, i);
            %high = max(max(I));
            imshow(I, []);
            title({'View: processed sagittal', ['Image NO.', num2str(i)]});
            
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
                
                subplot(1,2,1)
                I = permute(immat_3D(i, :, :), [3,2,1]);
                %high = max(max(I));
                imshow(I, []);
                title({'View: original axial', ['Image NO.', num2str(i)]});
                
                subplot(1,2,2)
                I = permute(immat_3D_out(i, :, :), [3,2,1]);
                %high = max(max(I));
                imshow(I, []);
                title({'View: original axial', ['Image NO.', num2str(i)]});
                
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
                    
                    subplot(1,2,1)
                    I = permute(immat_3D(:, i, :), [1,3,2]);
                    %high = max(max(I));
                    imshow(I, []);
                    title({'View: original coronal', ['Image NO.', num2str(i)]});
                    
                    subplot(1,2,2)
                    I = permute(immat_3D_out(:, i, :), [1,3,2]);
                    %high = max(max(I));
                    imshow(I, []);
                    title({'View: original coronal', ['Image NO.', num2str(i)]});
                    
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