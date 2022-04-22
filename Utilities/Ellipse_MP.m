% Ellipse from particle distribution

function [twiss,Xe,pXe,Ye,pYe] = Ellipse_MP(x,px,y,py)

xm2 = mean(x.^2);
pxm2 = mean(px.^2);
xpxm = mean(x.*px);

ym2 = mean(y.^2);
pym2 = mean(py.^2);
ypym = mean(y.*py);

twiss.epsx = sqrt(xm2*pxm2 - xpxm^2);
twiss.epsy = sqrt(ym2*pym2 - ypym^2);

twiss.betax = xm2/twiss.epsx;
twiss.alfax = -xpxm/twiss.epsx;

twiss.betay = ym2/twiss.epsy;
twiss.alfay = -ypym/twiss.epsy;

% twiss.betax = std(x)^2/twiss.epsx;
% twiss.alfax = -nanstd(px)*sqrt(twiss.betax/twiss.epsx);
% 
% twiss.betay = std(y)^2/twiss.epsy;
% twiss.alfay = -nanstd(py)*sqrt(twiss.betay/twiss.epsy);


twiss.gammax = (1 + twiss.alfax^2)/twiss.betax;
twiss.gammay = (1 + twiss.alfay^2)/twiss.betay;


xe = linspace(-5*sqrt(twiss.epsx*twiss.betax),5*sqrt(twiss.epsx*twiss.betax),100);
pxe = linspace(-5*sqrt(twiss.epsx*twiss.gammax),5*sqrt(twiss.epsx*twiss.gammax),100);

ye = linspace(-5*sqrt(twiss.epsy*twiss.betay),5*sqrt(twiss.epsy*twiss.betay),100);
pye = linspace(-5*sqrt(twiss.epsy*twiss.gammay),5*sqrt(twiss.epsy*twiss.gammay),100);

[Xe,pXe] = meshgrid(xe,pxe);
[Ye,pYe] = meshgrid(ye,pye);

end
