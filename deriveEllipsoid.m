clear all

X = sym('x_', [1 3])        ; X = X.' ;
Lambda = sym('L_', [1 3])   ; Lambda = Lambda.' ;
V1 = sym('v1_', [1 3])      ; V1 = V1.' ;
V2 = sym('v2_', [1 3])      ; V2 = V2.' ;
V3 = sym('v3_', [1 3])      ; V3 = V3.' ;




 K_log = [  500.0000,       0,          0;
            0,              356.5980,   -143.4020;
            0,              -143.4020,  356.5980]
% K_log = [500,0,0; 0,500,0; 0,0,400];
% the largest eigenvalue represents the variance magnitude in 
% the direction of the largest spread of the data.
% The corresponding eigenvector represents the orientation
% 
% Ellipsoid1 = X.'*K_log*X == 738.5476^2;
Ellipsoid1 = X.'*K_log*X == 1;

[Vv,Ee] = eig(K_log)
identity = eye(3);
% Vvt = Vv.'
% xrot =  dot(Vv(:,1),identity(:,1)) / dot( sqrt( Vv(1,1)^2+Vv(1,1)^2+Vv(1,1)^2),sqrt(identity(1,1)^2+identity(1,1)^2+identity(1,1)^2) )
        
        
% [~,ind] = sort(diag(E));
% E = E(ind,ind)
% V = V(:,ind)
% lambda1 = E(1,1);
% lambda2 = E(2,2);
% lambda3 = E(3,3);
% 
% V1 = V(:,1);
% V2 = V(:,2);
% V3 = V(:,3);

% Ellipsoid2 = Lambda(1)*(V1.'*X)^2 + Lambda(2)*(V2.'*X)^2 + Lambda(3)*(V3.'*X)^2 ==1;
EllipsoidSyms = [ (V1.'*X)^2, (V2.'*X)^2, (V3.'*X)^2 ] * Lambda == 1;

Ellipsoid2 = subs( EllipsoidSyms,[V1,V2,V3,Lambda],[Vv,diag(Ee)] );
Ellipsoid3 = subs( Ellipsoid2,X,[0;X(2);X(3)] ) ;
solve(Ellipsoid3,X(3));

% EllipsoidNoRot

% Specify which equation to use
Ellipsoid = Ellipsoid1


oplossing_x = solve(Ellipsoid,X(1));
oplossing_y = solve(Ellipsoid,X(2));
oplossing_z = solve(Ellipsoid,X(3));
x_sol = solve(oplossing_x==0);
y_sol = solve(oplossing_y==0);
z_sol = solve(oplossing_z==0);

mF_x = matlabFunction(oplossing_x);
mF_y = matlabFunction(oplossing_y);
mF_z = matlabFunction(oplossing_z);


solutions = [   x_sol.x_2(1) x_sol.x_2(2);
                x_sol.x_3(1) x_sol.x_3(2);
                y_sol.x_1(1) y_sol.x_1(2);
                y_sol.x_3(1) y_sol.x_3(2);
                z_sol.x_1(1) z_sol.x_1(2);
                z_sol.x_2(1) z_sol.x_2(2)
            ]

%%%%%%%%%%%%%%%%Specify Intervasls and vectors%%%%%%%%%%%%%%%%
interval_x = [-1/sqrt(Ee(1,1)) 1/sqrt(Ee(1,1))]; % 0.0685
% interval_x = [x_sol.x_2(1) x_sol.x_2(2)]; % 0.0685
x_vec = linspace(interval_x(1),interval_x(2),1000);

interval_y = [-1/sqrt(Ee(2,2)) 1/sqrt(Ee(2,2))]; % 0.0447
% interval_y = []; % 0.0447
interval_y = [-0.06 0.06 ];
y_vec = linspace(interval_y(1),interval_y(2),1000);
% y_vec = linspace(-500,500,1000);
% y_vec = linspace(-5,5,1000);

interval_z = [-1/sqrt(Ee(3,3)) 1/sqrt(Ee(3,3))]; % 0.0447
% interval_y = []; % 0.0447
% z_vec = linspace(interval_z(1),interval_z(2),1000);
%%%%%%%%%%%%%%%%Specify Intervasls and vectors%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%Specify vector for plotting%%%%%%%%%%%%%%%%
% x_vec = mF_x(zeros(size(y_vec)),z_vec);
% y_vec = mF_y(zeros(size(x_vec)),z_vec);
z_vec = mF_z(zeros(size(x_vec)),y_vec);

%%%%%%%%%%%%%%%%Specify vector for plotting%%%%%%%%%%%%%%%%




figure
plot(y_vec,z_vec(1,:)); hold on
plot(y_vec,z_vec(2,:))
xlabel("y-axis")
ylabel("z-axis")

% for i = 1 : length(x_vec)
% x0=0;    
% z = oplossing_z(
% poep = oplossing_z(1)
% simplify(Ellipsoid)
% simplify(Ellipsoid2)

% XX = x^2 + y^2 ==1;
% figure
% fsurf(Ellipsoid2)


% magnitude = 1;
% magnitude = sqrt(E(1,1)^2 + E(2,2)^2 + E(3,3)^2)
% semiaxis a
% y2 = linspace(-sqrt(1/lambda2),sqrt(1/lambda2),1000);
% y2_2 = linspace(-500,500,1000);

% ellipsoid formula
% for i = 1:length(y2_2)
%     y1(i) = sqrt( (magnitude - lambda2*y2(i)^2)/lambda1 );
%     y1_neg(i) = -sqrt( (magnitude - lambda2*y2(i)^2)/lambda1 );

%     y1_2(i) = sqrt( (magnitude - (y2_2(i)/lambda2)^2)/(1/(lambda1^2)) );
%     y1_2_neg(i) = -sqrt( (magnitude - (y2_2(i)/lambda2)^2)/(1/(lambda1^2)) );
    
    
    % find vector from 0 to y1 AND 0 to y1neg
    % find angle betwee principal axis and eigenvector
    % transform y1 and y1_neg to new point.
%     sqrt(y1_2^2 +y2_2^2) * angle
    
    % met matrix algeBRUH
    % vind y1,y2,y3
    % Gebruik V om x,y,z te vinden
%     y1_log(i) = 
% end
% y1 = zeros( 1,(length(y1_2) + length(y1_2_neg)) );
% y3 = y1;
% y2 = y1;
% y1(1:length(y1_2)) = y1_2;
% y1(length(y1_2)+1:end) = y1_2_neg;
% y2(1:length(y1_2)) = y2_2;
% y2(length(y1_2)+1:end) = y2_2;
% Y = [y1;y2;y3];
% 
% Yrotated = V*Y;

%     y1 = y1 .*500
%     y1_neg = y1_neg .*500
% plot line

% (V(:,1)*x)^2 = y1^2
% X1 = 

% figure
% plot(y2,y1);hold on;
% plot(y2, y1_neg);

% figure
% plot(y2_2,y1_2);hold on;
% plot(y2_2, y1_2_neg);
% 
% figure
% plot(y2,y1);
% 
% figure
% plot(Yrotated(2,:),y1);
% 
% end

