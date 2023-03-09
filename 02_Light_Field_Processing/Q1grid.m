
clc
% D = 'C:\Users\ASUS\Desktop\EE6130 Assignment 2\extractedimages';
% S = dir(fullfile(D,'blackfencenew*.png')); % pattern to match filenames.
% montage(S, map)
% 
% fileFolder = fullfile(matlabroot,'toolbox','images','imdata');
% dirOutput = dir(fullfile(fileFolder,'AT3_1m4_*.tif'));
% fileNames = string({dirOutput.name}); 


imds = imageDatastore('C:\Users\ASUS\Desktop\EE6130 Assignment 2\extractedimages','FileExtensions',{'.png'});
montage(imds);