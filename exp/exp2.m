clear
close all
addpath ../model

xdk = figure('units','inches','Position',[-24,5,10,6]);



% this function gives a diurnal course of tmax
% with no stress it would produce 4.3mm/d transpiration
% x is the time of day from 0-24
pp = pi/(18-5.5);

f  = @(x)max(0,tmax_max*sin((x-5.5)*pp));




swp0 = -0.3;
out = zeros(12*30,5,5);
hh = 5.5:0.5:18; % don't need to run the model at night
tmax_max = 1.5e-4; % midday unstressed tmax, results in about 4.3mm/d total T
tmax_oneday = tforc(tmax_max,hh);

zr   = 1;
j = 0;
kvals = (1:0.8:8.2)*10^-5;

for kmax = kvals
    j = j+1;
    i   = 0;
    swp = swp0;
    for dd = 1:30
        for tmax = tmax_oneday
            i = i+1;
            [q,lwp,fk] = getLWP(swp,tmax,kmax);
            [swp,sm] =   bucket(swp,q,zr);
            out(i,j,1) = swp;
            out(i,j,2) = lwp;
            out(i,j,3) = lwp-swp;
            out(i,j,4) = q;
            out(i,j,6) = fk*kmax;
        end
    end
end

%compute daily transpiration
g = repmat(1:30,[26,1]);
g = g(:);
q_daily = 30*60*splitapply(@sum,out(:,:,4),g);


ix = 14:26:length(out(:,1));  %midday
out(:,:,4) = nan;
out(ix,:,4) = q_daily;


ymaxxes = [0,-1,-1,5,1,1e-4];
ymins   = [-2.5,-4,-4,0,0,0];
ylabs   = {'\Psi_s (MPa)';'\Psi_L (MPa)';'\Psi_{diff} (MPa)';...
    'T (mm/s)';'';'k (mm/s)'};


colors = jet;
colors = colors(1:7:64,:);

for i = 1:6
    subplot(2,3,i)
    set(gca,'ColorOrder',colors);
    hold on
end

for i = [1,2,3,4,6]
    subplot(2,3,i)
    set(gca,'ColorOrder',colors);
    hold on
    plot(out(ix,:,i))
    xlabel('Day')
    ylabel(ylabs{i})
    ylim([ymins(i),ymaxxes(i)])
end



ll = cell(10,1);
for i = 1:10
    ll(i) = {['kmax = ',num2str(kvals(i)),'mm/s']};
end

%dummy plot for legend
subplot(2,3,5)
plot(-10+out(ix,:,1))
xlim([0,30])
ylim([0,1])
[~,hObj] = legend(ll,'Location','best');
hL=findobj(hObj,'type','line');  % get the lines, not text
set(hL,'linewidth',3)            % set their width property
set(gca,'visible','off')




xdk.PaperSize = [10,6];
xdk.PaperPosition = [0,0,10,6];

print('../figs/exp2','-dpdf')




