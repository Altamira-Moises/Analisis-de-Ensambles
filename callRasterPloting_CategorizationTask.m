%%% Plots raster/SDF for categorization tasks
%%% Hugo Merchant 8/29/2019
%%% Modificado por Moises Altamira 04.09.19

%Tomar ventanas de 250 ms con sobrelape de ventana cada 25ms
%Hacer 100 permutaciones para cada ventana y determinar:  MSE, MI, choice P
%Choice_Sig y el mejor ajuste. 

%clear
close all
load('DataPF_S2M1ok');
ww = numel(DataBase_SUAok);

SDF_MAX = 60;
%%% Graph
AlignEpoch = 2; % 1 = trial beg, 2 = 1st stim, 3 = 2nd stim, 4 = targets on, 5 = out of central circle, 6 = target in, 7 = reward
monkey = 1;

cellidx = 1
    

    cellidx;
    sua_id = DataBase_SUAok{cellidx}.ID;
    SpikesCell = DataBase_SUAok{cellidx}.Spikes;
    line_timesS = DataBase_SUAok{cellidx}.Behav;
    DrawRasterfromSUA_CategorizationOK(sua_id, SpikesCell, line_timesS, AlignEpoch,SDF_MAX, monkey);
    [CoefsSUA{cellidx}] = ComputeEncoding(sua_id, SpikesCell, line_timesS);
    [CoefsSUAPermutations{cellidx}] = ComputeEncodingPermutations(sua_id, SpikesCell, line_timesS);
%     close all

disp 'done'