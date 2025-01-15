%Function to preallocate and set abundance in first year

function[N1] = preallfunc(ispp,Ninit,spparams, A, umat)
	N1 = nan(spparams.nages(ispp),3); %initial matrix of fish age in nmpa, reserve and fmpa
	agesrep = 0:(spparams.nages(ispp)-1); %fish age range
	Fmortmat = umat{1,ispp}(:,2)*spparams.q(ispp);%fishing mortality rate, applied in non reserve area
    mortrate = exp(-agesrep .* (spparams.M(ispp)+Fmortmat)');
            if 0 <= A(1,ispp) + A(2,ispp) + A(3,ispp)<= 1 
	N1(:,3)= Ninit(ispp) *  A(3,ispp)  * mortrate;  %calculate initial fmpa
	N1(:,2)= Ninit(ispp) *  A(2,ispp) * mortrate; %calculate initial reserve
    N1(:,1)= Ninit(ispp) * (1 - A(2,ispp)-A(3,ispp)) * mortrate;
    N1; %initial abundance in reserve and unreserved in year 1 across all ages
            else
            end
end