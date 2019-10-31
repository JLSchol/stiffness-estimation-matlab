function [covariance_matrix] = findCovariance(X)
%[covariance_matrix] = findCovariance(X)
%   X needs to be a matrix wheree the rows represent the time trace and the
%   columns the x,y,z coordinates
%   covariance = 1/M * Sum[(x_t-mu)(x_t-mu).']
%   mu = 1/M * sum(x_t)

% X=[2 -1 0;-1 2 -1; 0 -1 2];

m_observations = length(X(1,:)); 

mu = 1/m_observations * sum(X,2); % sum over rows
A = zeros(3);
for i = 1 : m_observations
    A_i = (X(:,i) - mu) * (X(:,i) - mu).';
    A = A + A_i;  
end

if m_observations == 1
    nn = 0;
else
    nn = 1;
end
covariance_matrix = A/(m_observations-nn);



% 
% A = (A1 + A2 + A3 + A4 + A5)/4
% A(1,3)
% 
% A2 = cov(X.')
end

