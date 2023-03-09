%==========================================================================
%                               MAIN SCRIPT
% 
%   This is the mains script of the project. It is necessary a stereo image 
% pair to make this script works.
%==========================================================================

function main

% =========================== STATIC VARIABLES ============================

%   Used to set the input type: a pair of cameras (1) or a file path (0).
USE_WCAM = 0;

%   Used to control the process of the disparity map generation.
GENERATE = 1;

%   Range of the possible values for the disparity. The difference between 
% both values must be multiple of 16 (sixteen).
DISP_RNG = [-6 10];

%   Maximum percentage of blank pixels inside the map. The lower this value,
% the better the map -- but lower values can increase the number of retries
% to generate a acceptable disparity map, slowing the process.
MAX_BLNK = 3.0;
INCRS_RT = 0.1;

% ------------------------- If is using a webcam --------------------------

%   The ID of each camera, needed if the images will be captured by a 
% webcam pair.
LEFT_CAM = 2;
RGHT_CAM = 3;

% ------------------------ If is using a database -------------------------

%   Used to configure the utilized database (Stereorectification), the 
% choosen scene and the image format of the choosen database.
DATABASE = 'stereorectification';
SCENE    = 'Tanpura';
TYPE     = 'png';

%   Defines the default size for the input images.
IMG_SIZE = [240 320];

% =========================== LOADING IMAGES ==============================

%   Checks the input type.
switch USE_WCAM
    case 1
        %   Webcam: captures the images using the webcams.
        [lSnap, rSnap, error] = extractImages(LEFT_CAM, RGHT_CAM);
    otherwise
        %   File: loads images from a directory.
        [lSnap, rSnap, error] = loadImages(SCENE, TYPE);        
end

%   Verifies if there are any errors while loading the images.
if error == 1
    fprintf('Cannot find the webcams. Check.');
    return;
else
    if error == 2
        fprintf('Cannot load the images. Check.');
        return;
    end
end

% ============================ PRE-PROCESSING =============================

%   Does a pre-processing step.
[lSnap, rSnap] = preProcessing(lSnap, rSnap, IMG_SIZE);

% ======================== DISPARITY MAP GENERATION =======================
while GENERATE == 1

    %   Controls the process. If the generated disparity map is incorrect, 
    % restarts the process.
    GENERATE = 0;
    
    %   Tells the user that it's trying generating the disparity map.
    clc;
    fprintf('---> Generating the map.\n---> Current threshold: %.1f\n', MAX_BLNK);

    %   Extracts the matched features using the SURF algorithm and the Sum 
    % of Squared Differences. 
    [lPts, rPts] = extractMatchedFeatures(lSnap, rSnap);
    
    %   Estimates the fundamental matrix using LMedS ou MSAC, depending on 
    % the case.
    [lPts, rPts, F, error] = fundamentalMatrix(lPts, rPts);

    %   Verifies if the fundamental matrix was successfully generated. Two
    % cases are verified here: if the number of matches was enough (more
    % than seven) or if the fundamental matrix may produce distortions. 
    % In the first case, it's necessary to recapture the images; on second 
    % case, it's just necessary to recalculate the fundamental matrix. 
    if error == 1
        
        clc;
        fprintf('FAILED: low matched features.');
        
        return;

    end

    if isEpipoleInImage(F , size(lSnap)) == true || ...
       isEpipoleInImage(F', size(rSnap)) == true
        
        clc;
        fprintf('(Found epipolar lines. Retrying.)');
        
        GENERATE = 1;
        
        continue;    
    
    end
    
    %   Realizes the rectification step using the fundamental matrix.
    [lRect, rRect, tL, tR] = rectifyImages(lPts, rPts, F, lSnap, rSnap);

    %   Creates the disparity map.
    [dMap, dRng] = disparityMap(lRect, rRect, DISP_RNG);

    %   Fixes the map distortion, caused by the rectification step.
    dMap = fixWrap(dMap, tL, tR);

    %   Removes some parts of the disparity map that can be inconsiderate.
    dMap = removeGaps(dMap);

    %   Verifies if the obtained disparity map obey the max number of bad 
    % pixels (with null disparity). In positive case, another matrix needs 
    % to be obtained and the process must be redone. Otherwise, the initial 
    % disparity map is ready.
    if disparityFitness(dMap) > MAX_BLNK
        
        %   Generates the matrix again, increasing the threshold.
        MAX_BLNK = MAX_BLNK + INCRS_RT;
        GENERATE = 1;
        
        continue; 
    
    else
                
        %   Shows the disparity map.
        showImage(lSnap, 'Original Image');
        showImage(dMap, 'Disparity Map', dRng);        
        
        %   Shows the fitness and the similarity with groundtruth.
        fprintf('---> DONE. Fitness: %.4f\n\n', disparityFitness(dMap));
    
    end
    
end

%   Ends the script.
end