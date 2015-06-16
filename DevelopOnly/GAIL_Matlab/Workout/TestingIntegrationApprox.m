% testing different routines for integration approximation
format compact

%% Test Functions
%f=@(x) x; exactinteg=1/2;
f=@(x) x.*x; exactinteg=1/3;

%% Integration routines
integ1=integral (f,0,1); err1 = abs(exactinteg-integ1) % matlab built-in
integ2=integral_g (f,0,1,1e-12); err2 = abs(exactinteg-integ2) % gail routine
integ3=integralNoPenalty_g (f,0,1,1e-12); err3 = abs(exactinteg-integ3) % fred's routine
fcheb = chebfun(f,[0 1]); integ4=sum(fcheb); err4 = abs(exactinteg-integ4) % chebfun routine

%% Function Approx routines
xtest=sort(rand(1e6,1));
ftest=f(xtest);
f1=funappxglobal_g (f,0,1,1e-12); errf1 = max(abs(ftest-ppval(f1,xtest))) % gail routine
