a = arduino('COM7','Uno','Libraries','Servo');
s = servo(a,'D4','MinPulseDuration',7.00e-4,'MaxPulseDuration',2.3e-3);

cam = webcam(1);
color_selector = 1; % 1 for RED, 2 for GREEN, 3 for BLUE

while true
    
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
        x_coor = bc(1);
        y_coor = bc(2);
        plot(x_coor, y_coor, 'bx','LineWidth', 5, 'MarkerSize', 15);
        %fprintf('X : %.2f Y : %.2f \n', bc(1), bc(2))
        
        error = x_coor-320;
        x_dist = error*0.06718;
        deg = atan(x_dist/30);
        deg_map = (deg+0.6)*(1-0)/(0.6+0.6) + 0;
        fprintf('DEG %.2f \n', deg_map)
        writePosition(s,deg_map)
    end

end
