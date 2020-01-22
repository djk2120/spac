clear
close all
addpath ../model

xdk = figure('units','inches','Position',[-24,5,10,6]);




swp0 = -0.3;
out = zeros(12*30,5,5);
hh = 5.5:0.5:18; % don't need to run the model at night
tmax_max = 1.5e-4; % midday unstressed tmax, results in about 4.3mm/d total T
tmax_oneday = tforc(tmax_max,hh);

zr   = 1;
j = 0;
kvals = (1:0.8:8.2)*10^-5;
zvals = 0.5:0.25:2.75;

for kmax = kvals
for zr   = zvals
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
end

%compute daily transpiration
g = repmat(1:30,[26,1]);
g = g(:);
q_daily = 30*60*splitapply(@sum,out(:,:,4),g);

ix = 14:26:length(out(:,1));  %midday
colors = jet;
colors = flipud(colors(1:7:64,:));



if 1==1
    for i = 1:10
        subplot(3,4,i)
        set(gca,'ColorOrder',colors);
        hold on
        plot(out(ix,(1:10)+(i-1)*10,2))
        %plot(out(ix,(1:10:100)+i-1,2))
        xlim([0,30])
        ylim([-4,-2])
        title(['k_{max} = ',num2str(kvals(i)),' mm/s'])
    end
    
    for i = [1,5,9]
        subplot(3,4,i)
        ylabel('\Psi_L (MPa)')
    end
    for i = 9:10
        subplot(3,4,i)
        xlabel('Day')
    end
    
    
    
    ll = cell(10,1);
    for i = 1:10
        ll(i) = {['Zr = ',num2str(zvals(i)),'m']};
    end
    
    %dummy plot for legend
    subplot(3,4,12)
    set(gca,'ColorOrder',colors);
    hold on
    plot(-inf+out(ix,:,1))
    xlim([0,30])
    ylim([0,1])
    [~,hObj] = legend(ll,'Location','best');
    hL=findobj(hObj,'type','line');  % get the lines, not text
    set(hL,'linewidth',3)            % set their width property
    set(gca,'visible','off')
    
    xdk.PaperSize = [10,6];
    xdk.PaperPosition = [0,0,10,6];
    
    print('../figs/exp3a','-dpdf')
    
end




if 1==2
    for i = 1:10
        subplot(3,4,i)
        set(gca,'ColorOrder',colors);
        hold on
        %plot(out(ix,(1:10)+(i-1)*10,2))
        plot(out(ix,(1:10:100)+i-1,2))
        xlim([0,30])
        ylim([-4,0])
        title(['Z_r = ',num2str(zvals(i)),' m'])
    end
    
    for i = [1,5,9]
        subplot(3,4,i)
        ylabel('\Psi_{diff} (MPa)')
    end
    for i = 9:10
        subplot(3,4,i)
        xlabel('Day')
    end
    
    
    
    ll = cell(10,1);
    for i = 1:10
        ll(i) = {['kmax = ',num2str(kvals(i)),'mm/s']};
    end
    
    %dummy plot for legend
    subplot(3,4,12)
    set(gca,'ColorOrder',colors);
    hold on
    plot(-inf+out(ix,:,1))
    xlim([0,30])
    ylim([0,1])
    [~,hObj] = legend(ll,'Location','best');
    hL=findobj(hObj,'type','line');  % get the lines, not text
    set(hL,'linewidth',3)            % set their width property
    set(gca,'visible','off')
    
    xdk.PaperSize = [10,6];
    xdk.PaperPosition = [0,0,10,6];
    
    print('../figs/exp3b','-dpdf')
    
end
