using Distributions,LinearAlgebra,Plots,CSV,DataFrames,SparseArrays,SpecialFunctions

nsim,burnin = 20000,1000;

data_raw = DataFrame(CSV.File("USPCE_2015Q4.csv"))|>Tables.matrix
#data_raw = data_raw[2:end,:] ./data_raw[1:end-1,:];
data = 400 .*log.(data_raw[2:end,:] ./data_raw[1:end-1,:]);

y0 = data[1:2,:];
y = data[3:end,:];
T = size(y,1);
X = [ones(T,1) [y0[2];y[1:end-1,:]] [y0[1];y0[2];y[1:end-2,:]]];

# prior
beta0 = zeros(3,1);iVbeta0 = sparse(I,2,2)/100;
rho0 = 0; iVrho0 = 1; 
nu0 = 3; S0 = 1*(nu0-1);
nu_ub = 50;

nu = 5; 
beta = (X'*X)\(X'*y);
sig2 = sum((y-X*beta).^2)/T;
lam = rand(InverseGamma(nu/2,nu/2),T,1);
iLam = diagm(ones(T,1)./lam);