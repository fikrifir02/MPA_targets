%function to collect long term catch (tmax) for each runs

function[catch_opt] = getvalsMP_sp(nvals,Aval,Etot, ispp,species_id,spparams,Ainit, nspp, Ninit, tmax, startmpa, nmonths, dT)
	catch_sp = nan(1,nvals);
	for irun = 1:nvals
		umat = arrayfun(@(species_id) createumat(species_id, spparams.afishind, Etot),species_id, 'UniformOutput',false);
		xres = timeloopfunc(Aval, umat, nspp, Ninit,spparams, Ainit, tmax, startmpa, nmonths, dT);
		[catch_species catch_sp] = catch_per_species(xres,nspp);
        catch_opt(irun) = catch_sp(tmax,ispp);
        catch_opt;
    end
end