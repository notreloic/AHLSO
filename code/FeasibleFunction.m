function [Position] = FeasibleFunction(Position,lb,ub)
    %FEASIBLEFUNCTION �˴���ʾ�йش˺�����ժҪ
    %����ѡ����Ƿ��ڶ��巶Χ֮��
    Position(Position > ub) = ub;
    Position(Position < lb) = lb;
end

