%% Testing different routines for integration and function approximation

%% Initialization
format compact
close all %close all figures
clearvars %clear all variables
set(0,'defaultaxesfontsize',24,'defaulttextfontsize',24) %make font larger
set(0,'defaultLineLineWidth',3) %thick lines

%% Test Functions
% These are some test functions that we use to demonstrate the strengths
% and the weaknesses of the integration and function approximation
% routines.

%f=@(x) x; exactinteg=1/2;
%f=@(x) x.*x; exactinteg=1/3;
peaky=@(x,t,h) exp(-((x-t)/h).^2)/(0.5*h*sqrt(pi)*(erf((1-t)/h)+erf(t/h))); 

%%
% This is a Gaussian peak, where |t| is the center and |h| is the width.  It
% is defined so that the integral is always 1.

f = @(x) peaky(x,0.5,0.2); exactinteg = 1;

%% Messing with t and h

hvec=[0.2 0.02 0.002 0.0002]
nh=numel(hvec)
tvec=0:0.1:1;
nt=numel(tvec)
integ1=zeros(nh,nt); %initializing the vectors to the correct size
time1=integ1;
integ2=integ1;
time2=integ1;
integ3=integ1;
time3=integ1;
Npoints3=integ1;
integ4=integ1;
time4=integ1;
Npoints4=integ1;
abstol=1e-10;
in.a=0; in.b=1; in.abstol = abstol; 
%in.nlo=1000; %more robust
in.nmax=1e8; %maximum cost budget
for jj = 1:nt
    t = tvec(jj);
    for ii=1:nh
        h=hvec(ii);
        f=@(x) peaky(x,t,h);
        tic, integ1(ii,jj)=integral(f,0,1); time1(ii,jj)=toc;
        tic, fcheb = chebfun(f,[0 1]); integ2(ii,jj)=sum(fcheb); time2(ii,jj)=toc;     
        tic, [integ3(ii,jj),out]=integral_g (f,in); time3(ii,jj)=toc;
        Npoints3(ii,jj)=out.npoints;
        tic, [integ4(ii,jj),out]=integralNoPenalty_g (f,in); time4(ii,jj)=toc;
        Npoints4(ii,jj)=out.npoints;
    end
end
err1=abs(exactinteg-integ1)
err2=abs(exactinteg-integ2)
err3=abs(exactinteg-integ3)
err4=abs(exactinteg-integ4)
time1
time2
time3
time4
Npoints3
Npoints4
save(['TestingIntegrationApproxResults_Nmax' int2str(out.nmax) ...
    'Nlo' int2str(out.nlo)])
break
    
%% Plot the test function
xplot = 0:0.002:1;
plot(xplot,f(xplot),'-')
xlabel('\(x\)','Interpreter','latex'); 
ylabel('\(f(x)\)','Interpreter','latex')

%% Integration Routines
% Let's integrate the test function, i.e., we will compute
%
% \[ \int_0^1 f(x) \, {\rm d} x. \]
%
% The first method is MATLAB's built-in integration routine, which is based
% on L. F. Shampine, Vectorized Adaptive Quadrature in MATLAB, _Journal of
% Computational and Applied Mathematics_, *211*, 2008, pp. 131-140.

tic, integ1=integral (f,0,1); toc
err1 = abs(exactinteg-integ1)

%%
% The second method is the Chebfun MATLAB toolbox, http://www.chebfun.org.
% Chebfun gives you a way to treat functions as you normally would treat
% numbers in MATLAB.

tic, fcheb = chebfun(f,[0 1]); integ2=sum(fcheb); toc
err2 = abs(exactinteg-integ2) 


%%
% The third method is the GAIL routine that has a theoretical
% justification. See N. Clancy, Y. Ding, C. Hamilton, F. J. Hickernell, and
% Y. Zhang, The cost of deterministic, adaptive, automatic algorithms:
% Cones, not balls, _Journal of Complexity_, *30*, 2014, pp. 21-45.

abstol = 1e-10;
tic, integ3=integral_g (f,0,1,abstol); toc 
err3 = abs(exactinteg-integ3) 

%%
% The fourth method is an improvement on the GAIL routine, which was
% proposed by F. J. Hickernell, M. Razo, and S. Yun, Reliable Adaptive
% Numerical Integration, 2015, submitted for publication.

tic, integ4=integralNoPenalty_g (f,0,1,abstol); toc 
err4 = abs(exactinteg-integ4) 

%%
% Although the first and second methods have good accuracy and are
% efficient time-wise, they do not have theoretical justification.  The
% third and fourth methods have theoretical justification.  

%%
% Note that the fourth method is faster than the third.  The reason is that
% the third method is designed for integrands in the cone
%
% \[ 
% \Bigl\{ f : {\rm Var}(f') \le \tau \int_0^1 \lvert f'(x) - [f(1) -
% f(0)] \rvert \, {\rm d} x \Bigr \}
% \]
%
% where \({\rm Var}(f')\) means the total variation of the first derivative
% of \(f\).  Here, \(\tau\) is a parameter that is tuned for the desired
% robustness.  
%
% On the other hand, the fourth method is designed for integrands in a
% different cone that is not so large.


%% Function Approximation Routines
% For function approximation the problem is to find \(\hat{f}\) based on
% \((x_1, f(x_1)), \ldots, (x_n, f(x_n))\) such that
%
% \[ \sup_{0 \le x \le 1} \lvert f(x) - \hat{f}(x) \rvert \le \varepsilon
% \]
%
% There is no automatic routine in MATLAB like the |integral| function.
% However, Chebfun does do automatic function approximation. 

xtest=sort(rand(1e6,1));
ftest=f(xtest);
tic, f1 = chebfun(f,[0 1]); toc
diff1 = abs(ftest-f1(xtest));
errf1 = max(diff1) % an approximation to the error

%%
% Here  is a plot of the difference between the values of the function at
% the test points and the values of the approximation at those same points

figure
plot(xtest,diff1,'-')
xlabel('\(x\)','Interpreter','latex')
ylabel('\( |f(x) - \hat{f}(x)| \)','Interpreter','latex')


%%
% GAIL also has a routine for function approximation

tic, f2=funappxglobal_g (f,0,1,abstol); toc
diff2 = abs(ftest-ppval(f2,xtest));
errf2 = max(diff2)
figure
plot(xtest,diff2,'-')
xlabel('\(x\)','Interpreter','latex')
ylabel('\( |f(x) - \hat{f}(x)| \)','Interpreter','latex')

%%
% Again Chebfun has no theoretical guarantees, but the GAIL routine does.

%% Project Goal
% The goal of our project is to speed up the GAIL routine for function
% approximation like has been done for integration.  The GAIL routine is
% designed for functions in the cone
%
% \[ \Bigl\{ f : \sup_{0 \le x \le 1} \lvert f''(x) \rvert \le \tau \sup_{0
% \le x \le 1} \lvert f'(x) - [f(1) - f(0)] \rvert \Bigr \} \]
%
% We will use the ideas behind |integralNoPenalty_g| to modify this cone
% and modify |funappxglobal_g|.

%%
% _Author: Christine Hickernell_ 