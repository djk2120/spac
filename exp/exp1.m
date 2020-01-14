clear
close all
addpath ../model

xdk = figure('units','inches','Position',[2,2,8,6]);

for zr  = [1,0.5]
swp = -0.5;


out = zeros(30*24,2);
i = 0;

for dd = 1:30
    for hh = 6:0.5:17.5
        i = i+1;
        [q,lwp,fk] = getLWP(swp);
        swp       = bucket(swp,q,zr);
        
        out(i,1) = swp;
        out(i,2) = lwp;
        out(i,3) = q;
        out(i,4) = fk;
        
    end
end

xv = (1:30*24)/24;

subplot(2,2,1)
plot(xv,out(:,1),'LineWidth',1.5)
hold on
xlabel('Day')
ylabel('Soil potential (MPa)')
ylim([-2,0])

subplot(2,2,2)
plot(xv,out(:,2),'LineWidth',1.5)
hold on
xlabel('Day')
ylabel('Leaf potential (MPa)')

subplot(2,2,3)
plot(xv,out(:,3),'LineWidth',1.5)
hold on
xlabel('Day')
ylabel('Transpiration rate (mm/s)')

subplot(2,2,4)
plot(xv,out(:,4),'LineWidth',1.5)
hold on
xlabel('Day')
ylabel('k/kmax (-)')

end

subplot(2,2,1)
legend('Z_r = 1m','Z_r = 0.5m')


xdk.PaperSize = [8,5];
xdk.PaperPosition = [0,0,8,5];
print('../figs/exp1','-dpdf')
