function [data_x_1, data_y_1, d_parallel] = first_step(data_x, data_y, r_v, tolerance)
%% this function uses max-stabbing to find the d_parallel which satisfies 
%  the largest number of intervals
%% output param
% data_x_1, data_y_1: generated coordinates after 1st outlier removal
% d_parallel: translation along the screww axis

%% input param
% data_x,data_y: generated coordinates
% r_v: direction vector of screw axis
% noise_level: relevant to the tolerance

%% main programm

% 1. Generate the left and right boundary of all point pairs
projections = r_v' * (data_x - data_y); % term r^T * (x-y)
lefts = -tolerance - projections;
rights = tolerance - projections;

% 2. use max_stabbing algorithm to find the maximum & position
[~, d_parallel] = max_stabbing(lefts, rights, "left"); % return the left end of the interval

% 3. return the candidate inliers, recalculate and test to find satisfied
% points
leftside = projections + d_parallel;
leftside = abs(leftside);
inlier_indices = (leftside <= tolerance);

data_x_1 = data_x(:,inlier_indices);
data_y_1 = data_y(:,inlier_indices);

end