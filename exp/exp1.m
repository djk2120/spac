clear
close all
addpath ../model

xdk = figure('units','inches','Position',[-24,5,10,6]);



% this function gives a diurnal course of tmax
% with no stress it would produce 4.3mm/d transpiration
% x is the time of day from 0-24
pp = pi/(18-5.5);

f  = @(x)max(0,tmax_max*sin((x-5.5)*pp));



zr  = 1;
swp0 = -0.3;
out = zeros(12*30,5,5);
hh = 5.5:0.5:18; % don't need to run the model at night
tmax_max = 1.5e-4; % midday unstressed tmax, results in about 4.3mm/d total T
tmax_oneday = tforc(tmax_max,hh);
kmax = 6e-5;
j = 0;
for zr = 0.5:0.25:2.75
    j = j+1;
    i   = 0;
    swp = swp0;
    for dd = 1:30
        for tmax = tmax_oneday
            i = i+1;
            [q,lwp,fk] = getLWP(swp,tmax,kmax);
            [swp,sm] =   bucket(swp,q,zr);
            out(i,j,1) = q;
            out(i,j,2) = lwp;
            out(i,j,3) = kmax*fk;
            out(i,j,4) = swp;
            out(i,j,5) = sm;
        end
    end
end

%compute daily transpiration
g = repmat(1:30,[26,1]);
g = g(:);
q = out(:,:,1);

q_daily = 30*60*splitapply(@sum,q,g);


ix = 14:26:length(out(:,1));  %midday


colors = jet;
colors = colors(1:7:64,:);

for i = 1:6
    subplot(2,3,i)
    set(gca,'ColorOrder',colors);
    hold on
end

subplot(2,3,1)
plot(out(ix,:,4))
ylabel('Soil potential (MPa)')
xlabel('Day')

subplot(2,3,3)
plot(out(ix,:,5))
ylabel('Soil water content (m3/m3)')
xlabel('Day')

subplot(2,3,2)
plot(out(ix,:,2))
ylabel('Midday leaf potential (MPa)')
xlabel('Day')

subplot(2,3,6)
plot(q_daily)
ylabel('Transpiration (mm/d)')
xlabel('Day')


subplot(2,3,4)
plot(out(ix,:,3))
ylabel('Midday k (mm/s/MPa)')
xlabel('Day')


subplot(2,3,5)
plot(-10+out(ix,:,1))
xlim([0,30])
ylim([0,1])

ll = cell(10,1);
for i = 1:10
    ll(i) = {['zr = ',num2str(0.25+i*0.25),'m']};
end

[~,hObj] = legend(ll,'Location','best');
hL=findobj(hObj,'type','line');  % get the lines, not text
set(hL,'linewidth',3)            % set their width property
set(gca,'visible','off')




xdk.PaperSize = [10,6];
xdk.PaperPosition = [0,0,10,6];

print('../figs/exp1','-dpdf')




