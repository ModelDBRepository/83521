This is the readme for the model associated with the paper:

Bruce A. Carlson and Masashi Kawasaki
Stimulus Selectivity Is Enhanced by Voltage-Dependent Conductances
in Combination-Sensitive Neurons
J Neurophysiol 96: 3362–3377, 2006.

Abstract:

Central sensory neurons often respond selectively to particular
combinations of stimulus attributes, but we know little about the
underlying cellular mechanisms. The weakly electric fish Gymnarchus
discriminates the sign of the frequency difference (Df) between a
neighbor’s electric organ discharge (EOD) and its own EOD by comparing
temporal patterns of amplitude modulation (AM) and phase modulation
(PM).  Sign-selective neurons in the midbrain respond preferentially
to either positive frequency differences (Df >0 selective) or negative
frequency differences (Df <0 selective). To study the mechanisms of
combination sensitivity, we made whole cell intracellular recordings
from sign-selective midbrain neurons in vivo and recorded postsynaptic
potential (PSP) responses to AM, PM, Df >0, and Df <0.  Responses to
AM and PM consisted of alternating excitatory and inhibitory
PSPs. These alternating responses were in phase for the preferred sign
of Df and offset for the nonpreferred sign of Df.  Therefore a certain
degree of sign selectivity was predicted by a linear sum of the
responses to AM and PM. Responses to the nonpreferred sign of Df, but
not the preferred sign of Df, were substantially weaker than linear
predictions, causing a significant increase in the actual degree of
sign selectivity. By using various levels of current clamp and
comparing our results to simple models of synaptic integration, we
demonstrate that this decreased response to the nonpreferred sign of
Df is caused by a reduction in voltage-dependent excitatory
conductances. This finding reveals that nonlinear decoders, in the
form of voltage-dependent conductances, can enhance the selectivity of
single neurons for particular combinations of stimulus attributes.

Usage:

The archieve has all the Matlab files needed to run the
conductance-based models from our J Neurophysiol
paper. "sinecond_model" models the effects of excitatory and/or
inhibitory synaptic responses to modulation of a single stimulus
feature under a variety of holding currents, with or without active
conductances (leak_int_act.m or leak_int.m, respectively).
"sinecond_model_2input" models the effects of excitatory and/or
inhibitory synaptic responses to modulation of 2 different stimulus
features, with or without active conductances.
