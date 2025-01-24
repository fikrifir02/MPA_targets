% created in 04-06-2021 
%Fikri Firmansyah Sjahruddin


function plot_reserve_vs_mpa(trade_off_results, sp, Fred)
% FP  Fishing pressure multiplier used in the simulations 1.0, 1.5 or 2.0
% Fred Fishing effort reduction in percentage;
% sp rows ID in tradeoffresults file 1, parrotfish, 2.snapper, 3. grouper, 4. rabbitfish
col_Fred = (Fred/10)+1; %fishing effort reduction options (col ID in order): 0,10,20,30,40,50,60,70,80,90, equal 
comb = trade_off_results.long{sp,col_Fred}(:,1:3); %NMPA, reserve, FMPA propoprtion
nuvals = length([1.0 1.5 2.0]);


% plot a MPA benefits  
% MPA prop (rows) and reserve(columns)

%create X and Y grids representing reserve against MPA proportion
x= 0:5:100; %reserve proportion over MPA proportion
y= 0:5:100; %MPA proportion (reserve+fmpa) over the seascape
[X,Y]=meshgrid(x,y); %create meshgrid X and Y based on X and Y coordinates

%Create meshgrid for long-term harvest benefit
Catch_species_sp1 = trade_off_results.long{sp,col_Fred}(:,4:6);


Catch_species = Catch_species_sp1; %generate a struct object called catch_species consist of catch differences for all species
sp_Catchdiff_sp = []; %generate an object called sp_catch_diff 1 , 2 , and 3
Z = zeros(21,21); %Create object Z assigned for catch benefit of MPA (differences between scenarios and status quo condition)


sp_Catchdiff_sp  = [comb*100 Catch_species]; %Combine reserve, fmpa, and non MPA matrix with its long-term harvest (combination of 3species in three diff FP)
sp_Catchdiff_sp(:,7) = round(sp_Catchdiff_sp(:,2)+ sp_Catchdiff_sp(:,3)); %create MPA proportion column in 7th column
sp_Catchdiff_sp(:,8) = round(((sp_Catchdiff_sp(:,2)./ sp_Catchdiff_sp(:,7)))*100); %create reserve propotion over MPA area
sp_Catchdiff_sp_nan = find(isnan(sp_Catchdiff_sp(:,8)) == 1);
sp_Catchdiff_sp(:,9) =  100 - sp_Catchdiff_sp(:,8); %create fmpa propotion over MPA area
sp_Catchdiff_sp(sp_Catchdiff_sp_nan,[8 9]) = 0;


for j = 1:size(X,1)
    for k = 1:size(X,2)
    if X(j) == 0 && Y(j) ==0
        Z(j) = 0 ;
    else
sp_Catchdiff_sp_sorted_reserve = [];
[sp_Catchdiff_sp_sorted_reserve, index] = vlookup(sp_Catchdiff_sp, X(j,k), 6, 8);
sp_Catchdiff_sp_sorted_reserve = sp_Catchdiff_sp(index,:);
sp_Catchdiff_sp_sorted_reserve_MPA = [];
[sp_Catchdiff_sp_sorted_reserve_MPA, index] = vlookup(sp_Catchdiff_sp_sorted_reserve, Y(j,k), 6, 7);
sp_Catchdiff_sp_sorted_reserve_MPA = sp_Catchdiff_sp_sorted_reserve(index,:);
sp_Catchdiff_sp_sorted_reserve_MPA = unique(sp_Catchdiff_sp_sorted_reserve_MPA,'rows');%To avoid more than a single row data sorted
    
if isempty(sp_Catchdiff_sp_sorted_reserve_MPA) == 1 
    Z(j,k) = 0;
else
    Z(j,k) = sp_Catchdiff_sp_sorted_reserve_MPA (:,6)*100;
end
    end
    end
end


%get rid of nan values from the Z matrix
	imagesc(X(1,:),Y(:,1),flip(Z)) %Plot X, Y, Z as grid plot
    set(gca,'Xtick',[0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100],...
    'Xticklabel',{'0','10','20','30','40','50','60','70','80','90','100'},...
    'YTick',[0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100],...
        'YTickLabel',{'100','90','80','70','60','50','40','30','20','10','0'},...
    'FontSize',12);
     caxis([-100 100]);% ensures all figures plotted with same colorbar scale, min and max value
     colormap(gca,jet)
     ylabel('\fontsize{16}MPA proportion over the seascape(%)');
     xlabel('\fontsize{16}Reserve proportion over the MPA(%)');


% suptitle('Seascape catch differences compared to status quo condition(%)') % Plot title
h = colorbar; %set to use color bar scale
h.LineWidth =1; %set line width of scale bar
h.Limits=[-100 100]; %set min and max of grid values of scale bar
h.Ticks= [-100 -90 -80 -70 -60 -50 -40 -30 -20 -10 0 10 20 30 40 50 60 70 80 90 100]; %set ticks appeared on the plot of scale bar
h.TickLabels = {'-100' '-90' '-80' '-70' '-60' '-50' '-40' '-30' '-20' '-10' '0'... %set ticks label appeared on the plot of scale bar
    '10' '20' '30' '40' '50' '60' '70' '80' '90' '100'};
h.Label.FontSize=12; %Set plot label font size of scale bar
h.Location='eastoutside';%Set scale bar position
%h.Position =[0.130729166666666 0.874350986500519 0.775 0.0275181720530377];%Set scale bar position
end