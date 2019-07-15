%% Develepor's Information:
                       %% AUTHOR: ZOHAIB ALI %%
    %% Project Title: Adversarial Examples for Handcrafted Features %%
      %%% School of Electrical Engineering & Computer Sciences %%%
    %%% National University of Sciences & Technology, Islamabad %%%
             %%% Email: zali.msee16seecs@seecs.edu.pk %%%
        %%% Website: http://romi.seecs.nust.edu.pk/index.html %%%
                        %%% July 2019 %%%
%% Noise Type: Pixel-2-Pixel (P2P) Perturbation - Scale Specific:
clc 
clear
close all
mymainFolder = 'C:\path for images folder';
allfilesinmain = dir(mymainFolder)
size_allfilesinmain = size(allfilesinmain)
for pp =3:size_allfilesinmain(1)
    myFolder = fullfile(mymainFolder, allfilesinmain(pp).name)
    subfolderfiles = dir(myFolder)
    imgs = fullfile(myFolder, '*.ppm')
    allfiles = dir(imgs);
    size_allfiles = size(allfiles);
    for qq = 1:1
        imgfile1 = fullfile(myFolder, allfiles(1).name);
        I = imread(imgfile1);I2 = imread(imgfile1); % Reading Image
        I_gray = rgb2gray(I); % Converting To gray scale for Feature detection
        s1 = size(I_gray);
        height = size(I_gray,1);
        width = size(I_gray,2);
        interestPoints =	detectSURFFeatures(I_gray); % Detection of Required Features
        p_n = round(interestPoints.Location); % Finding location of every features
        scale = interestPoints.Scale; % Finding scale of every features
        AA = [p_n scale];
        p_new1 = [];
        %%% Loop to asign specific Mask for specific Scale
        for i=1:size(AA,1)
            if AA(i,3)<=5
                p_new1(i,1:2) = AA(i,(1:2));
            elseif AA(i,3)>5 && AA(i,3)<=10
                p_new1(i,3:4) = AA(i,(1:2));
            else
                p_new1(i,5:6) = AA(i,(1:2));
            end
        end
        matrix_size = [5 7 9]; % Different Mask Sizes
        no_p = size(p_new1,2)/2;
        p=zeros(s1(1),s1(2));
        %%% Loop to remove Boundary Features
        for mats = 1:no_p
            p_new = p_new1(:,(mats*2-1):mats*2);
            p_new( ~any(p_new,2), : ) = [];
            n = floor(matrix_size(mats)/2);
            [a b] = find(p_new(:,1) <= n | p_new(:,1) >= width-(n+1));
            p_new(a,:) = [];
            [a b] = find(p_new(:,2) <= n | p_new(:,2) >= height-(n+1));
            p_new(a,:) = [];
            p=uint8(zeros(s1(1),s1(2),3));
            
            %%% P2P LOOP - Section 4.3.1
            for k =1:size(p_new(:,1),1)
                p1 = p_new(k,:);
                for i = 1:m_sz
                    for j = 1:m_sz
                        for z =1:3
                            A = double((I2(p1(2)+i-n-1, p1(1)+j-n-2,z)));  B = double((I2(p1(2)+i-n-2, p1(1)+j-n-1,z)));
                            avg = (A+B)/2;
                            I2(p1(2)+i-n-1, p1(1)+j-n-1,z) = avg;
                        end
                    end
                end
            end
        end
        noisy = I2; % Reading Noisy Image
        img_name_2 = fullfile(myFolder, 'Noisy_SS_P2P.png') 
        imwrite(noisy,img_name_2, 'png') % Saving Noisy Image
    end
end