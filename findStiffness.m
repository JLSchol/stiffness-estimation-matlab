function [K_eig] = findStiffnessEig(Eigen_values, k_min, k_max, L_min, L_max)
%[K] = findStiffness(E, k_min, k_max, L_min, L_max)
%   Detailed explanation goes here

% std=sqrt(eigvalue): standard deviation of the date is sqrt of eigenvalue
lambdas = diag(sqrt(Eigen_values)); % take square root? 
Kvec = zeros(3,1);
for i = 1 : 3
    
    L = lambdas(i);
    
    if L <= L_min
        k = k_max;
    elseif (L > L_min && L < L_max)
        k = k_max - (k_max - k_min)/(L_max - L_min) * (L - L_min);
    elseif L >= L_max
        k = k_min;
    else
        Disp("ging wat mis")
    end
   
    Kvec(i) = k;
    
end

K = diag(Kvec);

end

