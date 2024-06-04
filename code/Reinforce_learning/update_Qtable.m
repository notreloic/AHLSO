function [Q] = update_Qtable(Q,c_state,n_state, action, reward)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
alpha=0.4;
gamma=0.8;
Q(c_state,action) = Q(c_state,action) + alpha * (reward + gamma * max(Q(n_state,:)) - Q(c_state,action));
end

