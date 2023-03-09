%==========================================================================
%                                FIX WRAP
%
%   This script "fixes" the disparity map position, based on the original
% projective transformations, utilized on the rectification process, in or-
% der to bring the disparity map closer to the original scene position.
%==========================================================================

function dMap = fixWrap(dMap, lTrans, rTrans)

%	Calculates the mean value between the projective transformations of the
% rectification process.
tM = (lTrans + rTrans)/2;

%   Reverts the projective transformation previously obtained.
tform = projective2d(tM);
tform = invert(tform);

%	Applies the resulting projective transformation to the disparity map,
% in order to fix its position.
dMap = imwarp(dMap, tform, 'OutputView', imref2d(size(dMap)));

%   Ends the script.
end