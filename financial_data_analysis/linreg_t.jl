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
# the trick is we need vector Float64 in Diagonal function, but rand(T,1) generates Matrix
lam = rand(InverseGamma(nu/2,nu/2),T);
iLam = Diagonal(ones(T)./lam);

store_theta = zeros(nsim,5);

count_nu = 0;

for isim in 1:(nsim+burnin)
    # sample beta
    Dbeta = iVbeta0 + X'*iLam*X/sig2;
    beta_hat = Dbeta\(iVbeta0*beta0 + X'*iLam*y/sig2);
    C = cholesky(Hermitian(Dbeta)).L;
    beta = beta_hat + C'\rand(Normal(0,1),3);

    # sample lam
    e = y - X*beta;
    lam = rand(InverseGamma((nu+1)/2,(nu+e.^2 ./sig2)));
    iLam = sparsevec(Diagonal(ones(T)./lam));

    # sample sig2
    sig2 = rand(InverseGamma(nu0+T/2,S0 + e'*iLam*e ./2));

    # sample nu
    nu,flag = sample_nu_MH(lam,nu,nu_ub);

    