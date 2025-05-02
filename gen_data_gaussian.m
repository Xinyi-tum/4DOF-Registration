function [data_x,data_y,R_theta,r_v,R_gt,t_gt,v_p,v_q]=gen_data_gaussian(num_inlier,num_outlier,noise_level)
%% this function will generate random point pairs, which include inliers as well as outliers.
%% output param
% data_x,data_y: generated coordinates of x, y with correspondence
% R_theta: rotate angle
% R_v: screw axis unit vector
% R_gt: Rotation Matrix
% t_gt: Translation vector
% v_p: gravity direction
% v_q: gravity direction in second coordinate(q)
%% input param
% num_inlier
% num_outlier
% noise_level

%% main programm
R_theta = (rand*2 - 1) * pi; % [-pi, pi]
% v = rand(3,1)*2 - 1;
% r_v = v./norm(v); % normalize
% R_gt = rotationVectorToMatrix(R_theta*r_v); % Rodirigue's formula
R_gt = [ cos(R_theta) sin(R_theta) 0; -sin(R_theta) cos(R_theta) 0; 0 0 1];
scale = 1;
t_gt = scale * (rand(3,1)*2 - 1); % scale

% generate the inliers
data_x_inlier = scale * (rand(3,num_inlier)*2 - 1); % scale [-100, 100]
data_y_inlier = R_gt*data_x_inlier + t_gt;

% confirm the gravity direction (randomly)
% v = data_x_inlier(:,1) - data_x_inlier(:,2); % random gravity direction
% v_p = v ./ norm(v);
r_v = 0;
v_p = [0 0 -1]';
v_q = R_gt * v_p;

% generate outliers
data_x_outlier = scale * (rand(3,num_outlier)*2-1);
data_y_outlier = scale * (rand(3,num_outlier)*2-1);

% new gaussian noise
data_x=[data_x_inlier,data_x_outlier] + scale*normrnd(0,noise_level,3,num_inlier+num_outlier);
data_y=[data_y_inlier,data_y_outlier] + scale*normrnd(0,noise_level,3,num_inlier+num_outlier);


end



