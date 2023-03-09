%==========================================================================
%                               SHOW IMAGE
%
%   This script just shows a image on the screen, using the colormap if 
% needed.
%==========================================================================

function showImage(image, label, range)

%	Creates a new figure.
figure;

%	Shows the image (or disparity map).
if exist('range', 'var')
    imshow(image, range);    
else    
    imshow(image);
end

%	Adds a label to the image.
title(label);

%   Ends the script.
end