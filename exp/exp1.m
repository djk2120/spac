clear
addpath ../model

hold off

for zr  = [0.5,1]
swp = -0.5;


out = zeros(30*24,2);
i = 0;

for dd = 1:30
    for hh = 6:0.5:17.5
        i = i+1;
        [q,lwp] = getLWP(swp);
        swp     = bucket(swp,q,zr);
        
        out(i,1) = swp;
        out(i,2) = lwp;
        out(i,3) = q;
        
    end
end

xv = (1:30*24)/24;

plot(xv,out(:,3),'.')
hold on
end
xlabel('Day')
ylabel('LWP (MPa)')