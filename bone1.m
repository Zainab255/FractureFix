% Main Function to Run the Program
function boneFractureDetection()
    % Prompt the user to upload an image
    [fileName, pathName] = uigetfile({'*.jpg;*.png;*.jpeg', 'Bone X-ray Images (*.jpg, *.png, *.jpeg)'}, 'Select a Bone X-ray Image');
    
    if fileName == 0
        disp('No image selected.');
        return;
    end

    % Load and process the selected image
    image = imread(fullfile(pathName, fileName));
    fractureDetected = detectFracture(image);
    
    % Display the result with a message below the image
    figure;
    imshow(image);
    title('Bone X-ray Analysis');
    
    % Display message box below image based on fracture detection
    if fractureDetected
        uicontrol('Style', 'text', 'String', 'Fracture Detected', ...
            'ForegroundColor', 'red', 'FontSize', 12, 'FontWeight', 'bold', ...
            'Position', [20, 20, 200, 30]); % Position below the image
    else
        uicontrol('Style', 'text', 'String', 'No Fracture Detected', ...
            'ForegroundColor', 'green', 'FontSize', 12, 'FontWeight', 'bold', ...
            'Position', [20, 20, 200, 30]); % Position below the image
    end
end

% Function to Detect Fracture in the Image
function isFracture = detectFracture(image)
    grayImage = rgb2gray(image);  % Convert to grayscale if it's a color image

    % Step 1: Enhance contrast
    adjustedImage = imadjust(grayImage);

    % Step 2: Noise reduction (Optional)
    filteredImage = medfilt2(adjustedImage, [3 3]);

    % Step 3: Edge detection
    edges = edge(filteredImage, 'canny');

    % Step 4: Morphological operations
    se = strel('disk', 2);
    dilatedImage = imdilate(edges, se);
    filledImage = imfill(dilatedImage, 'holes');

    % Step 5: Fracture detection logic
    % Measure properties of connected regions to identify fractures
    fractureRegions = bwareaopen(filledImage, 50);
    fractureStats = regionprops(fractureRegions, 'Area', 'Eccentricity');

    % Define criteria for a fracture: high eccentricity and larger area
    eccentricities = [fractureStats.Eccentricity];
    areas = [fractureStats.Area];
    isFracture = any(eccentricities > 0.85 & areas > 100);

    % Display the result with overlay
    overlayImage = imoverlay(grayImage, fractureRegions, [1 0 0]);
    figure, imshow(overlayImage), title('Fracture Detection Result');
end
