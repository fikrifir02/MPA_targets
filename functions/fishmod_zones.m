%function for fishing

function [catch_zones] = fishmod_zones (ispp, N1, umat, spparams, A,dT)
	Avalrep = [1 - A(2,ispp)-A(3,ispp), A(2, ispp), A(3, ispp)] ;%area of mpas for converting biomass to density
    Fmortmat = umat{1,ispp}*spparams.q(ispp)*dT; %fishing mortality matrix
	bio = N1{1,ispp} .* spparams.weightsmat{1,ispp}; %biomass at year 1
	catch_zones = sum((bio .* Fmortmat .* (1 - exp(-Fmortmat - (spparams.M(ispp).*dT)))) ./ (Fmortmat + (spparams.M(ispp)*dT))); % profits
end
