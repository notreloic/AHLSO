function s_div = div_calculate(best,worst,cur_f)
%GRAV_CALCULATE 此处显示有关此函数的摘要
%   此处显示详细说明
diff_f=cur_f-best;
L=worst-best;
div=diff_f/L;
if div<(0.25)
    s_div=1;
elseif div<0.5
    s_div=2;
elseif div<0.75
    s_div=3;
else
    s_div=4;
end
end