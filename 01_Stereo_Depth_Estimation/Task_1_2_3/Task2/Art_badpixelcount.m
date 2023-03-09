clc
clear all
close all
warning off;
%% Task 1 - BadPixelCount using SAD

clc
clear all
close all
warning off;
%% Task 1 - BadPixelCount using SAD

x=imread('C:\Users\ASUS\Desktop\am20s052\A1\Art-2views\Art\disp1.png ');
y=imread('C:\Users\ASUS\Desktop\am20s052\task2n3\Task3\Output\BlockRadii\Art\blockradii_3.png  ');
%xG = rgb2gray(x);
yG = rgb2gray(y);


g=size(yG);
%g=size(y);

x=imresize(x,[g(1),g(2)]);
z=imabsdiff(x,yG);
%z=imabsdiff(x,y);

figure;
imshow(x);
title('First image');
figure;
imshow(yG);
%imshow(y);
title('Second image');
figure;
imshow(z);
%title('Difference of two images');
%numofBlackPixels = sum(sum(z==0));
%N= nnz(z);
N1= z > 50;
N= nnz(N1);
total = g(1,1)*g(1,2);
count = (N/ total)*100;



