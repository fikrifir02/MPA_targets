% Age structured risk model
% Assumes variable fisher skill
% Set initial conditions
% Runs model to get optimal effort then saves parameters
% Fikri Sjahruddin

clc
clear

cd ('/media/fikri02/Data/MPA_targets') % configure this when running Matlab in different devices or HPC
cd ('./mains') % set to mains directory
addpath(genpath('../functions')) % add path to functions
%% run and generate initial parameters
run ('spparams_v3_210521.m')  %run and generate initial parameters
flenm = char('Params_2021_05_21');  %set file name to save parameters generated on this code

%% Check length-weight relatiionship of each species
figure("Name", "Length-weight relationship")
for ispp = 1:nspp
   subplot(1,nspp,ispp); 
   plot(1:spparams.nages(ispp), spparams.weights{1,ispp}, 'k')
   xlabel('age'); ylabel('weight(g)')
end

%% Initial parameters
Ninit = spparams.Rmax; % intial abundance based on pre-set up maximum recruitment
Ainit = zeros(nspp, nspp); %initial area proportion for reserve -2 and fmpa - 3
startmpa = repelem(50, nspp);
Aval_null = [0 ; 0]; %initial area proportion for reserve -2 and fmpa - 3
tmax = 100; %max - year 100

%% Set fishing mortality assuming fishing does not occur to calculate virgin biomass
% Virgin biomass is the biomass when fishing does not occur
% Only natural mortality influences the biomass
species_id = [];
for i = 1 : nspp
species_id = [species_id i];
end
umat = arrayfun(@(species_id) createumat(species_id, spparams.afishind,0), ...
    species_id, 'UniformOutput',false);% fishing mortality equals to zero (unfished)

xres =  timeloopfunc(Aval_null, umat, nspp, Ninit,spparams,Ainit, tmax, startmpa, nmonths, dT, 0.5); 
b_unfished = xres.Biomass(tmax, [1,4,7,10]); %unfished biomass when fishing does not occur
b0 = b_unfished; %unfished biomass when fishing does not occur

%% Find Fmsy, no MPA implemented, check optimum fishing effort to generate max catch
sppvals = [1,4,7,10]; %column -th , number of column based on three species and zones arrangement in this code. 1 4 7 representing NMPA zones for each species
nvals = 20; %setting number to generate fishing effort
uvals = linspace(0,2.0,nvals); %fishing efforts
catchvals = nan(nvals,nspp); %catch resulted based on fishing efforts applied
biovals = nan(nvals, nspp); %biomass resulted based on fishing efforts applied
N1vals = nan(nvals, nspp); %abundance resulted based on fishing efforts applied

for ivals = 1:nvals   %number of diffrerent fishing efforts
umat = arrayfun(@(species_id) createumat(species_id, spparams.afishind, uvals(ivals)),species_id, 'UniformOutput',false);
xres =  timeloopfunc(Aval_null, umat, nspp, Ninit,spparams,Ainit, tmax, startmpa, nmonths, dT, 0.5);

for ispp = 1:nspp %number of different species
        catchvals(ivals,ispp)= xres.Catches(tmax,sppvals(ispp));
		biovals(ivals,ispp) = xres.Biomass(tmax,sppvals(ispp));
        N1vals(ivals,ispp) = xres.N1{1,ispp}(1,1);
end
end

figure("Name", "Catch vs Biomass")

for ispp = 1:nspp
    subplot(1, nspp, ispp)
	plot(biovals(:,ispp), catchvals(:,ispp), 'k'); xlabel ('biomass'); ylabel ('catch')
    xlim([min(biovals(:,ispp)) max(biovals(:,ispp))])
    ylim([round(min(catchvals(:,ispp))) ceil(max(catchvals(:,ispp)))])
	yline(0,'k')
end
%% Find optimum effort to generate max catch using fminsearch and fmincon
%%%% Run models to find Fmsy
%%% Find optimal effort
for ispp = 1: nspp
nvals = 1; %nvals = 1 because optimisation is being focused on values on each simulations
fun = @(x) -getvalsMP_sp(nvals,Aval_null,x, ispp,species_id,spparams,Ainit, nspp, Ninit, tmax, startmpa, nmonths, dT) %functions used in the optimisation. It is used because it generates output total catch for each species all over the zones 
x0 = 0 %simulation starts 
options = optimset('Display','iter');
[Eopt(ispp) Copt(ispp)] = fminsearch(fun,x0, options)
end

FPmult = 2; %can be adjusted, this FP is used to see how catch responding high fishing pressure
Erun = Eopt(1) * FPmult; %fishing mortality rate is converted to be relative to fishing effort species 1

figure('Name', 'Optimal effort')

for ispp = 1:nspp
    subplot(1, nspp, ispp)
	plot(uvals, catchvals(:,ispp), 'k'); xlabel ('Effort'); ylabel ('catch')
    xlim([min(uvals)-0.5 max(uvals)+0.5])
    ylim([min(catchvals(:,ispp))-0.1 max(catchvals(:,ispp))+0.1])
	xline(Eopt(ispp),'k')
    yline(Copt(ispp),'k')
	yline(0,'k')
end

%%%% Effort plot for paper
lstyle = {'-o' '-' '--' ':'};
lcolor = [0.5 0.5 0.5; 0 0 0; 0.5 0.5 0.5;0 0 0];
fish = {'Parrotfish','Snapper', 'Coral trout', 'Rabbit fish'};

maxcatch = max(catchvals);

subplot(1,2,1)
plot(uvals,100*catchvals(:,1)/maxcatch(1), lstyle{1,1}, 'Color', lcolor(1,:),'LineWidth',1, 'MarkerFaceColor','k', 'MarkerSize',4, 'DisplayName',fish{1,1});
xlabel('Fishing mortalty rate (/yr)'); ylabel('Equilibrium catch (% of max)');
ylim([0 105]);
hold on
for ispp = 2:nspp
    plot(uvals,100*catchvals(:,ispp)/maxcatch(ispp), lstyle{1,ispp}, 'Color', lcolor(ispp,:),'LineWidth',1,'MarkerFaceColor','k', 'MarkerSize',4, 'DisplayName',fish{1,ispp});
end
legend('Parrotfish','Snapper','Coral trout', 'Rabbit fish');    


subplot(1,2,2)
maxbio = max(biovals);
plot(uvals,100*biovals(:,1)/maxbio(1), lstyle{1,1}, 'Color', lcolor(1,:),'LineWidth',1, 'MarkerFaceColor','k', 'MarkerSize',4, 'DisplayName',fish{1,1});
xlabel('Fishing mortalty rate (/yr)'); ylabel('Equilibrium biomass (% of max)');
ylim([0 105]);
hold on
for ispp = 2:nspp
    plot(uvals,100*biovals(:,ispp)/maxbio(ispp), lstyle{1,ispp}, 'Color', lcolor(ispp,:),'LineWidth',1,'MarkerFaceColor','k', 'MarkerSize',4, 'DisplayName',fish{1,ispp});
end
legend('Parrotfish','Snapper','Coral trout', 'Rabbit fish');    
%% Plot N1, Biomass, and Catch over time for two scenarios
% Scenario 0, FP = 1 = Fmsy, no MPA, no reserve
% Scenario 1, FP = 1 = Fmsy, reserve = 30%, FMPA = 20%

%Fishing pressure st up
FPmult = [1 1.5 2.0];
umat = {};
    for ispp = 1: nspp
    Btot = Eopt(ispp) * FPmult(3);
    umat{ispp} = createumat(ispp, spparams.afishind,Btot);
    end

%run scenario over time
xres_0 = timeloopfunc([0; 0], umat, nspp, Ninit,spparams, Ainit, tmax, startmpa,...
     nmonths, dT, 0.5); %Scenario 0
xres_1 = timeloopfunc([0.3; 0], umat, nspp, Ninit, spparams, Ainit, tmax, startmpa,...
     nmonths, dT,0.5); %Scenario 1
 xres_2 = timeloopfunc([0.1; 0], umat, nspp, Ninit, spparams, Ainit, tmax, startmpa,...
     nmonths, dT,0.5); %Scenario 2

Scenarios = {xres_0 xres_1};

figure("Name", "Scenario status Quo and MPA")

for p = 1:numel(Scenarios)

xres = Scenarios{1,p};

for ispp = 1: nspp
    subplot(nspp,3,(1+(3*(ispp-1))))
	plot(xres.N1{1,ispp}(:,1), 'k');
    hold on
	plot(xres.N1{1,ispp}(:,2), 'r'); 
    plot(xres.N1{1,ispp}(:,3), 'g'); xlabel ('Index'); ylabel ('N1')
   
	thissp = ispp*3 - 2;
    subplot(nspp,3,(2+(3*(ispp-1))))
    plot(1:tmax, sum(xres.Biomass(:,thissp:(thissp+2)),2), 'b'); 
	plot(1:tmax, xres.Biomass(:,thissp), 'k')
    ylim = [0 max(sum(xres.Biomass(:,thissp:(thissp+2)),2))];
    hold on
	plot(1:tmax, xres.Biomass(:,thissp+1),'r');
    plot(1:tmax, xres.Biomass(:,thissp+2),'g');
    xlabel ('Year'); ylabel ('Biomass');
	  
	thissp = ispp*3 - 2;
    subplot(nspp,3,(3+(3*(ispp-1))))
    plot(1:tmax, sum(xres.Catches(:,thissp:(thissp+2)),2), 'b'); 
	plot(1:tmax, xres.Catches(:,thissp), 'k')
    ylim = [0 max(sum(xres.Catches(:,thissp:(thissp+2)),2))];
    hold on
	plot(1:tmax, xres.Catches(:,thissp+1),'r');
    plot(1:tmax, xres.Catches(:,thissp+2),'g');
    xlabel ('Year'); ylabel ('Catch');
	end
end

%% Save parameters

output = struct();
output.spparams = spparams;
output.Copt = Copt;
output.Eopt = Eopt;
output.FPmult = FPmult;
output.nspp = nspp;
output.nmonths = nmonths;
output.dT = dT;
output.Ninit = Ninit;

save( flenm, 'output') %save all object as output object
