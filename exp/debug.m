
clear
addpath ../model

swp = -1.96;
[q,lwp,out] = getLWP(swp);


hold off
plot(out(:,1))