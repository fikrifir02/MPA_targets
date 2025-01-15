%%%% Age structured risk model
%
%CJ Brown 11 Nov 2013
%FF Sjahruddin 20 Nov 2019
%FF Sjahruddin 31 Aug 2020

clc
clear 

cd ('/media/fikri02/ffirma/OneDrive/matlab_drive') %set directory to mount exHD 
cd ('./MPA_target_equivalence') % set MPA_target_equivalence directory

run ('SetInits_AgeStructMod_v5_Fmsy_090321.m') %Setup initial parameters

flenm = char(['trade_off_result_PPA10'; % output file named based on fishing effort reduction
        'trade_off_result_PPA09';
        'trade_off_result_PPA08';
        'trade_off_result_PPA07';
        'trade_off_result_PPA06';
        'trade_off_result_PPA05';
        'trade_off_result_PPA04';
        'trade_off_result_PPA03';
        'trade_off_result_PPA02';
        'trade_off_result_PPA01';
        'trade_off_result_PPA00']);
    
   
 Frem = 1.0:-0.1:0.0; % Fishing effort reduction
    
  
for k = 1: length(Frem)

%%% Initialisation
startmpa_base = 50; %MPA is established at this year
startmpa = repelem(startmpa_base, output.nspp); %Copy start mpa year for all species
tmax = 100; %end #year of simulation
Aval_null = zeros(2,1); %initial proportion of reserve (first element) and fmpa (second element)
Ainit = zeros(3, output.nspp); % all elements are zero, elements of nmpa, reserve, and fmpa. All zeros


%Avals = linspace(Amin, Amax, nAvals); 
Avals = comb(1)/100; % 5 is set to match with catch benefit plot
Avals = Avals(:,[1 2]);%Two columns are selected (reserve and fmpa)
nAvals = length(Avals); %number of reserve & fmpa combinations

FPmult = [1 1.5 2]; %Fishing Pressure multiplier
nuvals = length(FPmult); %number of Fishing Pressure multiplier

%%%% Run models for different parameters
Catch_SQ = struct(); %set up a struct object of catch under status quo condition for each species
Catch_SQ.species = []; %object for catch under status quo condition for each species in each zones
Catch_SQ.sum_species = [];%object for total catch from all zones under status quo condition for each species
Catch_main = struct(); %set up a struct object of catch based on pre-setup MPA combinations for each species
Catch_main.species = []; %object of catch for each species in each zones for different MPA combinations
Catch_main.sum_species = []; %object of total catch for each species from all zones for different MPA combinations

Bio_SQ = struct(); %set up a struct object of biomass under status quo condition for each species
Bio_SQ.species = []; %object for biomass under status quo condition for each species in each zones
Bio_SQ.sum_species = []; %object for total biomass from all zones under status quo condition for each species
Bio_main = struct(); %set up a struct object of biomass based on pre-setup MPA combinations for each species
Bio_main.species = []; %object of biomass for each species in each zones for different MPA combinations
Bio_main.sum_species = []; %object of total biomass for each species from all zones for different MPA combinations

Catchdiff = struct(); %set up a struct object to generate catch differences between MPA combinations and status quo condition
Catchdiff.long = []; %catch differences (SQ VS main) in the end year of simulation
Catchdiff.short = []; %catch differences (SQ vs main) in the beginning of MPA establishment

Biodiff = struct(); %set up a struct object to generate biomass differences between MPA combinations and status quo condition
Biodiff.long = []; %biomass differences (SQ VS main) in the end year of simulation
Biodiff.short = []; %biomass differences (SQ vs main) in the beginning of MPA establishment

species_id = []; %generate index or id for each species
for i = 1 : output.nspp
species_id = [species_id i];
end

SQ1_null = [0;0]; %simulate status quo condition
SQ_null = [0;0]; %simulate status quo condition , generate equilibrium catch for each species. it can be seen on SQ plots

for iu = 1:nuvals %simulate three different fishing pressures (FP)
    umat = {};
    
    for ispp = 1: output.nspp %generate fishing mortality matrix for each species, each species has different fishing mortality depenting on Eopt of each species
    Btot = output.Eopt(ispp) * FPmult(iu);
    umat{ispp} = createumat(ispp, output.spparams.afishind,Btot);
    end
    
	xres_SQ1 = timeloopfunc(SQ1_null, umat, output.nspp, output.Ninit,output.spparams, Ainit, tmax, startmpa,...
     output.nmonths, output.dT, Frem(k)); % Simulate status quo condition over time
 
	Ninit = xres_SQ1.N1;
	tmax = 100;
    
	xres_SQ = timeloopfunc(SQ_null, umat, output.nspp, Ninit,output.spparams, Ainit, tmax, startmpa,...
    output.nmonths, output.dT, Frem(k)); % continue - Simulate status quo condition over time

        for j = 1: output.nspp %updating Catch_SQ and Bio_SQ struct objects, catch and biomass under status quo conditions generated
            Catch_SQ(j).species = xres_SQ.Catches(:,1+(3*(j-1)):3*j);
            Catch_SQ(j).sum_species = sum(Catch_SQ(j).species,2);
            
            Bio_SQ(j).species = xres_SQ.Biomass(:,1+(3*(j-1)):3*j);
            Bio_SQ(j).sum_species = sum(Bio_SQ(j).species,2);
        end
    
    for i = 1:nAvals %Simulate different MPA combinations over time.
    xres_main = timeloopfunc([Avals(i,1);Avals(i,2)], umat, output.nspp, Ninit,output.spparams, Ainit, tmax, startmpa,...
     output.nmonths, output.dT, Frem(k));
        for j = 1: output.nspp
            Catch_main(j).species = xres_main.Catches(:,1+(3*(j-1)):3*j);
            Catch_main(j).sum_species = sum(Catch_main(j).species,2);
            
            Bio_main(j).species = xres_main.Biomass(:,1+(3*(j-1)):3*j);
            Bio_main(j).sum_species = sum(Bio_main(j).species,2);
        end

        for j = 1: output.nspp       
            Catchdiff(j).long(i,iu) = (Catch_main(j).sum_species(tmax) - Catch_SQ(j).sum_species(tmax))/Catch_SQ(j).sum_species(tmax);
            Catchdiff(j).short(i,iu) = (Catch_main(j).sum_species(startmpa_base+5) - Catch_SQ(j).sum_species(startmpa_base+5))/Catch_SQ(j).sum_species(startmpa_base+5);
            
            Biodiff(j).long(i,iu) = (Bio_main(j).sum_species(tmax) - Bio_SQ(j).sum_species(tmax))/Bio_SQ(j).sum_species(tmax);
            Biodiff(j).short(i,iu) = (Bio_main(j).sum_species(startmpa_base+5) - Bio_SQ(j).sum_species(startmpa_base+5))/Bio_SQ(j).sum_species(startmpa_base+5);
        end
    end
end
save (flenm(k,:))
 end
