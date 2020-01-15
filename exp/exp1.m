clear
close all
addpath ../model

xdk = figure('units','inches','Position',[-24,5,10,6]);



% this function gives a diurnal course of tmax
% with no stress it would produce 4.3mm/d transpiration
% x is the time of day from 0-24
pp = pi/(18-5.5);
tmax_max = 1.5e-4;
f  = @(x)max(0,tmax_max*sin((x-5.5)*pp));



zr  = 1;
swp0 = -0.3;
out = zeros(12*30,5,5);

j = 0;
for zr = 0.5:0.5:2.5
    j = j+1;
    i   = 0;
    swp = swp0;
    for dd = 1:30
        for hh = 5.5:0.5:18
            i = i+1;
            [q,lwp,fk] = getLWP(swp,f(hh),6e-5);
            [swp,sm] =   bucket(swp,q,zr);
            out(i,j,1) = q;
            out(i,j,2) = lwp;
            out(i,j,3) = 6e-5*fk;
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
legend('zr = 0.5m','zr = 1','zr = 1.5',...
    'zr = 2','zr = 2.5','Location','best')





xdk.PaperSize = [10,6];
xdk.PaperPosition = [0,0,10,6];

print('../figs/exp1','-dpdf')




