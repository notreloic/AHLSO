function next_action = choose_action(Q,c_state,action_len)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
% next_action=-1;
epsilon=0.6;
if (rand(1) < epsilon)
    %开发
    [~,next_action]=max(Q(c_state,:));
else
    %探索
    % choose random action,
    % 6=动作数量
    next_action =randi(action_len);
end

