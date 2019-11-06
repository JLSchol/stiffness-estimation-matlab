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
        
clear all
 K_log = [  500.0000,       0,          0;
            0,              356.5980,   -143.4020;
            0,              -143.4020,  356.5980]
% K_log = [500,0,0; 0,400,0; 0,0,400];
% the largest eigenvalue represents the variance magnitude in 
% the direction of the largest spread of the data.
% The corresponding eigenvector represents the orientation
[V,E] = eig(K_log)
[~,ind] = sort(diag(E));
E = E(ind,ind)
V = V(:,ind)

lambda1 = E(1,1);
lambda2 = E(2,2);
lambda3 = E(3,3);

magnitude = 1;
% magnitude = sqrt(E(1,1)^2 + E(2,2)^2 + E(3,3)^2)
% semiaxis a
% y2 = linspace(-sqrt(1/lambda2),sqrt(1/lambda2),1000);
y2_2 = linspace(-500,500,1000);

% ellipsoid formula
for i = 1:length(y2_2)
%     y1(i) = sqrt( (magnitude - lambda2*y2(i)^2)/lambda1 );
%     y1_neg(i) = -sqrt( (magnitude - lambda2*y2(i)^2)/lambda1 );

    y1_2(i) = sqrt( (magnitude - (y2_2(i)/lambda2)^2)/(1/(lambda1^2)) );
    y1_2_neg(i) = -sqrt( (magnitude - (y2_2(i)/lambda2)^2)/(1/(lambda1^2)) );
    
    
    % find vector from 0 to y1 AND 0 to y1neg
    % find angle betwee principal axis and eigenvector
    % transform y1 and y1_neg to new point.
%     sqrt(y1_2^2 +y2_2^2) * angle
    
    % met matrix algeBRUH
    % vind y1,y2,y3
    % Gebruik V om x,y,z te vinden
%     y1_log(i) = 
end
y1 = zeros( 1,(length(y1_2) + length(y1_2_neg)) );
y3 = y1;
y2 = y1;
y1(1:length(y1_2)) = y1_2;
y1(length(y1_2)+1:end) = y1_2_neg;
y2(1:length(y1_2)) = y2_2;
y2(length(y1_2)+1:end) = y2_2;
Y = [y1;y2;y3];

Yrotated = V*Y;

%     y1 = y1 .*500
%     y1_neg = y1_neg .*500
% plot line

% (V(:,1)*x)^2 = y1^2
% X1 = 

% figure
% plot(y2,y1);hold on;
% plot(y2, y1_neg);

figure
plot(y2_2,y1_2);hold on;
plot(y2_2, y1_2_neg);

figure
plot(y2,y1);

figure
plot(Yrotated(2,:),y1);

end

