
clc
clear

cd ('/media/fikri02/Data/MPA_targets/mains') %change directory to output folder

load('../output/trade_off_scenarios_results.mat')
% X1, Y1: X1 is the MPA's reserve proportion for parrotfish, Y1 is the long-term catch benefit for parrotfish
% X2, Y2: X2 is the MPA's reserve proportion for snapper, Y2 is the long-term catch benefit for snapper
% X3, Y3: X3 is the MPA's reserve proportion for coral trout, Y3 is the long-term catch benefit for coral trout
% X4, Y4: X4 is the MPA's reserve proportion for rabbit fish, Y4 is the long-term catch benefit for rabbit fish
X1 = [];X2 = [];X3 = [];X4 = [];
Y1 = [];Y2 = [];Y3 = [];Y4 = [];

for i = 1: length(trade_off_results.catch_long{1,6})
    % 0 means no FMPA ; only reserve
if trade_off_results.catch_long{1,6}(i,3) == 0 && (trade_off_results.catch_long{1,6}(i,1)+ trade_off_results.catch_long{1,6}(i,2)) == 1
    X1 = [X1 trade_off_results.catch_long{1,6}(i,2)];
    Y1 = [Y1 trade_off_results.catch_long{1,6}(i,6)];
    
    X2 = [X2 trade_off_results.catch_long{2,6}(i,2)];
    Y2 = [Y2 trade_off_results.catch_long{2,6}(i,6)];
    
    X3 = [X3 trade_off_results.catch_long{3,6}(i,2)];
    Y3 = [Y3 trade_off_results.catch_long{3,6}(i,6)];
    
    X4 = [X4 trade_off_results.catch_long{4,6}(i,2)];
    Y4 = [Y4 trade_off_results.catch_long{4,6}(i,6)];
else
end
end
    
%% Plot marine reserve benefits measured by catch differences between MPA and status quo
figure('Name','long-term catch benefit of marine reserves')
a1 = plot(X2,Y2,'k-','LineWidth',2); % reserve benefit for snapper
hold on
b1 = scatter(0.3,Y2(131),100,'b','filled');
b2 = plot([0.3 0.3],[0 Y2(131)],'b--'); % Connect to x-axis
b3 = plot([0 0.3],[Y2(131) Y2(131)],'b--'); % Connect to y-axis
text(0.3, Y2(131), sprintf('%.2f%%', Y2(131) * 100), 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right', 'Color', 'k');

c1 = scatter(0.1,Y2(111),100,'r','filled');
c2 = plot([0.1 0.1],[0 Y2(111)],'r--'); % Connect to x-axis
c3 = plot([0 0.1],[Y2(111) Y2(111)],'r--'); % Connect to y-axis
text(0.1, Y2(111), sprintf('%.2f%%', Y2(111) * 100), 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right', 'Color', 'k');

i_max = find(Y2 == max(Y2));
d1 = scatter(X2(i_max),Y2(i_max),100,'k','filled');
d2 = plot([X2(i_max) X2(i_max)],[0 Y2(i_max)],'k--'); % Connect to x-axis
d3 = plot([0 X2(i_max)],[Y2(i_max) Y2(i_max)],'k--'); % Connect to y-axis
text(X2(i_max), Y2(i_max), sprintf('%.2f%%', Y2(i_max) * 100), 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right', 'Color', 'k');

ylim([0,0.5]); xlim([0,0.7]);
legend([c1 b1],'Aichi Target 11','Target 3 of the GBF')
xlabel({'Proportion of MPA coverage (%)', 'in the seascape that is fully allocated as reserve'})
xticks(0:0.1:1)
xticklabels({'0', '10','20','30','40','50','60','70','80','90','100'})
ylabel({'Differences of estimated fisheries benefits', 'based on MPA scenarios compared to the status quo (%)'})
yticks(0:0.1:1)
yticklabels({'0', '10','20','30','40','50','60','70','80','90','100'})

% Save the figure as a jpg file in the figures folder
saveas(gcf, '../figures/long_term_catch_benefit_snapper.jpg')

