function [max_num, stabbing_value] = max_stabbing(starts, ends, output_position)
%% return the max stabbing number as well as where it reaches max
% input param output_position: should be "left", "middle" or "right"
%% main programm
lefts = sort(starts);
rights = sort(ends);

interval_num = size(lefts,2);
num = 0;
max_num = 0;
i = 1; j = 1;

while(i<=interval_num && j<=interval_num)
    if lefts(i) <= rights(j)
        num = num + 1;
        if num >= max_num
            max_num = num;
            max_index_l = i;
            max_index_r = j;
        end
        i = i+1;
    else
        num = num-1;
        j = j+1;
    end
end

% judge which end to be output. left / middle / right
if output_position == "left"
    stabbing_value = lefts(max_index_l);
elseif output_position == "middle"
    stabbing_value = (lefts(max_index_l) + rights(max_index_r)) / 2;
elseif output_position == "right"
    stabbing_value = rights(max_index_r);
end
end