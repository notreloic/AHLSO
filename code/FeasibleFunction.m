function [Position] = FeasibleFunction(Position,lb,ub)
    %FEASIBLEFUNCTION 此处显示有关此函数的摘要
    %检查候选解的是否在定义范围之内
    Position(Position > ub) = ub;
    Position(Position < lb) = lb;
end

