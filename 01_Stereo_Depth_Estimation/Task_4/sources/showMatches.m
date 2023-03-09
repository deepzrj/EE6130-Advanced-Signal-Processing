%==========================================================================
%                              SHOW MATCHES
%
%   This script is responsible for shows the corresponding points between
% a pair of stereo images.
%==========================================================================

function showMatches(lImage, rImage, lPoints, rPoints, label)

%	Creates a new figure.
figure;
ax = axes;

%	Shows the matches between corresponding points.
showMatchedFeatures(...
    lImage, rImage, lPoints, rPoints, 'montage', 'Parent', ax...
);

title(ax, label);
legend(ax, 'Left Points', 'Right Points');

end