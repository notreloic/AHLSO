function bestval = AHLSO(Npop,funcid,phi,run)
%An Agent-assisted Heterogeneous Learning Swarm Optimizer for Large-Scale
%Optimization（AHLSO）
%Npop: the swarm size
%funcid: the function id
%phi: the exploration balance parameter
pause(rand)
global initial_flag;
initial_flag = 0;
% if funcid > 12 && funcid < 14
%     Nvar = 905; % dimensionality of the objective function.
% else
%     Nvar = 1000;
% end
% if(ismember(funcid, [1,4,7,8,11,12,13,14,15]))
%     lb = -100;
%     ub = 100;
% end
% if(ismember(funcid, [2,5,9]))
%     lb = -5;
%     ub = 5;
% end
% if(ismember(funcid, [3,6,10]))
%     lb = -32;
%     ub = 32;
% end
if(ismember(funcid, [1, 4, 7:9, 12:14, 17:20]))
    lb = -100;
    ub = 100;
end
if(ismember(funcid, [2, 5, 10, 15]))
    lb = -5;
    ub = 5;
end
if(ismember(funcid, [3, 6, 11, 16]))
    lb = -32;
    ub = 32;
end
Nvar=1000;

filename = sprintf('trace/tracef%02d_%02d.txt', funcid, run);
fid = fopen(filename, 'w');
vmax = ub;
vmin = lb;
% gen = 1;
%初始化
S=[4,6,8,10,20,50];%set_action
Q_con=Q_table(6);%initialization Q_table
Q_div=Q_table(4);
[bestval,bestpos,~,~,Position,Velocity,MaxFEs,Fitness,fes] = initialization(lb,ub,Npop,Nvar,funcid);
% trace_val(gen) = min(Fitness);
% new_Position=Position(:,:);
% new_Velocity=Velocity(:,:);
% worst_val = Fitness(Npop);

mean_p = repmat(mean(Position),Npop,1);
diversity=sum(sqrt(sum((Position-mean_p).*(Position-mean_p),2)))/Npop;
fprintf(fid,'%d\t%.3g\t%.3g\n',fes,min(Fitness),diversity);
%     fprintf(fid,'%d\t%.3g\n',fes,min(Fitness));

%     mean_p = repmat(mean(Position),Npop,1);
%     trace_std(gen) = sum(sqrt(sum((Position-mean_p).*(Position-mean_p),2)))/Npop;
while fes < MaxFEs
    weight=(bestval./Fitness);
    ref=sum(weight.*Position)/sum(weight);
    for i=1:Npop
        dis_ref(i)=sqrt(sum((Position(i,:)-ref).*(Position(i,:)-ref),2));
    end
    max_dis_ref=max(dis_ref);
    dis_ref=dis_ref./max(dis_ref);
    [dis_ref, index] = sort(dis_ref);

    cn = Npop;
    while cn > 0
        %calculate state
        s_con=con_calculate(Fitness(1),Fitness(Npop),Fitness(cn));
        %select action
        cur_action_con=choose_action(Q_con,s_con,6);
        level_num = S(cur_action_con);
        %randomly select action
        % level_num=S(randi(6));
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %converge_particle
        % compute the level size of each level and the last level
        level_size = floor(Npop / level_num);
        last_level_size = level_size + mod(Npop , level_num);
        %current particle in ... level
        l_i=floor(cn/level_size);
        if(mod(cn,level_size)>0&&l_i~=level_num)
            l_i=l_i+1;
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %改进：LRA
        initial_sampling_probability = l_i / level_num ;
        sampling_probability = initial_sampling_probability + (1 - 2 * initial_sampling_probability) *fes / MaxFEs;

        if (rand(1)>sampling_probability)
            cn = cn- 1;
            continue;
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if l_i==1
            cn=cn-1;
            continue;
        end
        if l_i==2
            % 第二层节点
            temp=sort(randi([1,level_size],1,2));
            con_winners = temp(1);
        else
            temp = sort(randi(l_i-1,1,2));
            selected_level1 =temp(1);
            con_winners = (selected_level1-1)*level_size+randi([1,level_size]);
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %diversity_particle
        dcn=find(index==cn,1);
        %calculate state
        s_div=div_calculate(dis_ref(1),dis_ref(Npop),dis_ref(dcn));
        %select action
        cur_action_div=choose_action(Q_div,s_div,4);
        level_num = S(cur_action_div);
        %randomly select action
        % level_num=S(randi(6));
        level_size=floor(Npop/level_num);
        last_level_size=level_size+mod(Npop,level_num);
        %current particle in ... level in div_structure
        dl_i=floor(dcn/level_size);
        if(mod(dcn,level_size)>0&&dl_i~=level_num)
            dl_i=dl_i+1;
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %LSS
        for i=dl_i:-1:1
            initial_sampling_probability = i/dl_i;
            sampling_probability = initial_sampling_probability + (1 - 2 * initial_sampling_probability) *fes / MaxFEs;
            if (rand(1)<sampling_probability)
                selected_level1=i;
                break;
            end
            if (i==1)
                selected_level1=1;
                break;
            end
        end

        if selected_level1==level_num
            div_winners = (selected_level1-1)*level_size+randi([1,last_level_size]);
            while( index(div_winners) == cn )
                div_winners = (selected_level1-1)*level_size+randi([1,last_level_size]);
            end
        else
            div_winners = (selected_level1-1)*level_size+randi([1,level_size]);
            while( index(div_winners) == cn )
                div_winners = (selected_level1-1)*level_size+randi([1,level_size]);
            end
        end
        div_winners=index(div_winners);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        con_exemplar = Position(con_winners,:);
        div_exemplar = Position(div_winners,:);
        w = rand(1, Nvar);
        r1 = rand(1, Nvar);
        r2 = rand(1, Nvar);
        Velocity(cn,:) = w.*Velocity(cn,:) + r1.*(con_exemplar - Position(cn,:)) ...
            + phi*r2.*(div_exemplar - Position(cn,:));
        % Velocity(Velocity > vmax) = vmax;
        % Velocity(Velocity < vmin) = vmin;
        Position(cn,:) = Position(cn,:) + Velocity(cn,:);
        Position(cn,:) = FeasibleFunction(Position(cn,:),lb,ub);
        pre_fit=Fitness(cn);
        Fitness(cn) = benchmark_func(Position(cn,:),funcid);
        new_dis_ref=sqrt(sum((Position(cn,:)-ref).*(Position(cn,:)-ref),2))/max_dis_ref;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % reward calculating
        reward_con=(pre_fit-Fitness(cn))/abs(pre_fit);
        if(reward_con>0)
            reward_div=abs(dis_ref(dcn)-new_dis_ref)/abs(dis_ref(1)-dis_ref(Npop));
        else
            reward_div=(dis_ref(dcn)-new_dis_ref)/abs(dis_ref(1)-dis_ref(Npop));
        end
        % reward_div 
        % Q-table updating
        n_s_con=con_calculate(Fitness(1),Fitness(Npop),Fitness(cn));
        n_s_div=div_calculate(dis_ref(1),dis_ref(Npop),new_dis_ref);
        Q_con=update_Qtable(Q_con,s_con,n_s_con,cur_action_con, reward_con);
        Q_div=update_Qtable(Q_div,s_div,n_s_div,cur_action_div, reward_div);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
        cn = cn- 1;
        fes = fes + 1;
    end
    % Position=new_Position;
    % Velocity=new_Velocity;
    [Fitness, index] = sort(Fitness);

    Position = Position(index,:);
    Velocity = Velocity(index,:);
    bestval= Fitness(1);
%     bestpos=Position(1,:);
%     worst_val = Fitness(Npop);
    mean_p = repmat(mean(Position),Npop,1);
    % trace_std(gen) = sum(sqrt(sum((Position-mean_p).*(Position-mean_p),2)))/Npop;
    diversity=sum(sqrt(sum((Position-mean_p).*(Position-mean_p),2)))/Npop;
    fprintf(fid,'%d\t%.3g\t%.3g\n',fes,min(Fitness),diversity);
end
fprintf(['AHLSO: The best and FEs of Function ', num2str(funcid), ' (', num2str(run), '):%e'],bestval);
fclose(fid);
fprintf('Run No.%d Done!\n', run);
disp(['CPU time: ',num2str(toc)]);
% dlmwrite(['trace' num2str(funcid) '.txt'],trace_val,'-append','delimiter',' ','precision',30);
% dlmwrite(['std' num2str(funcid) '.txt'],trace_std,'-append','delimiter',' ','precision',30);
end

