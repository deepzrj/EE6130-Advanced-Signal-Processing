%==========================================================================
%                           DISPARITY FITNESS
%
%   This script is responsible for the fitness calculation of a disparity
% map. This fitness is given by the number of null pixels inside the map; 
% the less this number, the better the map.
%==========================================================================

function fitness = disparityFitness(dMap)

%   Obtains the dimensions of the disparity map.
count = 0;

[height, width] = size(dMap);

%	Counts the null pixels inside the disparity map.
for i = 1 : height
    for j = 1 : width
        if dMap(i, j) == 0
            count = count + 1;
        end
    end
end

%	Calculates the disparity map fitness.
dimension = height * width;
fitness = (count / dimension) * 100;

%   Ends the script.
end