function [lb, ub] = Return_Boundary(func_num)
    %RETURN_BOUNDARY �˴���ʾ�йش˺�����ժҪ
    %�ú������ؾ��߱�����ȡֵ��Χ
    if(ismember(func_num, [1,4,7,8,11,12,13,14,15]))
        lb = -100;
        ub = 100;
    end
    %     if (func_num == 2 || func_num == 5 || func_num == 9)
    if(ismember(func_num, [2,5,9]))
        lb = -5;
        ub = 5;
    end
    %     if (func_num == 3 || func_num == 6 || func_num == 10)
    if(ismember(func_num, [3,6,10]))
        lb = -32;
        ub = 32;
    end
end

