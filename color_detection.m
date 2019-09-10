function color_selector = color_det(x)

cam = webcam(1);

while true
    color_selector = x;
    data = snapshot(cam);
    
    diff_im = imsubtract(data(:,:,color_selector), rgb2gray(data));
    diff_im = medfilt2(diff_im, [3 3]);
    diff_im = im2bw(diff_im,0.15);
    
    diff_im = bwareaopen(diff_im,100);
    bw = bwlabel(diff_im, 8);
    
    stats = regionprops(bw,'Centroid');
    
    imshow(data)
    hold on
    line([320,320],[0,480], 'Color', 'black', 'LineWidth', 2)
    
    for object = 1:length(stats)
        bc = stats(object).Centroid;
        plot(bc(1), bc(2), 'bx','LineWidth', 5, 'MarkerSize', 15);
        fprintf('X : %.2f Y : %.2f \n', bc(1), bc(2))
    end
    
    hold off
end
end

