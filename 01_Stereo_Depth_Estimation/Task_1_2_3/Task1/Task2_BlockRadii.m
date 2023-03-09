clc
clear all
close all
warning off;
%% Task 1 - BadPixelCount using SAD

x=imread('C:\Users\ASUS\Desktop\ee6130\Comparison-of-Disparity-Estimation-Algorithms-master\Output\GroundTruth_png\Art.png');
y3=imread('C:\Users\ASUS\Desktop\ee6130\Comparison-of-Disparity-Estimation-Algorithms-master\Output\SAD\halfBlockSize3\Art.png');
y5=imread('C:\Users\ASUS\Desktop\ee6130\Comparison-of-Disparity-Estimation-Algorithms-master\Output\SAD\halfBlockSize5\Art.png');
y7=imread('C:\Users\ASUS\Desktop\ee6130\Comparison-of-Disparity-Estimation-Algorithms-master\Output\SAD\halfBlockSize7\Art.png');
y9=imread('C:\Users\ASUS\Desktop\ee6130\Comparison-of-Disparity-Estimation-Algorithms-master\Output\SAD\halfBlockSize9\Art.png');
%xG = rgb2gray(x);
y3G = rgb2gray(y3);
y5G = rgb2gray(y5);
y7G = rgb2gray(y7);
y9G = rgb2gray(y9);







g=size(y3G);
%g=size(y);

x=imresize(x,[g(1),g(2)]);
z3=imabsdiff(x,y3G);
z5=imabsdiff(x,y3G);
z7=imabsdiff(x,y3G);
z9=imabsdiff(x,y3G);
%z=imabsdiff(x,y);

figure;
imshow(x);
title('First image');
figure;
imshow(y3G);
%imshow(y);
title('Second image');
figure;
imshow(z3);

figure;
imshow(z5);

figure;
imshow(z7);

figure;
imshow(z9);
%title('Difference of two images');
%numofBlackPixels = sum(sum(z==0));
%N= nnz(z);
total = g(1,1)*g(1,2);

N3= z3 > 100;
N3tot= nnz(N3);
count3 = (N3tot/ total)*100;

N5= z5 > 100;
N5tot= nnz(N5);
count5 = (N5tot/ total)*100;

N7= z7 > 100;
N7tot= nnz(N7);
count7 = (N7tot/ total)*100;

N9= z9 > 100;
N9tot= nnz(N9);
count9 = (N9tot/ total)*100;



