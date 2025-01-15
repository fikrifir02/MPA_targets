%Function that runs time-loop for multiple species
%MPA is same size for all species and it is implemented at the same time

function xres = timeloopfunc(Aval_null, umat, nspp, Ninit,spparams, Ainit, tmax, startmpa,...
     nmonths, dT, Frem)

N1 = struct();
species_id = [];

for i = 1:nspp
    species_id = [species_id i]; 
end

if isa(Ninit,'double') == 1
N1 = arrayfun(@(species_id) preallfunc(species_id, Ninit, spparams, Ainit, umat),species_id, 'UniformOutput',false);
else
N1 = Ninit;
end
Biomass = nan(tmax, 3*nspp);% copy three times for biomass in nmpa, reserve and fmpa for each species
Hvals = nan(tmax, nspp); % total harvest in nmpa, reserve and fmpa for each species
Catches = nan(tmax, (3*nspp));% catch in nmpa, reserve and fmpa for each species

%browser()
A = Ainit; 

for t  =  2:tmax
    for ispp =  1:nspp
        if t==startmpa(ispp)&& (Aval_null(1)+Aval_null(2))>0
        %implement MPA
         A(3, ispp) = Aval_null (2); %Aval_null(2) fmpa area proportion
         A(2, ispp) = Aval_null (1); %Aval_null(1) reserve area proportion
         A(1,ispp) = 1 - A(2, ispp) - A(3, ispp);
	    %***Turn this on or off to affect effort aggregation
		umat{1,ispp}(:,3) = Frem*umat{1,ispp}(:,3); %fishing mortality in fmpa
        umat{1,ispp}(:,1) = umat{1,ispp}(:,1) + umat{1,ispp}(:,1)*(A(2,ispp)/A(1,ispp)) + (1-Frem)*umat{1,ispp}(:,1)*(A(3,ispp)/A(2,ispp)); %fishing mortality in nmpa, area proportion is multiplied by umat in nmpa
        umat{1,ispp}(:,2) = 0;
        %***
          % half of the fishing pressure in the fmpa is allocated to nMPA
		%put fish into the MPA
            
		N1{1,ispp}(:,3) = N1{1,ispp}(:,1)*A(3,ispp);  %abundance in fmpa 
		N1{1,ispp}(:,2) = N1{1,ispp}(:,1)*A(2,ispp); %abundance in reserve 
        N1{1,ispp}(:,1) = N1{1,ispp}(:,1)*A(1,ispp); %abundance in nmpa 
        else
        end
  %Ageing/growth
   N1{1,ispp}(2:spparams.nages(ispp),:) = N1{1,ispp}(1:(spparams.nages(ispp)-1),:);
   N1{1,ispp}(1,:) = 0; %remove recruits
   N1{1,ispp};
   end
harv = zeros(1,nspp);
catch_zones = zeros(1, 3*nspp);
    for tmonths = 1:nmonths
	N1 = arrayfun(@(species_id) popmod(species_id, spparams, umat, A, N1,dT),species_id, 'UniformOutput',false); %abundance at month t
	[harv1] = (arrayfun(@(species_id) fishmod(species_id, N1, umat,spparams, A ,dT),species_id, 'UniformOutput',false)); %harvest at month t
    [catch_zones1] = (arrayfun(@(species_id) fishmod_zones(species_id, N1, umat,spparams, A ,dT),species_id, 'UniformOutput',false)); %harvest at month t
    harv1 = cell2mat(squeeze(harv1));
    catch_zones1 = cell2mat(squeeze(catch_zones1));
    harv = harv + harv1; %total harvest in whole mont for each species, each harvest at month t is accumulated (harvest at year)
    catch_zones = catch_zones + catch_zones1;   
    end
    
[Biom] = arrayfun(@(species_id) getbio(species_id, N1, spparams),species_id, 'UniformOutput',false);
Biomass(t,:) = cell2mat(Biom); %biomass at year t in each zones for each species
Catches(t,:) = catch_zones; %catch at year t in each zones for each species
Hvals(t,:) = harv; %total harvest at year t

end
xres.N1 = N1; %N1 abundance of each ages at t year.
xres.Biomass = Biomass; %biomass in each zones  for each species
xres.Catches = Catches; %catch in each zones  for each species
xres.Hvals = Hvals; %total harvest from all zones for each species
end