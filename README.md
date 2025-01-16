# MPA_targets
This repository was created to accompany the paper "Diversifying Global Biodiversity MPA Targets," specifically addressing Aichi Target 11 and Target 3 of the Global Biodiversity Framework (GBF).

This paper explores the diversity of MPA (Marine Protected Area) target implementations and predicts their catch benefits given different MPA designs and fishing pressure reductions.

## Initial Setups
### A. Check all defined parameters in [`spparams_v3`](mains/spparams_v3.m).
The parameters are set for four reef fish species: 
1) Parrotfish (*Scarus* spp.)
2) Snapper (*Lutjanus* spp.)
3) Coral trout (*Plectropomus* spp.)
4) Rabbitfish (*Siganus* spp.)
Beverton-Holt's recruitment parameters α and β are parameterized in this file.

### B. Parameterize E<sub>Opt</sub> (Optimum Fishing Mortality Rate) that generates C<sub>Opt</sub> (Maximum catch) for each species by running [`SetInits_AgeStructMod_v5`](mains/SetInits_AgeStructMod_v5.m).
This parameterization file is run to obtain the parameters E<sub>Opt</sub>, which translates to 1×F<sub>msy</sub> (sustainable fishing pressure) under the status quo (SQ) condition where MPAs do not exist.
It will be multiplied by 1.5 and 2.0 to define moderate overfishing and high overfishing, respectively.
This file is run to obtain fishing mortality rates that generate maximum catch for each species by running the age-structured fisheries model ['timeloopfunc'](functions/timeloopfunc.m).
After obtaining F<sub>msy</sub>, MPA scenarios are built by having varied combinations of the proportions of NMPA, reserve, and FMPA, as well as fishing pressure reduction.
The fishing pressure (FP) is defined at the beginning with the following categories: 
1) sustainable (1×F<sub>msy</sub>) 
2) moderate overfishing (1.5×F<sub>msy</sub>)
3) high overfishing (2×F<sub>msy</sub>).
The reduction of fishing pressure is calculated proportionally, e.g., 50% of 2×F<sub>msy</sub> for a 50% reduction.

![Optimal effort for maximum catch](figures/Optimal%20effort%20for%20max%20catch.png)
E<sub>Opt</sub> (F<sub.msy</sub>) for maximum catch for each species:
1) Parrotfish (*Scarus* spp.): 0.2256
2) Snapper (*Lutjanus* spp.): 0.1536
3) Coral trout (*Plectropomus* spp.): 0.2064
4) Rabbitfish (*Siganus* spp.): 0.3995


### C. Run the main script [`tradeoff_simulations`](mains/tradeoff_simulations.m) to simulate fish biomass and catch overtime under different MPA scenarios (combinations of NMPA, reserve, and FMPA) and fishing pressure reductions)


 