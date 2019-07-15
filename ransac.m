%% Develepor's Information:
                       %% AUTHOR: ZOHAIB ALI %%
    %% Project Title: Adversarial Examples for Handcrafted Features %%
      %%% School of Electrical Engineering & Computer Sciences %%%
    %%% National University of Sciences & Technology, Islamabad %%%
             %%% Email: zali.msee16seecs@seecs.edu.pk %%%
        %%% Website: http://romi.seecs.nust.edu.pk/index.html %%%
                        %%% July 2019 %%%
%% Code: Built-in RANSAC with required changes:
 clc;
 clear
 close all
 
 %%% Reading Images for Matching
im1 = rgb2gray(imread('1.png'));
im3 = rgb2gray(imread('2.png'));
im2= imresize(im3, size(im1));

% detect surf features
points1 = detectSURFFeatures(im1);   
points2 = detectSURFFeatures(im2);
disp(points1)
disp(points2)
figure;
imshow(im1);
title('100 Strongest Feature Points from Image1');
hold on;
plot(selectStrongest(points1, 100));

figure;
imshow(im2);
title('100 Strongest Feature Points from Image2');
hold on;
plot(selectStrongest(points2, 100));

% extract features

[f1, points1] = extractFeatures(im1, points1); 
[f2, points2] = extractFeatures(im2, points2);

% matching features

indexpairs = matchFeatures(f1, f2, 'Method', 'Approximate', 'Unique', true) ;   

m1 = points1(indexpairs(:, 1), :);
m2 = points2(indexpairs(:, 2), :);
disp(m1)
disp(m2)
% show matched features including outliers

figure;
showMatchedFeatures(im1,im2,m1,m2,'montage','PlotOptions',{'ro','go','y--'});
title('Putative point matches');

% exclude outliers by using a robust estimation technique such as random-sample consensus (RANSAC)

[fRANSAC, inliers] = estimateFundamentalMatrix(m1,...
    m2,'Method','RANSAC',...
    'NumTrials',2000,'DistanceThreshold',1e-2);

%[fRANSAC, inliers] = estimateFundamentalMatrix(m1,m2,'NumTrials',2000);
disp(m1(inliers,:))
disp(m2(inliers,:))

% inliers only

figure;
showMatchedFeatures(im1, im2, m1(inliers,:),m2(inliers,:),'montage','PlotOptions',{'ro','go','y--'});
title('Point matches after outliers were removed');