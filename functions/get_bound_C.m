function [L, U] = get_bound_C(center_branch, half_side, epsilon, dataNorm, epsilon_i, data)

radius_cube = sqrt(2) * half_side;
[center_3d] = ExpMapping_point_2d_3d(center_branch);
U_f = (epsilon_i+radius_cube >= pi/2) .* dataNorm + (epsilon_i+radius_cube < pi/2) .* sin(epsilon_i + radius_cube) .* dataNorm;
aaa = abs(data' * center_3d);
U = sum(aaa < U_f');
L = sum(aaa < epsilon);

end