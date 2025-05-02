function [p_3d] = ExpMapping_point_2d_3d(p_2d)
% H_POINT_2D_3D Summary of this function goes here
%   unit norm <- exp

theta = vecnorm(p_2d);
if theta == 0
    p_3d = [0; 0; 1];
else
    n = p_2d ./ theta; % normalize
    p_3d = [cos(theta);
    n .* sin(theta)]; % 3*1
end
end

