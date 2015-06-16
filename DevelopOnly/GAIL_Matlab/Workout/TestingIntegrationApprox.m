%% Testing different routines for integration and function approximation

%% Initialization
format compact
close all %close all figures
clearvars %clear all variables
set(0,'defaultaxesfontsize',24,'defaulttextfontsize',24) %make font larger
set(0,'defaultLineLineWidth',3) %thick lines
set(0,'defaultTextInterpreter','latex') %latex axis labels
set(0,'defaultLegendInterpreter','latex') %latex axis labels

%% Test Functions
% These are some test functions that we use to demonstrate the strengths
% and the weaknesses of the integration and function approximation
% routines.

%f=@(x) x; exactinteg=1/2;
%f=@(x) x.*x; exactinteg=1/3;
peaky=@(x,t,h) exp(-((x-t)/h).^2)/(0.5*sqrt(pi)*(erf((1-t)/h)+erf(t/h))); 
   %Gaussian peak
f = @(x) peaky(x,1/2,1); exactinteg = 1;
xplot = 0:0.002:1;
plot(xplot,f(xplot),'-','linewidth',3)
xlabel('$x$')
ylabel('$f(x)$')


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
% justification. See N. Clancy, Y. Ding, C. Hamilton, F. J. Hickernell, and
% Y. Zhang, The cost of deterministic, adaptive, automatic algorithms:
% Cones, not balls, _Journal of Complexity_, *30*, 2014, pp. 21-45.

integ2=integral_g (f,0,1,1e-12); err2 = abs(exactinteg-integ2) % gail routine

%%
% The third method is an improvement on the GAIL routine, which was
% proposed by F.J. Hickernell, M. Razo, and S. Yun, Reliable Adaptive
% Numerical Integration, 2015, submitted for publication.

integ3=integralNoPenalty_g (f,0,1,1e-12); err3 = abs(exactinteg-integ3) % fred's routine

%%
% The fourth method is the Chebfun MATLAB toolbox. http://www.chebfun.org/

fcheb = chebfun(f,[0 1]); integ4=sum(fcheb); err4 = abs(exactinteg-integ4) % chebfun routine

%% Function Approx routines
xtest=sort(rand(1e6,1));
ftest=f(xtest);
f1=funappxglobal_g (f,0,1,1e-12); errf1 = max(abs(ftest-ppval(f1,xtest))) % gail routine
