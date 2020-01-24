clear
close all
addpath ../model

xdk = figure('units','inches','Position',[-24,5,10,6]);





kmax.value      = nan(100,1);
kmax.units      = 'mm/s';
kmax.dimensions = {'ensemble member'};

zr.value      = nan(100,1);
zr.units      = 'm';
zr.dimensions = {'ensemble member'};

lwp_predawn.value      = nan(100,30);
lwp_predawn.units      = 'MPa';
lwp_predawn.dimensions = {'ensemble member','day'};

lwp_midday.value      = nan(100,30);
lwp_midday.units      = 'MPa';
lwp_midday.dimensions = {'ensemble member','day'};

k_midday.value      = nan(100,30);
k_midday.units      = 'mm/s';
k_midday.dimensions = {'ensemble member','day'};

transpiration.value      = nan(100,30);
transpiration.units      = 'mm/d';
transpiration.dimensions = {'ensemble member','day'};


swp0 = -0.3;
out = zeros(12*30,5,5);
hh = 5.5:0.5:18; % don't need to run the model at night
tmax_max = 1.5e-4; % midday unstressed tmax, results in about 4.3mm/d total T
tmax_oneday = tforc(tmax_max,hh);


j = 0;
kvals = (1:0.8:8.2)*10^-5;
zvals = 0.5:0.25:2.75;
qts   = tmax_oneday;
for km = kvals
for z   = zvals
    j = j+1;
    kmax.value(j) = km;
    zr.value(j) = km;
    swp = swp0;
    for dd = 1:30
        i   = 0;
        for tmax = tmax_oneday
            i = i+1;
            [q,lwp,fk] = getLWP(swp,tmax,km);
            [swp,sm] =   bucket(swp,q,z);
            qts(i) = q;
            if i==1
                %predawn
                lwp_predawn.value(j,dd) = lwp;
            elseif i==13
                %midday
                lwp_midday.value(j,dd)  = lwp;
                k_midday.value(j,dd)    = fk*km;
            end
        end
        transpiration.value(j,dd) = 1800*sum(qts);
    end
end
end


var_list = {'kmax','zr','lwp_predawn','lwp_midday',...,
    'k_midday','transpiration'};
save('exp3','kmax','zr','lwp_predawn','lwp_midday',...,
    'k_midday','transpiration')
    



