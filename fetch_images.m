function [images] = fetch_images()
    myFolder = 'dataset';

    if ~isdir(myFolder)
      errorMessage = sprintf('Error: The following folder does not exist:\n%s', myFolder);
      uiwait(warndlg(errorMessage));
      return;
    end
    
    filePattern = fullfile(myFolder, '*.jpg');
    jpegFiles = dir(filePattern);
    
    baseFileName = jpegFiles(1).name;
    fullFileName = fullfile(myFolder, baseFileName);
%     fprintf(1, 'Now reading %s\n', fullFileName);
    imageArray = imread(fullFileName);
    images = zeros(length(jpegFiles), size(imageArray, 1), size(imageArray, 2), size(imageArray, 3));
    images(1, :, :, :) = imageArray;
    
    for k = 2:length(jpegFiles)
      baseFileName = jpegFiles(k).name;
      fullFileName = fullfile(myFolder, baseFileName);
%       fprintf(1, 'Now reading %s\n', fullFileName);
      imageArray = imread(fullFileName);
      images(k, :, :, :) = imageArray;
    end
end

