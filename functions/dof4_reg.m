function [R_opt,t_opt,cost_time,data_x_2,data_y_2] = dof4_reg(data_x,data_y,down_sp)

sc_t = 1;
sc_e = 1;
tolerance = sc_t * down_sp;
epsilon = sc_e * down_sp;
%% pre
tic
% auxiliary_angle = acos(v_p' * v_q);
% auxiliary_axis = cross(v_p, v_q);
% auxiliary_axis = auxiliary_axis/norm(auxiliary_axis);
% R_pq = rotationVectorToMatrix(-auxiliary_angle * auxiliary_axis);
R_pq = eye(3);
data_x_0 = R_pq * data_x;
% r_v = v_q;
r_v = [0 0 1]';

%% 1. first search through d_parallel

[data_x_1, data_y_1, d_parallel] = first_step(data_x_0, data_y, r_v, tolerance);


%% 2. Second search only in the set after the first outlier removal

[data_x_2, data_y_2, R_v, C_opt_] = second_step(data_x_1, data_y_1, r_v, epsilon);

%% 3. voting for theta and then calculate t_opt & R_opt

[data_x_2, data_y_2, ~, t_opt, R_opt] = third_step(data_x_2, data_y_2, R_v, C_opt_, d_parallel);
R_opt = R_opt * R_pq;

cost_time = toc;