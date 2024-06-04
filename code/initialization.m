function [bestval,bestpos,trace_val,trace_std,Position,Velocity,MaxFEs,Fitness,fes] = initialization(lb,ub,Npop,Nvar,funcid)
    %Parameter initialization
    MaxFEs = 3000000;%3000000
    trace_val = [];
    trace_std = [];
    Position = lb + rand(Npop, Nvar)*(ub - lb);
    Velocity = zeros(Npop, Nvar);
    Fitness = benchmark_func(Position,funcid);
     Fitness=Fitness;
    [Fitness, index] = sort(Fitness);
    Position = Position(index,:);
    Velocity = Velocity(index,:);
    [bestval,best_idx] = min(Fitness);
    bestpos=Fitness(best_idx);
    fes = Npop;
end

