%%this function was made to generate all possible proportion of reserve,
%FMPA, and non-MPA. it only requires one variable specifying desired range
% input for this function is set to satisfy / generate reserve propotion over the seascape that matches with
% plot axis --->> MPA of seascape = X%, RESERVE of MPA = Y%
%Output of this function an objetc with three columns
%1st column = reserve proportion of seascape
%2nd column = fmpa proportion of seascape
%3rd column = nmpa proportion of seascape

function[prop] = comb(rg) %rg stands for range - range desired for analysis
x = 0 :rg: 100; % possible reserve proportion over MPA proportion
y = 0 :rg: 100; % possible MPA proportion over the seascape

reserve = []; %reserve proportion over the seascape
MPA = []; %MPA proportion over the seascape
nmpa = [];%non MPA proportion over the seascape
fmpa = []; %fmpa proportion over the seascape

%generating possible combinations of reserve, fmpa and nmpa
%it will still have total proportion >100
for i = 1: numel(x)
    for j = 1: numel(y)
        reserve(i,j) = (x(i)*y(j))/100;
        fmpa(i,j) = y(j)- reserve(i,j);
        MPA(i,j) = reserve(i,j)+fmpa(i,j);
        nmpa(i,j) = 100-MPA(i,j);
    end
end

mpa_comb = [];
for i = 1: numel(reserve)
    mpa_comb(i,1) = reserve(i);
    mpa_comb(i,2) = fmpa(i);
    mpa_comb(i,3) = nmpa(i);
end
prop = mpa_comb;
end