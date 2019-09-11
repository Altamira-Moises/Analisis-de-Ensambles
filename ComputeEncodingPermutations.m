function  [AllCoef] = ComputeEncodingPermutations(sua_id, SpikesCell, line_timesS)

window250ms = 250; %Window time
SlidingWindow = 25; %Sliding window 25ms

Mat = [182 194 217 222 232 237 260 272]; 
TotalTrials = numel(SpikesCell);
Slidingwindows25ms = [window250ms:SlidingWindow:max(line_timesS(:,10))];
StrSlidingWindow25ms = [0:SlidingWindow:max(line_timesS(:,9))];
StimulusTime = line_timesS(1,10) - line_timesS(1,9);

TotalSliding = round((StimulusTime - window250ms)/SlidingWindow); 

trialcounter = zeros(30, 1);
Tname{1} = 'linear';
Tname{2} = 'power';
Tname{3} = 'exponential';
Tname{4} = 'logaritmic';
Tname{5} = 'gaussian';
Tname{6} = 'sigmoid';

for ventana = 1:TotalSliding

for trial = 1:TotalTrials
    %% Permutaciones 
    SP_integ = round((SpikesCell{trial}));
    SP_binary = zeros(1,round(max(SpikesCell{trial})));

    for j = 1:length(SP_integ)
        SP_binary(SP_integ(j)) = 1;
    end
    
    SP_100 = permutations(SP_binary,100);
    Position_ms = find(SP_100 == 1);
    %% Ventanas de  250ms por ensayo
    
 StrSlidingWindow = line_timesS(trial,9) + StrSlidingWindow25ms(ventana);
 EndSlidingWindow = line_timesS(trial,9) + Slidingwindows25ms(ventana);
 
    
    stim = line_timesS(trial ,2);
    categ = line_timesS(trial ,4);
    [r, c] = find(Mat(:) == stim);
    positionInplot = getPositionInPlot(stim);
    
    trialcounter(positionInplot) = trialcounter(positionInplot) + 1;
    repetition = trialcounter(positionInplot); % Current repetition for this task, phase and stimulus.
    
    StimDischarge(trial,1) = getDischargeStimWindow(Position_ms, line_timesS(trial,:),StrSlidingWindow,EndSlidingWindow);
    Distance(trial,1) = stim;
    
    DischargeperMag(repetition,r) = getDischargeStimWindow(Position_ms, line_timesS(trial,:),StrSlidingWindow,EndSlidingWindow);
    
end

%%%Mutual infromation
 MI = MutualInformation(DischargeperMag);          


x = Distance;
y = StimDischarge;
%%%%%compute curve fitting 6 models and plot predicted and actual
% figure
% colormap('jet');
% cmap = colormap;
% hold on;
%plot(x,y,'.k','MarkerSize', 12)
clear coef resid ypred

MeanDisch = mean(DischargeperMag);
SEMDisch = std(DischargeperMag)/sqrt(repetition);

maxX = max(Mat) + round(min(Mat)*.1);
minX = min(Mat) - round(min(Mat)*.1);
maxY = max(MeanDisch) + round(max(MeanDisch)*.2);
minY = min(MeanDisch) - round(max(MeanDisch)*.2);
TextY = max(MeanDisch) - round(max(MeanDisch)*.1);
% axis([minX maxX minY  maxY])
% set(gca,'xtick',Mat, 'linewidth', 1.5)
% %set(gca,'ytick',[0 250 500 750 1000 1250 1500])
% set(gca,'TickDir','out','TickLength', [0.02 0.02])
% set(gca,'FontSize',10)

for model = 1:6
    model
    [coef(:,model),resid(:,model),ypred(:,model),mse(model)] = curvefitting6functions2019_V2(x,y,model);
        
%     plot(x,ypred(:,model),'-','Color',[cmap(model*10,:)],'LineWidth',1.5)
    
end  
% xlabel('Distance (pixels)');
% ylabel('Discharge rate');
% legend(Tname{1},Tname{2},Tname{3},Tname{4},Tname{5},Tname{6},'Box','off');
% plot(Mat, MeanDisch,'.','Color',[0 0 0],'MarkerSize',18);
% errorbar(Mat, MeanDisch,SEMDisch,'.','Color',[0 0 0],'LineWidth',1);
% hold off


%%%plot MSE all models
% figure
% hold on 

% plot(1:6,mse,'.r','MarkerSize',18)
% set(gca,'xtick',[1:6], 'linewidth', 1.5)
% set(gca,'xticklabel',[{Tname{1}, Tname{2},Tname{3},Tname{4},Tname{5},Tname{6}}], 'linewidth', 1.5)
% set(gca,'TickDir','out','TickLength', [0.02 0.02])
% set(gca,'FontSize',10)
% xlabel('Model');
% ylabel('MSE');
% minY = min(mse) -  min(mse)*.1;
% maxY = max(mse) +  max(mse)*.1;
% axis([0 7 minY  maxY])
% hold off

%%%plot residuals all models
% figure
% for model = 1:6
%     model
%      subplot(3,2,model);       
%      hold on
%      plot(x,resid(:,model),'o','Color',[cmap(model*10,:)],'MarkerSize',4,'MarkerFaceColor',[cmap(model*10,:)])
%      plot(x, zeros(numel(x),1),'-k','LineWidth',1.5)
%    hold off
%     
% end  
% xlabel('Distance (pixels)');
% ylabel('Residuals');
% set(gca, xlabel,'Distance (pixels)');
% set(gca, ylabel, 'Residuals');
%  text(-20, 0, 'Residuals', 'FontSize', 14,'Rotation',90); 
%  text(220, , 'Residuals', 'FontSize', 14,'Rotation',90); 

 [Choice_P,ChoiceDiff05,Choice_PALL,ChoiceALLDiff05] = ComputeChoiceP_MeanofeachMagnitude(line_timesS, StimDischarge);
                          
 


[bestmodel,idx] = min(mse);
NameBestModel = Tname{idx};
AllCoef.coef{ventana} = coef;
AllCoef.mse{ventana} = mse;
AllCoef.MI{ventana} = MI;
AllCoef.Choice_P{ventana} = Choice_P;
AllCoef.Choice_Sig{ventana} = ChoiceDiff05;
AllCoef.Bestmodel{ventana} = Tname{idx};
end
close all
end



