function  [X,Y] = fixMPA_fred(MPA, sp)
% to plot fix reserve proportion against various FMPA proportion

%load tradeoff results
load('../output/trade_off_scenarios_results.mat');

%%Relationship between fmpa proportion(%) and catch improvement(%)with a
%%fixed reserved proportion

X = []; %f
Y = []; %catch improvement is put in the Y axis
x = []; % reserve proportion
y = []; % fmpa proportion


%F_red = number of fishing pressure reduction scenarios

F_red = size(trade_off_results.catch_long,2); % F_red is fishing effort reduction scenarios 

%calculate MPA proportion
for i = 1:F_red
    trade_off_results.catch_long{sp,i}(:,7) = round((trade_off_results.catch_long{sp,i}(:,2)+trade_off_results.catch_long{sp,i}(:,3))*100);
end

for i = 1:F_red % Fishing reduction up to 100%
    m = [];% m is an sequence index to select scenarios from 1 to end
    m = 0;
for j = 1: size(trade_off_results.catch_long{1,1},1)
if trade_off_results.catch_long{sp,i}(j,7)== MPA && trade_off_results.catch_long{sp,i}(j,1)<1 % for all species, identify combinations which have X%reserve proportion
    m = m+1;
    Y(m,i) = trade_off_results.catch_long{sp,i}(j,6)*100; % put catch improvement results from overfished scenarios (FP 2.0) into Y object
    X(m,i) = trade_off_results.catch_long{sp,i}(j,7); % put FMPA prop into X 
    x(m,i) = trade_off_results.catch_long{sp,i}(j,2)*100; % reserve proportion
    y(m,i) = trade_off_results.catch_long{sp,i}(j,3)*100; % fmpa proportion
    else
end
end
end

if Y(:,10) < 0.0001 % just to make sure that proportion below 0.01% equals to zero due to weird numeric format , different in the object column and comand window
    Y(:,10) = 0;
else
end

z = (y./(x+y))*100; %fmpa proportion over the reserve area

%Plot a figure with fix reserve proportion and various fishing pressure on
%X Axis and changing catch on Y axis
%reduction 
figure('Name',['MPA fix proportion' '' num2str(MPA) '%' '' 'sp''' num2str(sp)])


for i = [10,8,6] % Fishing effort reduction 10%, 30%, and 50% in column th respectively
plot(z(:,i),Y(:,i),'LineWidth',2) %to adjust with fmpa proportion on the y table e.g 5% fmpa proportion is on 6th row
hold on
end
leg = legend('10', '30', '50', 'Location','southwest','orientation','vertical');
title(leg,{'Fishing Effort ','Reduction (%)'})
% title(['Reserve proportion' ' '  num2str(reserve) '%'])

% reserve+1, input reserve = 10 is located on row 9 on the table object
xticks([0:10:100])
xticklabels({'0', '10','20','30','40','50','60','70','80','90','100'})
xlabel('FMPA Coverage over the MPA(%)')
xlim([0 100])
ylim([min(min(Y(:,[10 8 6])))-5 max(max(Y(:,[10 8 6])))+5])
ylabel('Catch benefit prediction (%)')
end
