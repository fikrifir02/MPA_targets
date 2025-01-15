%function to accumulate catches for each species in all zones

function [catch_species catch_sp] = catch_per_species(xres, nspp)
            catch_species = struct();
            catch_species.species = [];
            catch_species.sum_species = [];
            catch_sp = [];
            for i = 1: nspp
            catch_species(i).species = xres.Catches(:,1+(3*(i-1)):3*i);
            catch_species(i).sum_species = sum(catch_species(i).species,2);
            catch_sp = [catch_sp catch_species(i).sum_species];
            end
end