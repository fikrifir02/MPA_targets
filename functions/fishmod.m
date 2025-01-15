%function for fishing

function [Ben] = fishmod (ispp, N1, umat, spparams, A,dT)
	Avalrep = [1 - A(2,ispp)-A(3,ispp), A(2, ispp), A(3, ispp)] ;%area of mpas for converting biomass to density
    Fmortmat = umat{1,ispp}*spparams.q(ispp)*dT; %fishing mortality matrix
	bio = N1{1,ispp} .* spparams.weightsmat{1,ispp}; %biomass at year 1
	profs = sum((bio .* Fmortmat .* (1 - exp(-Fmortmat - (spparams.M(ispp).*dT)))) ./ (Fmortmat + (spparams.M(ispp)*dT)) * spparams.RelVal(ispp)); % profits
	costs = profs .* (spparams.omega(ispp)./(sum(bio) ./ Avalrep)); %cost is used to calculate profits/Benefits
	Ben = sum(profs(isfinite(costs))-costs(isfinite(costs))); %Ben, benefits is used to calculate harvest
end
