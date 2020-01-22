clear
close all
addpath ../model

xdk = figure('units','inches','Position',[-24,5,5,4]);





swp0 = -0.3;
out = zeros(240,3);
hh = 0:0.1:23.9; 
tmax_max = 1.5e-4; % midday unstressed tmax, results in about 4.3mm/d total T
tmax_oneday = tforc(tmax_max,hh);
kmax = 6e-5;
j = 0;
for swp = 0:-0.5:-1
    j = j+1;
    i   = 0;
    for tmax = tmax_oneday
        i = i+1;
        [q,lwp,fk] = getLWP(swp,tmax,kmax);
        out(i,j,1) = q;
    end
end

out = [tmax_oneday',out];

colors = gray(5);




hold on
set(gca,'ColorOrder',flipud(colors(1:4,:)))
plot(hh,out)
xlim([0,24])
set(gca,'xtick',0:6:24)


ll = flipud({'high stress';'medium stress';'some stress';'no stress'});

[~,hObj] = legend(ll,'Location','Southeast');
hL=findobj(hObj,'type','line');  % get the lines, not text
set(hL,'linewidth',2)            % set their width property

ylabel('Transpiration rate (mm/s)')
xlabel('Time of day (hour)')

xdk.PaperSize = [5,4];
xdk.PaperPosition = [0,0,5,4];
print('../figs/exp0','-dpdf')




