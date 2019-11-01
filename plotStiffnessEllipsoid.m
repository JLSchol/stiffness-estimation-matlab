% Stiffness elipsoid animation
function plotEllipsoid(K_log,flag)


switch flag
    case 'animation'
        disp('doedingen')
    case 'single'
        disp('doedingen')
    case 'x'
        plotAxis1 = 'x';
    case 'y'
        plotAxis1 = 'y';
    case 'z'
        plotAxis1 = 'z';   
    case 'xy'
        plotAxis2 = 'xy';
    case 'yz'
        plotAxis2 = 'yz';
    case 'xz'
        plotAxis2 = 'xz';
        
    otherwise 
        warning('Unexpected plot type. No plot created.')
        
        
K_log = [500,0,0; 0,500,0; 0,0,400];
[V,E] = eig(K_log)

lambda1 = E(1,1)
lambda2 = E(2,2)
magnitude = 1
y2 = linspace(-sqrt(1/lambda2),sqrt(1/lambda2),1000)
% ellipsoid formula
for i = 1:length(y2)
    y1(i) = sqrt( (magnitude - lambda2*y2(i)^2)/lambda1 );
end
for i = 1:length(y2)
    y1_neg(i) = -sqrt( (magnitude - lambda2*y2(i)^2)/lambda1 );
end
% plot line
figure
plot(y2,y1);hold on;
plot(y2, y1_neg);

end

