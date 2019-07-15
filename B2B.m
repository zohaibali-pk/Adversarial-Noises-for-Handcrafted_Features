%% Develepor's Information:
                       %% AUTHOR: ZOHAIB ALI %%
    %% Project Title: Adversarial Examples for Handcrafted Features %%
      %%% School of Electrical Engineering & Computer Sciences %%%
    %%% National University of Sciences & Technology, Islamabad %%%
             %%% Email: zali.msee16seecs@seecs.edu.pk %%%
        %%% Website: http://romi.seecs.nust.edu.pk/index.html %%%
                        %%% July 2019 %%%
%% Noise Type: Block-2-Block (B2B) Perturbation:
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
        I_gray2 = rgb2gray(I);
        s1 = size(I_gray);
        height = size(I_gray,1);
        width = size(I_gray,2);
        interestPoints = detectHarrisFeatures(I_gray); % Detection of Required Features
        p_n = round(interestPoints.Location); % Finding location of every features
        p_new = p_n;
        m_sz = 7; % Mask Size
        %%% Removing Boundary Features
        n = floor(m_sz/2);
        [a b] = find(p_new(:,1) <= n+1 | p_new(:,1) >= width-(n+1));
        p_new(a,:) = [];
        [a b] = find(p_new(:,2) <= n+1 | p_new(:,2) >= height-(n+1));
        p_new(a,:) = [];
        p=zeros(s1(1),s1(2));
        for k =1:size(p_new(:,1),1)
            p1 = p_new(k,:);
            %%% Calculating Sum of Each Block
            for z= 1:3
                A = sum(sum(I2(p1(1,2)-1:p1(1,2) , p1(1,1)-1:p1(1,1),z)));
                B = sum(sum(I2(p1(1,2)-1:p1(1,2) , p1(1,1):p1(1,1)+1,z)));
                C = sum(sum(I2(p1(1,2):p1(1,2)+1 , p1(1,1)-1:p1(1,1),z)));
                D = sum(sum(I2(p1(1,2):p1(1,2)+1 , p1(1,1):p1(1,1)+1,z)));
                E = abs([A B C D]);
                Emax = max(E);
                th = 50; % Setting Threshold
                %%% B2B LOOP - Section 4.3.3 
                for kk = 1:4
                    if Emax-E(kk) > th
                        i = p1(2)- abs(ceil(kk/2)-2);
                        j = p1(1)-rem(kk,2);
                        I2(i,j,z) = (sum(sum(I2(i-1:i,j-1:j,z)))-I2(i,j,z))/3;
                        I2(i,j+1,z) = (sum(sum(I2(i-1:i,j+1:j+2,z)))-I2(i,j+1,z))/3;
                        I2(i+1,j,z) = (sum(sum(I2(i+1:i+2,j-1:j,z)))-I2(i+1,j,z))/3;
                        I2(i+1,j+1,z) = (sum(sum(I2(i+1:i+2,j+1:j+2,z)))-I2(i+1,j+1,z))/3;
                    end
                end
            end
        end
        I_noisy =I2;
        img_name_2 = fullfile(myFolder, 'Noisy_B2B.png') 
        imwrite(I_noisy,img_name_2, 'png') % Saving Noisy Image
    end
end