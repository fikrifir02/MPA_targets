# MPA_targets
This repository was created to accompany the paper "Diversifying Global Biodiversity MPA Targets," specifically addressing Aichi Target 11 and Target 3 of the Global Biodiversity Framework (GBF).

This paper explores the diversity of MPA (Marine Protected Area) target implementations and predicts their catch benefits given different MPA designs and fishing pressure reductions.

## Initial setups
Initial setups:
1. Check all defined parameters in [`spparams_v3`](mains/spparams_v3.m).
    The parameters are set for four reef fish species:
        1. Parrotfish (*Scarus* spp.)
        2. Snapper (*Lutjanus* spp.)
        3. Coral trout (*Plectropomus* spp.)
        4. Rabbitfish (*Siganus* spp.)
    Beverton-Holt's recruitment parameters α and β are parameterized in this file.
2. Parameterize EOpt (Optimum Fishing Mortality Rate) that generates COpt (Maximum catch) for each species by running [`SetInits_AgeStructMod_v5`](mains/SetInits_AgeStructMod_v5.m).
    This parameterization file is run to get the parameters EOpt, which translates to 1×F<sub>msy</sub> (sustainable fishing pressure). It will be multiplied by 1.5 and 2.0 to define moderate overfishing and high overfishing, respectively.
