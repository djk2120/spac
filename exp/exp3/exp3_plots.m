clear
close all

% set up figure
fig = figure('Units','inches','Position',[-24 2 10 6]);
colors = jet;
colors = flipud(colors(1:7:64,:));


%load data
data = load('exp3.mat');


%I want each subplot to plot lwp_midday vs. time for:
%  one value of kmax
%  all ten values of zr
kmax      = data.kmax.value;
kmax_uniq = unique(kmax);
nk        = length(kmax_uniq);
for i = 1:nk     %looping through the 10 unique kmax values
    
    %find the indices for that value of kmax
    ix = kmax == kmax_uniq(i);
    
    %plot
    subplot(3,4,i)
    hold on
    set(gca,'ColorOrder',colors)
    plot(data.lwp_midday.value(:,ix))
    ylim([-4,-2])
    xlim([0,30])
    set(gca,'Ytick',-4:1:-2)
    title(['kmax = ',num2str(kmax_uniq(i)),' mm/s'])
    
    %only put these labels on a few subplots
    if i>8
        xlabel('Day')
    end
    if i==1||i==5||i==9
        ylabel('\Psi_{leaf} (MPa)')
    end
    
end


%create legend
zr_uniq = data.zr.value(ix);
nz      = length(zr_uniq);
leg     = cell(nz,1);
for i = 1:nz
    leg{i} = ['Zr = ',num2str(zr_uniq(i)),' m'];
end

%dummy plot for legend
subplot(3,4,12)
hold on
set(gca,'ColorOrder',colors)
plot(data.lwp_midday.value(:,ix))
xlim([0,30])
ylim([0,1])
[~,hObj] = legend(leg,'Location','best');
hL=findobj(hObj,'type','line');  % get the lines, not text
set(hL,'linewidth',3)            % set their width property
set(gca,'visible','off')

%print figure
fig.PaperSize = [10,6];
fig.PaperPosition  =[0,0,10,6];
print('../../figs/exp3a','-dpdf')
