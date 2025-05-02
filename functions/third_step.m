function [data_x_2, data_y_2, theta, t, R] = third_step(data_x_2, data_y_2, R_v, C_opt_, d_par)
%% this function is third step
% It deals with the data on the projected plane orthogonal to the screw
% axis
%% output param
% data_x_2, data_y_2 generated coordinates after 2 outlier removal(only
%                    inliers)
% theta: the rotation angle w.r.t given screw axis, here actually v_q
% t: spatial translation
% R: rotation Matrix w.r.t given axis
%% input param
% data_x_2, data_y_2: final coordinates
% R_v: auxiliary rotation matrix from screw axis to ez=[0 0 1]'
% C_opt_: optimum pole C projected to the plane orthogonal to screw axis
% d_par: translation along the screw axis
%% main programm

% multiply data_x,y with R_v to get back to projected plane
data_x_2_ = R_v * data_x_2;
data_y_2_ = R_v * data_y_2;

% calculate theta w.r.t screw axis through the mean-value of all pairs
va = data_x_2_(1:2,:) - C_opt_;
va(3, :) = 0;
vb = data_y_2_(1:2,:) - C_opt_;
vb(3, :) = 0;
theta_opt = acos( sum(va.*vb) ./ (vecnorm(va).*(vecnorm(vb))) );

edges=linspace(-pi, pi, 361);
[angle_hist, ~, bin] = histcounts(theta_opt, edges);
[~, theta_index] = max(angle_hist);
bin = (bin == theta_index);
theta_opt_1 = theta_opt(bin);
theta = mean(theta_opt_1);
% theta = (edges(theta_index) + edges(theta_index+1))/2;

% estimate the sign of theta_opt. from [0,pi] to [-pi,pi]
vc = cross(va(:,1), vb(:,1)); % use the first term
if vc(3) > 0 % another direction
    theta = -theta;
end

% calculate d_orthogonal = (I - R_theta)*C
R_theta = [cos(theta), -sin(theta); sin(theta), cos(theta)];
d_orthogonal = (eye(2) - R_theta') * C_opt_;
d_orthogonal(3) = 0;
d_parallel = [0 0 d_par]'; % notice that d represented in the projected coordinates, t->world(3d)

% calculate t = d_parallel + d_orthogonal
t = R_v' * (d_orthogonal + d_parallel);

% calculate R w.r.t y=Rx+t
R_theta_3d = [cos(theta), -sin(theta), 0; sin(theta), cos(theta), 0; 0 0 1];
R = R_v' * R_theta_3d' * R_v;

end