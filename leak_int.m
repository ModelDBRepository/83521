function [Vm,Vrest] = leak_int(tim,Ie,C,R,E,geb,ge,Ve,gib,gi,Vi)

%
%   leak_int.m
%       Simulates a leaky integrator neuron with resting potential, excitatory
%       and inhibitory conductances and reversal potentials and current injection
%   USAGE:
%       [Vm,Vrest] = leak_int(tim,Ie,C,R,E,geb,ge,Ve,gib,gi,Vi)
%   WHERE:
%       tim = sampling times (ms)
%       Ie = electrode current (nA) [scalar or vector]
%       C = capacitance (nF)
%       R = resistance (MOhm)
%       E = resting potential (mV)
%       geb = baseline excitatory conductance (nS)
%       ge = excitatory conductances (nS) [scalar or vector]
%       Ve = excitatory reversal potential (mV)
%       gib = baseline inhibitory conductance (nS)
%       gi = inhibitory conductances (nS) [scalar or vector]
%       Vi = inhibitory reversal potential (mV)
%       Vm = membrane potential (mV)
%       Vrest = resting membrane potential (mV)
%

% Sampling Interval
dt = tim(2)-tim(1);
irreg_samp = find(diff(tim)~=dt);
if isempty(irreg_samp)==1,
else
    error('Irregular Sampling Intervals');
end

% Ensure Stability
if ((R*C)<dt),
    disp(' ');
    disp(' ');
    disp('Error: the time constant RC computed from the resistance');
    disp('and the capacitance of the model is smaller than the time');
    disp('step. Execution aborted.');
    error('???');
end

% Currents
if length(Ie)==1,
    Ie = repmat(Ie,1,length(tim));
elseif length(Ie)~=length(tim),
    error('Ie must have same length as tim!!!');
end

% Conductances
if length(ge)==1,
    ge = repmat(ge,1,length(tim));
elseif length(ge)~=length(tim),
    error('ge must have same length as tim!!!');
end
if length(gi)==1,
    gi = repmat(gi,1,length(tim));
elseif length(gi)~=length(tim),
    error('gi must have same length as tim!!!');
end

% Run Model Without Conductances to Reach Stable Baseline
Vb(1) = E;
i = 2;
for i=2:length(tim),
    Vb(i) = Vb(i-1)*(1-dt/(R*C)) + E*(dt/(R*C)) + (dt/C) * Ie(i) + (geb*(Ve-Vb(i-1)))*(dt/(R*C)) + (gib*(Vi-Vb(i-1)))*(dt/(R*C));
end

% Run Model
Vrest = Vb(end);
Vm(1) = Vrest;
i = 2;
for i=2:length(tim),
    Vm(i) = Vm(i-1)*(1-dt/(R*C)) + E*(dt/(R*C)) + (dt/C) * Ie(i) + (ge(i)*(Ve-Vm(i-1)))*(dt/(R*C)) + (gi(i)*(Vi-Vm(i-1)))*(dt/(R*C));
end