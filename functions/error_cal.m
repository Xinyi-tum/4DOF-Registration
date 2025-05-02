function [R_error, t_error] = error_cal(R_gt,t_gt,R_opt,t_opt)

R_error = abs(acosd((trace(R_gt' * R_opt) - 1) / 2)); % angle value

t_error = norm(t_gt - t_opt);
