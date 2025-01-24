%% Plot heatmap
cd ('/media/fikri02/Data/MPA_targets/mains')
load('../output/trade_off_scenarios_results.mat')
addpath('../functions')
%uncomment heatmap if required
% Only for snapper species - sp2 - under overfished condition 2 x Fmsy
% plot the difference in fisheries benefit from varying MPA and FMPA coverage proportions
figure('Name','heatmap - sp2 - 0.5 Fred')
plot_fmpa_vs_mpa(trade_off_results, 2, 50, 2) % fishing reduction 50%, fishing remaining 50%
saveas(gcf,'../figures/heatmap_snapper_0.5_Fred_overfished.jpg')
figure('Name','heatmap - sp2 - snapper 0.3 Fred')
plot_fmpa_vs_mpa(trade_off_results, 2, 30, 2) % fishing reduction 30%, fishing remaining 70%
saveas(gcf,'../figures/heatmap_snapper_0.3_Fred_overfished.jpg')
figure('Name','heatmap - sp2 - snapper 0.1 Fred')
plot_fmpa_vs_mpa(trade_off_results, 2, 10, 2) % fishing reduction 10%, fishing remaining 90%
saveas(gcf,'../figures/heatmap_snapper_0.1_Fred_overfished.jpg')
 

% plot the effect of trade-off between increasing FMPA proportion and decreasing reserve proportion on the increase in catch
% 10% MPA coverage - species snapper - overfished condition 2 x Fmsy
fixMPA_fred(10,2) % 2 is number of species for snapper
saveas(gcf,'../figures/trade_off_reserve_fmpa_10.jpg')
fixMPA_fred(30,2) % 2 is number of species for snapper
saveas(gcf,'../figures/trade_off_reserve_fmpa_30.jpg')


%plot Equivalence in fisheries benefit scatter plot for 10 and 30 reserve coverage reserve propotion
% species - snapper ; fishery condition - overfished 2 x Fmsy
equil(0.1)
saveas(gcf,'../figures/equivalence_0.1_reserve.jpg')
equil(0.3)
saveas(gcf,'../figures/equivalence_0.3_reserve.jpg')

