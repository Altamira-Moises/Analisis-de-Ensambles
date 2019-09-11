function StimDischarge = getDischargeStimWindow(Spikes, Behtimes,StrSlidingWindow,EndSlidingWindow)



% Stim1 = Behtimes(9);%1st stimulus time
% Stim2 = Behtimes(10);%1st stimulus time
% StimulusTime = Stim2-Stim1;
% 
% NumStimSpikes = sum(Spikes >= Stim1 & Spikes < Stim2); %solo cuenta los eventos en un intervalo de tiempo (stim1 y stim2)
% StimDischarge = (NumStimSpikes/StimulusTime)*1000;

%%
Stim1 = StrSlidingWindow;%1st stimulus time
Stim2 = EndSlidingWindow; % window of 250ms
StimulusTime = Stim2 - Stim1;


NumStimSpikes = sum(Spikes >= Stim1 & Spikes < Stim2); %solo cuenta los eventos en un intervalo de tiempo (stim1 y stim2)
StimDischarge = (NumStimSpikes/StimulusTime)*1000;
