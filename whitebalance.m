function [new_img] = whitebalance(img,threshold)
% Adjust the white balance of the image
% 自动调节图像白平衡
% 算法：找到合适像素作为白点，调节RGB通道比例
% img: 输入 RGB 图像
% threshold: 排除最亮的像素数量
% Example: 
% new_image = whitebalance(img,50)
% Author： duzhentao
% Date: 2019-01-11

mono = sum(img,3);
mono_sorted = sort(unique(mono),'descend');
white_point = mono_sorted(threshold);
[row, col] = find(mono == white_point,1);
r_gain = 255/double(img(row,col,1));
g_gain = 255/double(img(row,col,2));
b_gain = 255/double(img(row,col,3));
new_R = img(:,:,1)*r_gain;
new_G = img(:,:,2)*g_gain;
new_B = img(:,:,3)*b_gain;
new_img = cat(3,new_R,new_G,new_B);
end