function [data_x_2, data_y_2, R_v, C_opt_] = second_step(data_x_1, data_y_1, r_v, epsilon)
%% this function is second step of outlier removal
% It deals with the data on the projected plane orthogonal to the screw
% axis
%% output param
% data_x_2, data_y_2 generated coordinates after 2 outlier removal(only
%                    inliers)
% R_v: auxiliary rotation matrix from screw axis to ez=[0 0 1]'
% C_opt_: optimum pole C projected to the plane orthogonal to screw axis
%% input param
% data_x_1, data_y_1: coordinates after 1st step
% epsilon: tolerance for BnB search
%% main programm

% according to screw axis r_v and e_z = [0 0 1]' set auxiliary angle and
% axis to transfer x,y to the coordinate where z-axis is along the r_v
e_z = [0 0 1]';
auxiliary_angle = acos(r_v' * e_z);
if auxiliary_angle == 0
    R_v = eye(3);
else
    auxiliary_axis = cross(e_z, r_v); % from e_z to r_v
    auxiliary_axis = auxiliary_axis / norm(auxiliary_axis);
    R_v = rotationVectorToMatrix(auxiliary_angle * auxiliary_axis);
end

% x,y transferd to the axis-related coordination system
x_p = R_v * data_x_1;
y_p = R_v * data_y_1;

% here only extract the 1 and 2 row, transfer the problem to a 2D problem
data_x_2d = x_p(1:2, :);
data_y_2d = y_p(1:2, :);

% find C according to the found projected 2D point pairs
[C_opt, ~, ~, ~, indices] = globally_search_C(data_x_2d, data_y_2d, epsilon, 0);%%为啥总是会少几个点

% final_inlier_number = num_c
data_x_2 = data_x_1(:, indices);
data_y_2 = data_y_1(:, indices);

C_opt_ = C_opt(1:2); % C_opt is homogene coordinate

end