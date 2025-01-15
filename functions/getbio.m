%function to calculate biomass and  catch
function[Biom, Catch]= getbio (ispp, N1, spparams)
	Biom = sum(N1{1,ispp} .* spparams.weightsmat{1,ispp}); %To calculate biomass
end 