clc;
clear;

%% Load 2 stereoscopic images
left = imread('C:\Users\ASUS\Desktop\am20s052\task2n3\Input\teddy\im2.ppm');
right = imread('C:\Users\ASUS\Desktop\am20s052\task2n3\Input\teddy\im6.ppm');
sizeI = size(left);

%  Displays a composite image
zero = zeros(sizeI(1), sizeI(2));
channelRed = left(:,:,1);
channelBlue = right(:,:,3);
composite = cat(3, channelRed, zero, channelBlue);

figure(1);
subplot(2,3,1);
imshow(left);
axis image;
title('Left');

subplot(2,3,2);
imshow(right);
axis image;
title('Right');

subplot(2,3,3);
imshow(composite);
axis image;
title('Overlapping graphs');

%% Basic block matching

%  The variance is calculated by estimating the block match of the subpixels
disp('Run the basic block match');

% Start the timer
tic();

%An average of 3 color channel values convert the RGB image to a grayscaness image
leftI = mean(left, 3);
rightI = mean(right, 3);


% SHD
%  bitsUint8 = 8;
% leftI = im2uint8(leftI./255.0);
% rightI = im2uint8(rightI./255.0);


% DbasicSubpixel:The result of the block match is saved, and the element value is a single-precision 32-bit floating point
DbasicSubpixel = zeros(size(leftI), 'single');

%  Get the image size
[imgHeight, imgWidth] = size(leftI);

%  The variance range defines how many pixels are away from the block position in the first image to search for matching blocks in other images.
disparityRange = 200;

%  Defines the block size of the block match
halfBlockSize = 4;
blockSize = 2 * halfBlockSize + 1;

%   For each row (m) pixel in the image
for (m = 1 : imgHeight)
    	
	%   Set minimum/maximum block boundaries for templates and blocks
	% For example: Line 1，minr = 1 And maxr = 4
    minr = max(1, m - halfBlockSize);
    maxr = min(imgHeight, m + halfBlockSize);
	
    %  For each column (n) pixels in the image
    for (n = 1 : imgWidth)
        
        % Set the minimum/maximum boundary for the template
        % For example: Column 1，minc = 1 and maxc = 4
		minc = max(1, n - halfBlockSize);
        maxc = min(imgWidth, n + halfBlockSize);
        
        % Define the template location as the search boundary，Restrict the search so that it does not exceed the image boundary 
		% 'mind'is the maximum number of pixels that can be searched to the left；'maxd'is the maximum number of pixels that can be searched to the right
		% You only need to search to the right here, so mind is 0
		% For images that require a two-way search，Set up mind For max(-disparityRange, 1 - minc)
		mind = 0; 
        maxd = min(disparityRange, imgWidth - maxc);

		% Select the image block on the right to use as a template
        template = rightI(minr:maxr, minc:maxc);
		
		% Get the number of image blocks for this search
		numBlocks = maxd - mind + 1;
		
		% Create vectors to save block deviations
		blockDiffs = zeros(numBlocks, 1);
        
		% Calculate the deviation of the template and each block
		for (i = mind : maxd)
		
			%Select the block at 'i' at the image distance on the left
			block = leftI(minr:maxr, (minc + i):(maxc + i));
		
			% The 1-based index of the calculator block is placed into the 'blockDiffs' vector
			blockIndex = i - mind + 1;
		    
            %{
            % NCC（Normalized Cross Correlation）
            ncc = 0;
            nccNumerator = 0;
            nccDenominator = 0;
            nccDenominatorRightWindow = 0;
            nccDenominatorLeftWindow = 0;
            %}
            
            % Calculates the absolute value and (SAD) of the difference between the template and the block as a result
            for (j = minr : maxr)
                for (k = minc : maxc)
                    
                    % SAD（Sum of Absolute Differences）
                    blockDiff = abs(rightI(j, k) - leftI(j, k + i));
                    blockDiffs(blockIndex, 1) = blockDiffs(blockIndex, 1) + blockDiff;
                    
                    
                    %{
                    % NCC
                    nccNumerator = nccNumerator + (rightI(j, k) * leftI(j, k + i));
                    nccDenominatorLeftWindow = nccDenominatorLeftWindow + (leftI(j, k + i) * leftI(j, k + i));
                    nccDenominatorRightWindow = nccDenominatorRightWindow + (rightI(j, k) * rightI(j, k));
                    %}
                end
            end
            
            % SAD
            blockDiffs(blockIndex, 1) = sum(sum(abs(template - block)));
            
            
            %{
            % NCC
            nccDenominator = sqrt(nccDenominatorRightWindow * nccDenominatorLeftWindow);
            ncc = nccNumerator / nccDenominator;
            blockDiffs(blockIndex, 1) = ncc;
            %}
            
            %{
            % SHD（Sum of Hamming Distances）
            blockXOR = bitxor(template, block);
            distance = uint8(zeros(maxr - minr + 1, maxc - minc + 1));
            for (k = 1 : bitsUint8)
                distance = distance + bitget(blockXOR, k);
            end
            blockDiffs(blockIndex, 1) = sum(sum(distance));
            %}
		end
		
		% SAD Value sorting finds the most recent match (minimum deviation), and only the index list is required here

        % SAD/SSD/SHD
        [temp, sortedIndeces] = sort(blockDiffs, 'ascend');

        %{
        % NCC
        [temp, sortedIndeces] = sort(blockDiffs, 'descend');
        %}
        % Gets a 1-based index for the most recently matched block
		bestMatchIndex = sortedIndeces(1, 1);
		
        %  Restore the block's 1-based index to offset
		% This is the final variance result of the basic block match
		d = bestMatchIndex + mind - 1;
		
        
		% Subpixel estimates that calculate the variance by insertion
		% Subpixel estimation requires blocks on the left and right, so if the best match block is at the edge of the search window, the estimate is ignored
		if ((bestMatchIndex == 1) || (bestMatchIndex == numBlocks))
			% Ignore subpixel estimates and save the initial variance value
			DbasicSubpixel(m, n) = d;
		else
			% Take the SAD value of the nearest match block (C2) and the nearest neighbor (C1 and C3)
			C1 = blockDiffs(bestMatchIndex - 1);
			C2 = blockDiffs(bestMatchIndex);
			C3 = blockDiffs(bestMatchIndex + 1);
			
			% Adjust the variance: Estimate the subpixel position of the best match position
			DbasicSubpixel(m, n) = d - (0.5 * (C3 - C1) / (C1 - (2 * C2) + C3));
        end
        
        %{
        DbasicSubpixel(m, n) = d;
        %}
    end

	% Every 10 lines of the update process
	if (mod(m, 10) == 0)
		fprintf('The image line：%d / %d (%.0f%%)\n', m, imgHeight, (m / imgHeight) * 100);
    end		
end

% Show calculation time
elapsed = toc();
fprintf('Calculate the cost of the variance chart %.2f min.\n', elapsed / 60.0);

%% Displays a visual contrast chart
fprintf('Displays a visualsail chart\n');

% Switch to Image 4
subplot(2,3,4);
% The second argument is an empty matrix, which tells imshow to use the minimum/maximum value of the data and maps the range of data to display the color
imshow(DbasicSubpixel, []);
title('The viewer chart');

%The medium filter, the window selection 25 x 25 is more appropriate
DbasicSubpixel_2 = medfilt2(DbasicSubpixel,[25 25]);
subplot(2,3,5);
imshow(DbasicSubpixel_2,[]);
%title('After filtering');

% Removing the color map displays a grayscaness variance chart
% colormap('jet');
% colorbar;

