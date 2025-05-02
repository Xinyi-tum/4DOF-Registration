function [C_opt_3d,Point_X_new,Point_Y_new,num,ind] = globally_search_C(Point_X, Point_Y, epsilon, ifplot)
%% this function uses BnB to find C_opt
%% output param
% C_opt_3d: 3x1,not in 3d but 2d-homogene coordintae
% Point_X_new, Point_Y_new: Inlier-pairs after two times outlier-removal
% num: final inliers' number
% ind: indices w.r.t input Point set which are considered as inlier

%% input param
% Point_X, Point_Y: projected 2D coordinates of X,Y
% epsilon: tolerance
% ifplot: whether plot the BnB progress

%% main program

% Point_X_new, Point_Y_new, num
rotationframe_domain = [0; 0; pi/2]; % unit norm vector
branches = [];

new_upper = zeros(1, 4);
new_lower = zeros(1, 4);
best_branch = rotationframe_domain;

if ifplot == 1
    ss=get(0, 'screensize');
    len_x=0.45 * ss(3);
    len_y=0.45 * ss(4);
    figure;
    set(gcf, 'position', [1 1 len_x len_y]);
    title('Evolution of the bounds of exp-map')
    hold on
    grid
    h_l=animatedline('color', 'r');
    h_u=animatedline('color', 'b');
    legend('upper bound', 'lower bound')
end

iter = 0;
Lower_bound = 0;
Upper_bound = size(Point_X, 2);
t1_opt = 0;

%% find the bisector
direction = [0 -1; 1 0] * (Point_Y - Point_X);
middle = (Point_X + Point_Y) / 2;
a = direction(2,:); 
b = -direction(1,:);
c = direction(1, :) .* middle(2, :) - middle(1, :) .* direction(2, :);
data = [a; b; c]; % a series of bisectors
dataNorm = sqrt(sum(data .* data));
epsilon_i = asin(epsilon ./ dataNorm);

while(1)
    
    new_half_side = 0.5 * best_branch(3);
    
    s_1 = [best_branch(1) + new_half_side; best_branch(2) + new_half_side];
    s_2 = [best_branch(1) - new_half_side; best_branch(2) + new_half_side];
    s_3 = [best_branch(1) + new_half_side; best_branch(2) - new_half_side];
    s_4 = [best_branch(1) - new_half_side; best_branch(2) - new_half_side];
    center_branch = [s_1, s_2, s_3, s_4];
    
    for i = 1:4
        [new_lower(i), new_upper(i)] = get_bound_C(center_branch(:,i), new_half_side,epsilon, dataNorm, epsilon_i, data);
    end
    
    branches = [branches, [center_branch; ones(1,4) * new_half_side; new_lower; new_upper] ];
    %[center1; center2; radius; lower bound; upper bound]
    [new_Lower_bound, ind_lower] = max(branches(end-1, :));
    
    if(Lower_bound < new_Lower_bound)
        C_opt_2d = branches(1:2, ind_lower);
        Lower_bound = new_Lower_bound; % historical maximum lower bound
    end
    
    [Upper_bound,ind_best] = max(branches(end, :)); % current maximum upper bound
    
    best_branch = branches(1:3, ind_best);
    
    branches(:, ind_best) = [];
    
    branches(:, branches(end,:) < Lower_bound) = []; % prune upper bound is less than lower bound

    iter = iter + 1;

    if ifplot == 1
        addpoints(h_l,iter, Upper_bound);
        addpoints(h_u,iter, Lower_bound);
        drawnow
    end

    if(Upper_bound == Lower_bound)
        C_opt_3d_ = ExpMapping_point_2d_3d(C_opt_2d);
        C_opt_3d = C_opt_3d_ ./ C_opt_3d_(3,1);
        break;
    end
end

dis = abs(C_opt_3d_' * data);
ind=dis <= epsilon; % find the indices of the pairs satiesfying the condition
Point_X_new=Point_X(:, ind);
Point_Y_new=Point_Y(:, ind);
num = size(Point_X_new, 2);

end

