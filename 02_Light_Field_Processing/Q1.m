clc
D = 'C:\Users\ASUS\Desktop\EE6130 Assignment 2\extractedimages';
S = dir(fullfile(D,'blackfencenew*.png')); % pattern to match filenames.
for k = 1:numel(S)
    F = fullfile(D,S(k).name);
    I = imread(F);
%     imshow(I)
    S(k).data = I; % optional, save data.
end

k = randi(225);
% G = impixel((S(k).data),col,row);
% imshow(G)
A = uint16(zeros(434,625,3));

for row = 1:size(A,1)
    for col = 1: size(A,2)
         A(row,col,:) = impixel((S(k).data),row,col);
    end
end
imshow(A)
%         