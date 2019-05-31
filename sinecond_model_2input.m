function [IPmax_obs,IPmin_obs,IPpk2pk_obs,OPmax_obs,OPmin_obs,OPpk2pk_obs,IPmax_exp,IPmin_exp,IPpk2pk_exp,OPmax_exp,OPmin_exp,OPpk2pk_exp] = sinecond_model_2input(ge_base1,ge_base2,ge_amp1,ge_amp2,gi_base1,gi_base2,gi_amp1,gi_amp2,plot_opt,active)

%
%   sinecond_model_2input.m
%       Models the membrane potentials that would results from sinusoidal
%       changes in two different excitatory and/or inhibitory conductances
%       in phase and out of phase with each other
%   USAGE:
%       [IPmax_obs,IPmin_obs,IPpk2pk_obs,OPmax_obs,OPmin_obs,OPpk2pk_obs,IPmax_exp,IPmin_exp,IPpk2pk_exp,OPmax_exp,OPmin_exp,OPpk2pk_exp]
%           = sinecond_model_2input(ge_base1,ge_base2,ge_amp1,ge_amp2,gi_base1,gi_base2,gi_amp1,gi_amp2,plot_opt,active)
%    WHERE:
%       IPmax_obs... OPpk2pk_exp = observed (conductance model) and expected (linear voltage sum) max, min, peak-to-peak values
%       ge_base1,2 = baseline exctitatory conductances (nS)
%       ge_amp1,2 = amplitudes of excitatory conductance changes (nS)
%       gi_base1,2 = baseline inhibitory conductances (nS)
%       gi_amp1,2 = amplitudes of inhibitory conductance changes (nS)
%       plot_opt = plot option (1=yes)
%       active = active conductance option (1=yes)
%

% Sampling Times
time = [1:1:1000*5];
time_stim = time(1001:4000);
time_stim_shift = time(501:3500);
time_cycsym = time(2001:3000);

% Neuron Resting Potential (mV), Resistance (MOhm), and Capacitance (nF)
E = -65;
R = 200;
C = 0.15;

% Reversal Potentials (mV)
Ve = 0;
Vi = -75;

%%%%% PSPs in Phase %%%%%
% Run Model on Conductances from First Input Only
ge1(time) = ge_base1;
ge1(time_stim) = ge_base1+ge_amp1*(sin(2*pi*(1/1000)*time_stim));
ge1(find(ge1<0)) = 0;
ge1 = ge1 + ge_base2;
gi1(time) = gi_base1;
gi1(time_stim) = gi_base1-gi_amp1*(sin(2*pi*(1/1000)*time_stim));
gi1(find(gi1<0)) = 0;
gi1 = gi1 + gi_base2;
if active==1,
    [Vm,Vrest] = leak_int_act(time,0,C,R,E,ge_base1+ge_base2,ge1,Ve,gi_base1+gi_base2,gi1,Vi);
else
    [Vm,Vrest] = leak_int(time,0,C,R,E,ge_base1+ge_base2,ge1,Ve,gi_base1+gi_base2,gi1,Vi);
end
Vm1 = Vm-Vrest;

% Run Model on Conductances from Second Input Only
ge2(time) = ge_base2;
ge2(time_stim) = ge_base2+ge_amp2*(sin(2*pi*(1/1000)*time_stim));
ge2(find(ge2<0)) = 0;
ge2 = ge2 + ge_base1;
gi2(time) = gi_base2;
gi2(time_stim) = gi_base2-gi_amp2*(sin(2*pi*(1/1000)*time_stim));
gi2(find(gi2<0)) = 0;
gi2 = gi2 + gi_base1;
if active==1,
    [Vm,Vrest] = leak_int_act(time,0,C,R,E,ge_base1+ge_base2,ge2,Ve,gi_base1+gi_base2,gi2,Vi);
else
    [Vm,Vrest] = leak_int(time,0,C,R,E,ge_base1+ge_base2,ge2,Ve,gi_base1+gi_base2,gi2,Vi);
end
Vm2 = Vm-Vrest;

% Run Model on Conductances from Both Inputs
ge12ip = ge1+ge2-ge_base1-ge_base2;
gi12ip = gi1+gi2-gi_base1-gi_base2;
if active==1,
    [Vm,Vrest] = leak_int_act(time,0,C,R,E,ge_base1+ge_base2,ge12ip,Ve,gi_base1+gi_base2,gi12ip,Vi);
else
    [Vm,Vrest] = leak_int(time,0,C,R,E,ge_base1+ge_base2,ge12ip,Ve,gi_base1+gi_base2,gi12ip,Vi);
end
Vm12ip = Vm-Vrest;

% Create Expected Linear Combinations
Vm12ip_exp = Vm1 + Vm2;

% Calculate Maxima, Minima, and Peak-to-Peak Amplitudes
IPmax_obs = max(Vm12ip(time_cycsym));
IPmin_obs = min(Vm12ip(time_cycsym));
IPpk2pk_obs = IPmax_obs-IPmin_obs;
IPmax_exp = max(Vm12ip_exp(time_cycsym));
IPmin_exp = min(Vm12ip_exp(time_cycsym));
IPpk2pk_exp = IPmax_exp-IPmin_exp;

% Plot Conductances and Membrane Potential Responses
if plot_opt==1,
    figure('Name','Responses in Phase','NumberTitle','off','Position',[100 200 1100 700],'Color',[1 1 1]);
    axv(1) = subplot(231);
    plot(time(time_cycsym)-min(time(time_cycsym)),ge1(time_cycsym),'b-',time(time_cycsym)-min(time(time_cycsym)),gi1(time_cycsym),'r-','LineWidth',2)
    ylabel('g (nS)','FontName','Arial','FontSize',14);
    legend('Excitatory','Inhibitory','Location','Best');
    axv(2) = subplot(232);
    plot(time(time_cycsym)-min(time(time_cycsym)),ge2(time_cycsym),'b-',time(time_cycsym)-min(time(time_cycsym)),gi2(time_cycsym),'r-','LineWidth',2)
    axv(3) = subplot(233);
    plot(time(time_cycsym)-min(time(time_cycsym)),ge12ip(time_cycsym),'b-',time(time_cycsym)-min(time(time_cycsym)),gi12ip(time_cycsym),'r-','LineWidth',2)
    axv(4) = subplot(234);
    plot(time(time_cycsym)-min(time(time_cycsym)),Vm1(time_cycsym),'k-','LineWidth',2)
    xlabel('Time (ms)','FontName','Arial','FontSize',14);
    ylabel('V_m (mV)','FontName','Arial','FontSize',14);
    axv(5) = subplot(235);
    plot(time(time_cycsym)-min(time(time_cycsym)),Vm2(time_cycsym),'k-','LineWidth',2)
    xlabel('Time (ms)','FontName','Arial','FontSize',14);
    axv(6) = subplot(236);
    plot(time(time_cycsym)-min(time(time_cycsym)),Vm12ip(time_cycsym),'k-',time(time_cycsym)-min(time(time_cycsym)),Vm12ip_exp(time_cycsym),'g--','LineWidth',2)
    xlabel('Time (ms)','FontName','Arial','FontSize',14);
    legend('Observed','Expected','Location','Best');
    set(axv,'XColor','k','YColor','k','FontName','Arial','FontSize',14,'Box','Off','TickDir','out','LineWidth',2,'TickLength',[0.04 0.04])
    zoom on
end
%%%%% PSPs in Phase %%%%%

%%%%% PSPs Out of Phase %%%%%
% Run Model on Conductances from First Input Only
ge1(time) = ge_base1;
ge1(time_stim) = ge_base1+ge_amp1*(sin(2*pi*(1/1000)*time_stim));
ge1(find(ge1<0)) = 0;
ge1 = ge1 + ge_base2;
gi1(time) = gi_base1;
gi1(time_stim) = gi_base1-gi_amp1*(sin(2*pi*(1/1000)*time_stim));
gi1(find(gi1<0)) = 0;
gi1 = gi1 + gi_base2;
if active==1,
    [Vm,Vrest] = leak_int_act(time,0,C,R,E,ge_base1+ge_base2,ge1,Ve,gi_base1+gi_base2,gi1,Vi);
else
    [Vm,Vrest] = leak_int(time,0,C,R,E,ge_base1+ge_base2,ge1,Ve,gi_base1+gi_base2,gi1,Vi);
end
Vm1 = Vm-Vrest;

% Run Model on Conductances from Second Input Only
ge2(time) = ge_base2;
ge2(time_stim_shift) = ge_base2+ge_amp2*(sin(2*pi*(1/1000)*time_stim));
ge2(find(ge2<0)) = 0;
ge2 = ge2 + ge_base1;
gi2(time) = gi_base2;
gi2(time_stim_shift) = gi_base2-gi_amp2*(sin(2*pi*(1/1000)*time_stim));
gi2(find(gi2<0)) = 0;
gi2 = gi2 + gi_base1;
if active==1,
    [Vm,Vrest] = leak_int_act(time,0,C,R,E,ge_base1+ge_base2,ge2,Ve,gi_base1+gi_base2,gi2,Vi);
else
    [Vm,Vrest] = leak_int(time,0,C,R,E,ge_base1+ge_base2,ge2,Ve,gi_base1+gi_base2,gi2,Vi);
end
Vm2 = Vm-Vrest;

% Run Model on Conductances from Both Inputs
ge12op = ge1+ge2-ge_base1-ge_base2;
gi12op = gi1+gi2-gi_base1-gi_base2;
if active==1,
    [Vm,Vrest] = leak_int_act(time,0,C,R,E,ge_base1+ge_base2,ge12op,Ve,gi_base1+gi_base2,gi12op,Vi);
else
    [Vm,Vrest] = leak_int(time,0,C,R,E,ge_base1+ge_base2,ge12op,Ve,gi_base1+gi_base2,gi12op,Vi);
end
Vm12op = Vm-Vrest;

% Create Expected Linear Combinations
Vm12op_exp = Vm1 + Vm2;

% Calculate Maxima, Minima, and Peak-to-Peak Amplitudes
OPmax_obs = max(Vm12op(time_cycsym));
OPmin_obs = min(Vm12op(time_cycsym));
OPpk2pk_obs = OPmax_obs-OPmin_obs;
OPmax_exp = max(Vm12op_exp(time_cycsym));
OPmin_exp = min(Vm12op_exp(time_cycsym));
OPpk2pk_exp = OPmax_exp-OPmin_exp;

% Plot Conductances and Membrane Potential Responses
if plot_opt==1,
    figure('Name','Responses Out of Phase','NumberTitle','off','Position',[100 200 1100 700],'Color',[1 1 1]);
    axv(1) = subplot(231);
    plot(time(time_cycsym)-min(time(time_cycsym)),ge1(time_cycsym),'b-',time(time_cycsym)-min(time(time_cycsym)),gi1(time_cycsym),'r-','LineWidth',2)
    ylabel('g (nS)','FontName','Arial','FontSize',14);
    legend('Excitatory','Inhibitory','Location','Best');
    axv(2) = subplot(232);
    plot(time(time_cycsym)-min(time(time_cycsym)),ge2(time_cycsym),'b-',time(time_cycsym)-min(time(time_cycsym)),gi2(time_cycsym),'r-','LineWidth',2)
    axv(3) = subplot(233);
    plot(time(time_cycsym)-min(time(time_cycsym)),ge12op(time_cycsym),'b-',time(time_cycsym)-min(time(time_cycsym)),gi12op(time_cycsym),'r-','LineWidth',2)
    axv(4) = subplot(234);
    plot(time(time_cycsym)-min(time(time_cycsym)),Vm1(time_cycsym),'k-','LineWidth',2)
    xlabel('Time (ms)','FontName','Arial','FontSize',14);
    ylabel('V_m (mV)','FontName','Arial','FontSize',14);
    axv(5) = subplot(235);
    plot(time(time_cycsym)-min(time(time_cycsym)),Vm2(time_cycsym),'k-','LineWidth',2)
    xlabel('Time (ms)','FontName','Arial','FontSize',14);
    axv(6) = subplot(236);
    plot(time(time_cycsym)-min(time(time_cycsym)),Vm12op(time_cycsym),'k-',time(time_cycsym)-min(time(time_cycsym)),Vm12op_exp(time_cycsym),'g--','LineWidth',2)
    xlabel('Time (ms)','FontName','Arial','FontSize',14);
    legend('Observed','Expected','Location','Best');
    set(axv,'XColor','k','YColor','k','FontName','Arial','FontSize',14,'Box','Off','TickDir','out','LineWidth',2,'TickLength',[0.04 0.04])
    zoom on
end
%%%%% PSPs Out of Phase %%%%%