using Distributions,LinearAlgebra,Plots,LaTeXStrings

nsim,burnin = 10000,1000;

# generate data
T = 500; # sample size
beta = [1 5]'; sig2 = .5;
X = [ones(T,1) 1 .+ randn(T,1)];
y = X*beta + sqrt(sig2)*rand(Normal(0,1),T,1);

# prior Setup
beta0 = [0 0]'; iVbeta0 = I(2)/100;
nu0 = 3; S0 = 1*(nu0-1);

# initialize the Markov Chain
beta = (X'*X)\(X'*y);
sig2 = sum((y-X*beta).^2)/T;
store_theta = zeros(nsim,3);

@time for ii in 1:(nsim+burnin)
    # sample beta
    Dbeta = (iVbeta0+X'*X/sig2);
    beta_hat = Dbeta\(iVbeta0*beta0 + X'*y/sig2);
    C = cholesky(Hermitian(Dbeta)).L;
    beta = beta_hat + C'\rand(Normal(0,1),2);

    # sample sig2
    e = y - X*beta;
    sig2 = rand(InverseGamma(nu0+T/2,(S0+sum(e.^2)/2)));

    if ii > burnin
        jj = ii - burnin;
        store_theta[jj,:] = [beta' sig2];
    end
end