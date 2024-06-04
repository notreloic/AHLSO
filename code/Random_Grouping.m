function [converg_group,groupnum] = Random_Grouping(groupsize, Npop,Fitness)
    groupnum = ceil(Npop/groupsize);%子群数量，groupsize子群大小
    converg_group = zeros(groupnum, groupsize);%子群结构体
    init_index = 1 : Npop;
    cn = 1;
    while cn <= groupnum - 1
        len = length(init_index);
        %pos = sort(randperm(len,groupsize));
        pos = randperm(len,groupsize);
        converg_group(cn,:) = init_index(pos);
        init_index(pos) = [];
        converg_group(cn, :)=make_heap(converg_group(cn, :),Fitness);
        cn = cn + 1;
    end
    work_list = length(init_index);
    converg_group(cn,1:work_list) = init_index;%最后一个子群（防止不被整除）保留剩下的所有粒子
    if work_list>1
        converg_group(cn, :)=make_heap(converg_group(cn, :),Fitness);
    end
end

