%% Testing different routines for integration and function approximation

%% Initialization
format compact

%% Test Functions
% These are some test functions that we use to demonstrate the strengths
% and the weaknesses of the integration and function approximation
% routines.

%f=@(x) x; exactinteg=1/2;
f=@(x) x.*x; exactinteg=1/3;

%% Integration routines
% Let's integrate the test function, i.e., we will compute
%
% \[ \int_0^1 f(x) \, {\rm d} x. \]
%
% The first method is MATLAB's built-in integration routine, which is based
% on L. F. Shampine, Vectorized Adaptive Quadrature in MATLAB, _Journal of
% Computational and Applied Mathematics_, *211*, 2008, pp. 131-140.

integ1=integral (f,0,1); err1 = abs(exactinteg-integ1) % matlab built-in

%%
% The second method is the GAIL routine that has a theoretical
% justification

integ2=integral_g (f,0,1,1e-12); err2 = abs(exactinteg-integ2) % gail routine
%%
% The third method is an improvement on the GAIL routine, which was
% proposed by

integ3=integralNoPenalty_g (f,0,1,1e-12); err3 = abs(exactinteg-integ3) % fred's routine

%%
% The fourth method is the Chebfun MATLAB toolbox

fcheb = chebfun(f,[0 1]); integ4=sum(fcheb); err4 = abs(exactinteg-integ4) % chebfun routine

%% Function Approx routines
xtest=sort(rand(1e6,1));
ftest=f(xtest);
f1=funappxglobal_g (f,0,1,1e-12); errf1 = max(abs(ftest-ppval(f1,xtest))) % gail routine
