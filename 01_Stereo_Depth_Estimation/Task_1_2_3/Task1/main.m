

clear all
clc

%% Execution of an High-Ranking Algorithm - Belief Propagation

% read reference image as left adn right image
leftI = imread('C:\Users\ASUS\Desktop\am20s052\task2n3\Input\Art\view1.ppm');
rightI = imread('C:\Users\ASUS\Desktop\am20s052\task2n3\Input\Art\view5.ppm');

% define parameter for block matching and call block matching algorithm
%blockSize=3;
%maxd=200;
%disp1=blockmatching(leftI,rightI,blockSize,maxd);
%figure;imagesc(disp1);
%title('blockmatching result');

% define parameters and call block matchning with dynamic prog optm.
%maxd=200;
%blockSize=3;
%cost=100;
%disp2=blockmatching_DW(leftI,rightI,blockSize,maxd,cost);
%figure;imagesc(disp2);
%title('blockmatching with Dynamic Prog. Opt. result');

%define parameter and call belief Propogation based Stereo
levels=10;
maxd=87;
iter=10;
disp3=beliefPropStereo(leftI,rightI,maxd,levels,iter);
figure;imagesc(disp3);
title('belief Propogation based Stereo Result');

% read ground truth disparity image
dispG=imread('C:\Users\ASUS\Desktop\am20s052\A1\Art-2views\Art\disp1.png');
figure;imagesc(dispG);
%title('Ground Truth Image');



% error calculation
% [a b]=size(dispG);
% d1=disp1(20:a-20,20-15:b-20-15);
% d2=disp2(20:a-20,20-15:b-20-15);
% d3=disp3(20:a-20,20:b-20);
% dG=double(dispG(20:a-20,20:b-20));
% 
% c1=corr(dG(:),d1(:));
% c2=corr(dG(:),d2(:));
% c3=corr(dG(:),d3(:));
% 
% 
% fprintf('Correlation coef for belief prop.:%f\n',c3);




