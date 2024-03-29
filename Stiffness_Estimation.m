% Stiffness estimation
clear; clc; close all 

% Initialize trajectories
trajectory_length = 3000; %mm
amplitude = [0, 7, 17, 27, 40, 0];
freq = [5, 5, 5, 5, 5, 5];
freq2 = [3, 3, 3, 3, 3, 3];
start = [1, 500, 1000, 1500, 2000, 2500];

% Sliding window
window_length = 300;

% min/max allowed wiggle
w_min = 7.3;
w_max = 35.5;

% Stiffness learning parameters
k_min = 100;
k_max = 500;
L_min = 0.6956*w_min; % ongeveer 5
L_max = 0.6956*w_max; % ongeveer 25
% L_min = 5; % 5 =0.6956*w_min = 7.3;
% L_max = 25; % 25 =0.6956*w_min = 35.5;

% for a = 1 : 3

% Equilibrium trajectory ~ trajectory impedance controller wants to reach
x_eq = 1:1:trajectory_length;
y_eq = zeros(1,trajectory_length);
z_eq = ones(1,trajectory_length);
X_eq = [x_eq;y_eq;z_eq];

% Virtual (perturbation) trajectory ~ virtual point perturbed around EE
x_v = x_eq; % zeros
y_v = y_eq; % zeros
% z_v = amp(a) * sin(12*pi * x_eq/trajectory_length) - 10;
z_v = x_eq;
p_v = x_eq; % zeros
% y_v = x_eq;
for s = 1 : length(amplitude)
    p_v = makeSinus(p_v,amplitude(s),freq(s),start(s),(start(s)+500));
%     z_v = makeSinus(z_v,amplitude(s),freq(s),start(s),(start(s)+500));
%     y_v = makeSinus(y_v,amplitude(s),freq2(s),start(s),(start(s)+500));
end
theta = pi/4;
y_v = p_v .* cos(theta)
z_v = p_v .* sin(theta)

X_v = [x_v;y_v;z_v];


% Actual trajectory ~ The actual measuremetns from the robot encoder
noise = randn(3,trajectory_length)*0; %[min; max] ~ [-15; 15]
EE_Force = [0;0;-10];
Stiffness = [20, 0, 0;   0, 20, 0;   0, 0, 20];
difference_with_equilibrium = Stiffness \ EE_Force;

X_a = X_eq + noise + difference_with_equilibrium;

% bandpas filter on actual trajectory



% error signal?
% This should be either:
% equilibrium - actual
% equilibrium - virtual <-- I think this one?
% equilibrium - virtual + (equilibrium - actual) 
% actual - virtual + (equilibrium - virtual)
error_signal = X_eq - X_v;


% Stiffness learning
covariance_log = zeros(3,3,trajectory_length);
E_log = covariance_log;
V_log = E_log;
K_eig_log = V_log;
K_log = K_eig_log;
for i = 1:trajectory_length
    if (i <= window_length)
        data_in_window = error_signal(:,1:1:i);
    elseif (i > window_length)
        data_in_window = error_signal( :, (i-window_length + 1):1:i );
    end
    
    covariance_t = findCovariance(data_in_window);
    
    
    % V*E*V' = cov
    % V coloms are corresponding right eigenvecotrs
    % largest eigenvector points in the cirection of the largest variance
    % eigenvector
    [V,E] = eig(covariance_t); 

    % Find  matrix
    K_eig = findStiffnessEig(E,k_min,k_max,L_min,L_max);
    
    K = V*K_eig*V.';
    
    
    covariance_log(:,:,i) = covariance_t;
    V_log(:,:,i) = V;
    E_log(:,:,i) = E;
    K_eig_log(:,:,i) = K_eig;
    K_log(:,:,i) = K;
    
end

covlog = zeros(trajectory_length,1);
covlog2 = covlog;
Vlog = covlog;
Elog = Vlog;
Keiglog = Elog;
Keiglog2 = Elog;

for ii = 1 : trajectory_length
    covlog(ii) = covariance_log(3,3,ii);
    covlog2(ii) = covariance_log(2,2,ii);
    Keiglog(ii) = K_eig_log(3,3,ii);
    Keiglog2(ii) = K_eig_log(2,2,ii);
%     dat4(ii) = covariance_log_matlab(3,3,ii);
end



% end

% data_in_window = error_signal[:,(i:window_length)];
% mu = 1/window_length * sum(data_in_window);
% 
% covariance = 1/window_length * sum


%% trajectory covariance
figure
subplot(2,1,1)
% plot(X_v(3,:),'LineWidth',2)
% scatter3(X_v(1,:),X_v(2,:),X_v(3,:));hold on;
plot(X_v(3,:),'LineWidth',2); hold on;
% scatter3(X_eq(1,:),X_eq(2,:),X_eq(3,:)); 
plot(X_eq(3,:),'LineWidth',2); 
offset = (w_min + w_max)/2;
yline(w_min,'--k');
yline(w_max,'--k');
yline(-w_min,'--k');
yline(-w_max,'--k');
% line([X_v(1,1),X_v(1,end)],[L_max,L_min],'k')
% line([X_v(1,1),X_v(1,end)],[L_max,L_max],'k')
hold off
% scatter3(X_a(1,:),X_a(2,:),X_a(3,:));
title("Trajectories")
xlabel("x position [mm]")
ylabel("z position [mm]")
legend("virtual perturbations","manipulator trajectory","min/max allowed perturbation",'location','best')

subplot(2,1,2)

plot(Keiglog,'LineWidth',2);hold on
plot(covlog,'LineWidth',2);
yline(k_min,'--k');
yline(k_max,'--k');
% line([covlog(1),covlog(1)],[k_min,k_min],'k')
% line([covlog(1),covlog(1)],[k_max,k_max],'k')
hold off
title("Robot-manipulator stiffness")
xlabel("x position [mm]")
ylabel("Stiffness [N/m]")
ylim([0,600])
legend("Stiffness", "min/max allowed stiffness",'location','best')
% legend("(co-)variance","Stiffness", "min/max allowed stiffness",'location','best')

%%
figure
subplot(2,1,1)
plot(X_v(2,:),'LineWidth',2)
% scatter3(X_v(1,:),X_v(2,:),X_v(3,:));hold on;
plot(X_v(2,:),'LineWidth',2); hold on;
% scatter3(X_eq(1,:),X_eq(2,:),X_eq(3,:)); 
plot(X_eq(3,:),'LineWidth',2); 
% offset = (w_min + w_max)/2;
yline(w_min,'--k');
yline(w_max,'--k');
yline(-w_min,'--k');
yline(-w_max,'--k');
% line([X_v(1,1),X_v(1,end)],[L_max,L_min],'k')
% line([X_v(1,1),X_v(1,end)],[L_max,L_max],'k')
hold off
% scatter3(X_a(1,:),X_a(2,:),X_a(3,:));
title("Trajectories")
xlabel("x position [mm]")
ylabel("y position [mm]")
legend("virtual perturbations","manipulator trajectory","min/max allowed perturbation",'location','best')

subplot(2,1,2)
% plot(covlog,'LineWidth',2)
plot(Keiglog2,'LineWidth',2);hold on
plot(covlog2,'LineWidth',2);
yline(k_min,'--k');
yline(k_max,'--k');

% line([covlog(1),covlog(1)],[k_min,k_min],'k')
% line([covlog(1),covlog(1)],[k_max,k_max],'k')
hold off
title("Robot-manipulator stiffness")
xlabel("x position [mm]")
ylabel("Stiffness [N/m]")
ylim([0,600])
legend("Stiffness", "min/max allowed stiffness",'location','best')
% legend("(co-)variance","Stiffness", "min/max allowed stiffness",'location','best')
%% Surfaceplot 
% surfplot = figure;
% [xx,yy,zz] = ellipsoid(0,0,0,K_log(1,1,100), K_log(2,2,100), K_log(3,3,100));
% [xx2,yy2,zz2] = ellipsoid(600,0,0,K_log(1,1,600), K_log(2,2,600), K_log(3,3,600));
% [xx3,yy3,zz3] = ellipsoid(1100,0,0,K_log(1,1,1100), K_log(2,2,1100), K_log(3,3,1100));
% [xx4,yy4,zz4] = ellipsoid(1600,0,0,K_log(1,1,1600), K_log(2,2,1600), K_log(3,3,1600));
% [xx5,yy5,zz5] = ellipsoid(2100,0,0,K_log(1,1,2100), K_log(2,2,2100), K_log(3,3,2100));
% [xx6,yy6,zz6] = ellipsoid(2600,0,0,K_log(1,1,2600), K_log(2,2,2600), K_log(3,3,2600));
% 
% % surf(xx,yy,zz); hold on
% surf(xx2,yy2,zz2);  hold on
% % surf(xx3,yy3,zz3);
% surf(xx4,yy4,zz4);
% % surf(xx5,yy5,zz5);
% surf(xx6,yy6,zz6);
% axis([-500 4000 -1000 1000 -1000 1000])


