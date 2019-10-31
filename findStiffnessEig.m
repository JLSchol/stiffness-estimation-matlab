function [K_eig] = findStiffnessEig(Eigen_values, k_min, k_max, L_min, L_max)
%[K] = findStiffness(E, k_min, k_max, L_min, L_max)
%   This function sets the stiffneess inversely proportional to the eigenv
%   Eigen_values = eigenvalues of covariance matrix (3x3)
%   K = stiffness diagonal eigenvalues (3x3)
%   k = stiffness boudaries (tune parameters)
%   L = boundaries of standard deviation allowed of the data along each 
%   of the eigenvectors (tune parameters)
%   Therefore, this determines the min and maximal allowed wiggle 
%   (perturbation)
%   

% std=sqrt(eigvalue): standard deviation of the date is sqrt of eigenvalue
lambdas = diag(sqrt(Eigen_values)); 
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

K_eig = diag(Kvec);

end

