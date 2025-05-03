%{
Description:
This example script demonstrates a basic 4-DOF point cloud registration
procedure under Gaussian noise, including:
1. Synthetic data generation with inliers/outliers.
2. Application of a 4-DOF registration algorithm.
3. Evaluation of rotation and translation errors.
%}

%% Preparation
addpath('functions');
close all; clear; clc

%% 1. Generate synthetic point clouds with Gaussian noise
num = 2000;
outlier_rate = 0.5;
num_outlier = round(num * outlier_rate);
num_inlier = num - num_outlier;
noise_level = 0.005;

% Generate data with known ground truth
[data_x, data_y, theta_gt, ~, R_gt, t_gt, ~, ~] = gen_data_gaussian(num_inlier, num_outlier, noise_level);

% Display the ground truth R and t
fprintf("====================================\n");
fprintf("Ground Truth:\n");
fprintf("R_gt = %s\n", mat2str(R_gt, 4));
fprintf("t_gt = %s\n", mat2str(t_gt, 4));

%% 2. Registration using the proposed method
[R_opt, t_opt, cost_time, ~, ~] = dof4_reg(data_x, data_y, noise_level);

% Compute rotation and translation error
[R_error, t_error] = error_cal(R_gt, t_gt, R_opt, t_opt);

%% 3. Display results in a clean format
% Display the calculated R and t
fprintf("====================================\n");
fprintf("Results:\n");
fprintf("R_opt = %s\n", mat2str(R_opt, 4));
fprintf("t_opt = %s\n", mat2str(t_opt, 4));
fprintf("====================================\n");
fprintf("Registration Results:\n");
fprintf("Rotation Error (degrees): %.4f\n", R_error);
fprintf("Translation Error:        %.4f\n", t_error);
fprintf("Computation Time (s):     %.4f\n", cost_time);
fprintf("====================================\n");