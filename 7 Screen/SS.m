function [imgBW,imgData] = SS(h1,w1,h2,w2,bwfactor)

    rect = java.awt.Rectangle(h1,w1,h2,w2);
    robot = java.awt.Robot;
    jImage = robot.createScreenCapture(rect);
    h = jImage.getHeight;
    w = jImage.getWidth;

    jImageData = jImage.getData.getDataStorage;
    pixelsData = reshape(typecast(jImageData, 'uint8'), 4, w, h);

    imgData = cat(3, transpose(reshape(pixelsData(3,:,:), w, h)),...
                     transpose(reshape(pixelsData(2,:,:), w, h)),...
                     transpose(reshape(pixelsData(1,:,:), w, h)));

    imgGray = rgb2gray(imgData);
    imgBW = im2bw(imgGray,bwfactor);
end