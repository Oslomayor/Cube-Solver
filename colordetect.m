function [cube_stateString,cube_stateColor] = colordetect(path)
% [特征字符串，颜色状态] = getlocation(魔方图片文件夹路径)
% get color results of cubes
% AuthorL: duzhentao
% Date: 2019-5
img_name = {'1U','2R','3F','4D','5L','6B'};
RGB_data = zeros(54,3);
for img_count = 1:6
    cube_img = imread([path,img_name{img_count},'.jpg']);
    width = size(cube_img,1);
    gap = fix(width/3);
    halfgap = fix(width/6);
    for a = 0:2
        for b = 0:2
            xx = halfgap+gap*b;
            yy = halfgap+gap*a;
            RGB_data(a*3+(b+1)+(img_count-1)*9,:) = ...
                reshape(mean(mean(...
                cube_img(yy-10:yy+10,xx-10:xx+10,:))),[1 3]);
        end
    end
end
% K-means 聚类
X = RGB_data;
[idx, C] = kmeans(X,6,'Replicates',10);
% 将颜色匹配到分类结果
wryobg_index = ...
    [idx(5+9*0);
    idx(5+9*1);
    idx(5+9*2);
    idx(5+9*3);
    idx(5+9*4);
    idx(5+9*5)];
cube_stateString = repmat('',54,1);
cube_stateColor = repmat('',54,1);
colors_map = repmat(0,54,3);
for ii=1:54
    switch idx(ii)
        case wryobg_index(3)
            cube_stateColor(ii) = '白';
            colors_map(ii,:) = [0 0 0];
            cube_stateString(ii) = 'f';
        case wryobg_index(1)
            cube_stateColor(ii) = '红';
            colors_map(ii,:) = [1 0 0];
            cube_stateString(ii) = 'u';
        case wryobg_index(6)
            cube_stateColor(ii) = '黄';
            colors_map(ii,:) = [1 1 0];
            cube_stateString(ii) = 'b';
        case wryobg_index(4)
            cube_stateColor(ii) = '橙';
            colors_map(ii,:) = [1 0.4 0];
            cube_stateString(ii) = 'd';
        case wryobg_index(5)
            cube_stateColor(ii) = '蓝';
            colors_map(ii,:) = [0 0 1];
            cube_stateString(ii) = 'l';
        case wryobg_index(2)
            cube_stateColor(ii) = '绿';
            colors_map(ii,:) = [0 1 0];
            cube_stateString(ii) = 'r';
        otherwise
            cube_stateColor(ii) = 'X';
            colors_map(ii,:) = [0.5 0.5 0.5];
            cube_stateString(ii) = 'x';
    end
end
