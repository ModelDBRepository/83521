function [Ie,pk2pkVm]=sinecond_model(Ie,ge_base,ge_amp,gi_base,gi_amp,active)

%
%   sinecond_model.m
%       Models the membrane potentials that would results from sinusoidal
%       changes in excitatory and/or inhibitory conductances at various
%       levels of current injection
%   USAGE:
%       sinecond_model(Ie,ge_base,ge_amp,gi_base,gi_amp,active)
%   WHERE:
%       Ie = current injection values (nA)
%       ge_base = baseline exctitatory conductance (nS)
%       ge_amp = amplitude of excitatory conductance changes (nS)
%       gi_base = baseline inhibitory conductance (nS)
%       gi_amp = amplitude of inhibitory conductance changes (nS)
%       active = active conductance option (1=yes)
%

% Sampling Times
time = [1:1:1000*5];
time_stim = time(1001:4000);
time_cycsym = time(2001:3000);

% Neuron Resting Potential (mV), Resistance (MOhm), and Capacitance (nF)
E = -65;
R = 200;
C = 0.15;

% Reversal Potentials (mV)
Ve = 0;
Vi = -75;

% Resting Condition
rest_Ie = find(Ie==0);
if isempty(rest_Ie)==1,
    Ie = sort([Ie 0]);
    rest_Ie = find(Ie==0);
end

% Run Model
ge(time) = ge_base;
ge(time_stim) = ge_base+ge_amp*(sin(2*pi*(1/1000)*time_stim));
ge(find(ge<0)) = 0;
gi(time) = gi_base;
gi(time_stim) = gi_base-gi_amp*(sin(2*pi*(1/1000)*time_stim));
gi(find(gi<0)) = 0;
for i=1:length(Ie),
    if active==1,
        [Vm,Vrest] = leak_int_act(time,Ie(i),C,R,E,ge_base,ge,Ve,gi_base,gi,Vi);
    else
        [Vm,Vrest] = leak_int(time,Ie(i),C,R,E,ge_base,ge,Ve,gi_base,gi,Vi);
    end
    Vm_raw(i,:) = Vm;
    Vm_all(i,:) = Vm-Vrest;
end
[y,e_peak] = max(Vm_all(rest_Ie,time_cycsym));
e_peak = e_peak+min(time_cycsym)-1;
[y,i_peak] = min(Vm_all(rest_Ie,time_cycsym));
i_peak = i_peak+min(time_cycsym)-1;
maxVm = Vm_all(:,e_peak);
minVm = Vm_all(:,i_peak);
pk2pkVm = maxVm - minVm;
maxVmraw = Vm_raw(:,e_peak);
minVmraw = Vm_raw(:,i_peak);

% Plot Conductances and Membrane Potential Responses
figure('Name','Membrane Potentials','NumberTitle','off','Position',[300 500 700 400],'Color',[1 1 1]);
ax(1) = subplot(211);
plot(time,ge,'b-',...
    time,gi,'r-',...
    'LineWidth',2)
title('Conductance')
ylabel('Conductance (nS)')
legend('Excitatory','Inhibitory','Location','Best');
ax(2) = subplot(212);
plot(time,Vm_all,'k-','LineWidth',2)
xlabel('Time (ms)','FontName','Arial','FontSize',10);
ylabel('V_m (mV)')
set(ax,'XColor','k','YColor','k','FontName','Arial','FontSize',12,'Box','Off','TickDir','out')
zoom on

% Plot Peaks of Membrane Potential Responses if Injecting Different Amounts of Current
if length(Ie)>1,
    figure('Name','Membrane Potential Peaks','NumberTitle','off','Position',[100 50 1100 350],'Color',[1 1 1]);
    axp(1) = subplot(131);
    plot(Ie,maxVm,'k.-',...
        'MarkerSize',20,'LineWidth',2)
    title('Maximum Potential','FontName','Arial','FontSize',10);
    xlabel('Current (nA)','FontName','Arial','FontSize',10);
    ylabel('Potential (mV)','FontName','Arial','FontSize',10);
    axp(2) = subplot(132);
    plot(Ie,minVm,'k.-',...
        'MarkerSize',20,'LineWidth',2)
    title('Minimum Potential','FontName','Arial','FontSize',10);
    xlabel('Current (nA)','FontName','Arial','FontSize',10);
    ylabel('Potential (mV)','FontName','Arial','FontSize',10);
    axp(3) = subplot(133);
    plot(Ie,pk2pkVm,'k.-',...
        'MarkerSize',20,'LineWidth',2)
    title('Peak-to-Peak Potential','FontName','Arial','FontSize',10);
    xlabel('Current (nA)','FontName','Arial','FontSize',10);
    ylabel('Potential (mV)','FontName','Arial','FontSize',10);
    set(axp,'XColor','k','YColor','k','FontName','Arial','FontSize',12,'Box','Off','TickDir','out')
    zoom on
end