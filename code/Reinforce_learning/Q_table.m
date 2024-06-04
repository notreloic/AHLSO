function Q_table = Q_table(action_len)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
% 初始化Q矩阵

% Q_table = zeros(4,4,6);
Q_table = zeros(4,action_len);
% 设定参数
% gamma = 0.8; % 折扣因子
% alpha = 0.1; % 学习速率
% num_episodes = 500; % 迭代次数

% 定义初始状态和目标状态

% start_state = 1;

% goal_state = 6;

% 定义迭代过程
% for episode = 1:num_episodes
%     % 从起始状态开始
%     current_state = start_state;
%     % 直到到达目标状态
%     while current_state ~= goal_state
%         % 选择动作（基于epsilon-greedy策略）
%         if rand() < 0.1
%             % 探索
%             action = randi([1,6]);
%         else
%             % 利用Q值选择
%             [~,action] = max(Q(current_state,:));
%         end
% 
%         % 获取下一个状态和奖励
% 
%         next_state = action;
% 
%         reward = 0;
% 
%         % 更新Q值
% 
%         Q(current_state,action) = Q(current_state,action) + alpha * (reward + gamma * max(Q(next_state,:)) - Q(current_state,action));
% 
%         % 更新当前状态
% 
%         current_state = next_state;
% 
%     end
% 
% end
end

