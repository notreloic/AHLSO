%Npop: the swarm size
%funcid: the function id
%phi: the exploration balance parameter
clc
clear
Npop = 500;
phi = 0.35;
runnum = 30;
for funcid = 1:20
%     bestval = [];
    for run = 1:runnum
        bestval(funcid,run) = AHLSO(Npop,funcid,phi,run);
%         bestval = [bestval;bestever];
    end
     filename = sprintf('result/bestf%02d.txt', funcid);
     fid = fopen(filename, 'w');
     fprintf(fid, '%e\n', bestval(funcid,:));
     fclose(fid);
     
     % mean
     filename = sprintf('result/meanf%02d.txt', funcid);
     fid = fopen(filename, 'w');
     fprintf(fid, '%e\n', mean(bestval(funcid,:)));
     fclose(fid);
     
     % std
     filename = sprintf('result/stdf%02d.txt', funcid);
     fid = fopen(filename, 'w');
     fprintf(fid, '%e\n', std(bestval));
     fclose(fid);
end
save bestval bestval
