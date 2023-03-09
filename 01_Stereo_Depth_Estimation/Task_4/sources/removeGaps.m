%==========================================================================
%                               REMOVE GAPS
%
%   This script is responsible for removing the highest number of null 
% grayscale blocks inside the disparity map, increasing its fitness.
%==========================================================================

function dMap = removeGaps(dMap)

%   Initializes the needed variables.
var = 1;
[lines, ~] = size(dMap);

%   Removes the nul blocks from the left side of the map.
while var ~= 0
    
    for i = 2:lines
        if dMap(i, 1) ~= 0
            var = 0;
        end
    end
    
    if var == 1
        dMap(:, 1) = [];
    end
    
end

%   Reinitializes the needed variables.
var = 1;
[lines, columns] = size(dMap);

%   Removes the nul blocks from the right side of the map.
while var ~= 0
    
    for i = 2:lines
        if dMap(i, columns) ~= 0
            var = 0;
        end
    end
    
    if var == 1
        dMap(:, columns) = [];
        [lines, columns] = size(dMap);
    end
    
end

%   Ends the script.
end