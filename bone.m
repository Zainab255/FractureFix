% Load the X-ray image
image = imread('1.jpg');
grayImage = rgb2gray(image);  % Convert to grayscale if it's a color image

% Step 1: Enhance contrast
adjustedImage = imadjust(grayImage);

% Step 2: Noise reduction (Optional)
filteredImage = medfilt2(adjustedImage, [3 3]);  % Apply median filter to reduce noise

% Step 3: Edge detection
edges = edge(filteredImage, 'canny');  % Use Canny edge detector to detect edges

% Step 4: Morphological operations
se = strel('disk', 2);             % Define structuring element
dilatedImage = imdilate(edges, se); % Dilation to strengthen edges
filledImage = imfill(dilatedImage, 'holes'); % Fill small gaps within bone structure

% Step 5: Detect fractures
% You may apply additional morphological operations or blob analysis here
fractureRegions = bwareaopen(filledImage, 50);  % Remove small objects to focus on larger features

% Step 6: Display results
figure;
subplot(2, 3, 1), imshow(grayImage), title('Original Image');
subplot(2, 3, 2), imshow(adjustedImage), title('Contrast Adjusted');
subplot(2, 3, 3), imshow(filteredImage), title('Filtered Image');
subplot(2, 3, 4), imshow(edges), title('Edge Detection');
subplot(2, 3, 5), imshow(filledImage), title('Morphological Processing');
subplot(2, 3, 6), imshow(fractureRegions), title('Detected Fractures');

% Optional: Overlay detected fracture regions on the original image
overlayImage = imoverlay(grayImage, fractureRegions, [1 0 0]);
figure, imshow(overlayImage), title('Fracture Overlay');






