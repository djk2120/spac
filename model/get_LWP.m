function [t,lwp] = get_LWP(swp)

% t    = transpiration         (mm/s)
% lwp  = leaf water potential  (MPa)
% swp  = soil water potential  (MPA)


% setting up some parameter values
tmax = 1e-4;    %mm/s
kmax = 5e-5;    %mm/(MPA*s)
p1 = -1.5;      %MPa
p2 = -3;        %MPa       
p3 = -2;        %MPa
p4 = -4;        %MPa




%Solve for LWP by stepping forward starting at SWP
lwp = swp;
i = 0;
step = 0.5;
go = 1;
out = zeros(20,1);
while go
i = i+1;
lwp = lwp-step;


fk = (0.5*(lwp+swp)-p2)/(p1-p2);
fk = min(max(fk,0),1);     %fk is bound by [0,1]
q  = -kmax*fk*(lwp-swp);

ft = (lwp-p4)/(p3-p4);
ft = min(max(ft,0),1);     %ft is bound by [0,1]
t  = tmax*ft;

out(i,1) = lwp;   %for debugging purposes
out(i,2) = q;
out(i,3) = t;


if abs(q-t)<5e-9
    %satisfactory solution
    go = 0;
elseif i>29
    %solution not found in time, throw error
    lwp = nan;
    disp('ERROR: No LWP solution in 30 steps')
    disp('Need to debug.')
    disp('Re-examine parameter values.')
    go = 0;
elseif q>t
    %we've gone past the solution, reduce step size
    lwp = lwp+step;
    step = step/2.5;
end

end

end



