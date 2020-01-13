clear
close all

tmax = 1e-4;    %mm/s
kmax = 6.5e-5;  %mm/(MPA*s)
p1 = -1;
p2 = -3;
p3 = -1;
p4 = -3;


swp = -0.5;
i = 0;

out = zeros(10,2);
for lwp = 0:-0.05:-4
i = i+1;

fk = (0.5*(lwp+swp)-p2)/(p1-p2);
fk = min(max(fk,0),1);     %fk is bound by [0,1]
q  = -kmax*fk*(lwp-swp);    %mm/s

ft = (lwp-p4)/(p3-p4);
ft = min(max(ft,0),1);     %ft is bound by [0,1]
t  = tmax*ft;

out(i,1) = q;
out(i,2) = t;

end


xdk = figure;
xdk.Units = 'inches';
xdk.Position = [-10.3333    6.2361    5    4];
xdk.PaperSize = [5,4];
xdk.PaperPosition  = [0,0,5,4];



plot(0:-0.05:-4,out,'LineWidth',2)
xlim([-4,0])
ylim([0,1.1e-4])
xlabel('Leaf Water Potential (MPa)')
ylabel('Water flux (mm/s)')
legend('Water supply','Water demand','Location','Southwest')

print('../figs/spac_solution','-dpdf')




