function s_con = con_calculate(best,worst,cur_f)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
% con=cn/npop;
diff_f=cur_f-best;
L=worst-best;
con=diff_f/L;
if con<(0.25)
    s_con=1;
elseif con<0.5
    s_con=2;
elseif con<0.75
    s_con=3;
else
    s_con=4;
end
end
