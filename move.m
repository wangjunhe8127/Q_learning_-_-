function [now_x,now_y] = move(pre_x,pre_y,num)
if num==1
    x = 0;
    y = 1;
elseif num==2
    x = 0;
    y = -1;
elseif num==3
    x = -1;
    y = 0;
else
    x = 1;
    y = 0;
end
now_x = pre_x+x;
now_y = pre_y+y;
end