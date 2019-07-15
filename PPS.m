%% Develepor's Information:
                       %% AUTHOR: ZOHAIB ALI %%
    %% Project Title: Adversarial Examples for Handcrafted Features %%
      %%% School of Electrical Engineering & Computer Sciences %%%
    %%% National University of Sciences & Technology, Islamabad %%%
             %%% Email: zali.msee16seecs@seecs.edu.pk %%%
        %%% Website: http://romi.seecs.nust.edu.pk/index.html %%%
                        %%% July 2019 %%%
%% Noise Type: Pixel-2-Pixel-Scattered (PPS) Perturbation:
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
        ip1 = detectHarrisFeatures(I_gray); % Detection of Required Features
        p_n = round(ip1.Location); % Finding location of every features
        p_new = p_n;
        k =  3; % Mask Size
        %%% Removing Boundary Features
        n = floor(k/2);
        [a b] = find(p_new(:,1) <= n+2 | p_new(:,1) >= width-(n+1));
        p_new(a,:) = [];
        [a b] = find(p_new(:,2) <= n+2 | p_new(:,2) >= height-(n+1));
        p_new(a,:) = [];
        %%% PPS LOOP - Section 4.3.2
        for kk =1:size(p_new(:,1),1)
            p1 = p_new(kk,:);
            p =[p1(2),p1(1)];
            for i = 1:k
                for j=-rem(i,2)+2:2:(k-1)+rem(i,2)
                    for z=1:3
                        avg = round(sum(sum(double(I2(p(1)-3+i-1:p(1)-3+i+1, p(2)-3+j-1:p(2)-3+j+1,z))))/((3)^2));
                        I2(p(1)-n-1+i,p(2)-n-1+j,z) = avg;
                    end
                end
            end
        end
        I_noisy =I2;
        img_name_2 = fullfile(myFolder, 'Noisy_PPS.png') 
        imwrite(I_noisy,img_name_2, 'png') % Saving Noisy Image
    end
end