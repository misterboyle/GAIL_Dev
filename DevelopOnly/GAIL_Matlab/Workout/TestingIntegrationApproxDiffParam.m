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
peakyappx=@(x,t,h) exp(-((x-t)/h).^2); %maximun value is 1
peakyint=@(x,t,h) peakyappx(x,t,h)/(0.5*h*sqrt(pi)*(erf((1-t)/h)+erf(t/h))); 
   %integral is always 1

%%
% This is a Gaussian peak, where |t| is the center and |h| is the width.  It
% is defined so that the integral is always 1.

f = @(x) peakyint(x,0.5,0.2); exactinteg = 1;

%% Messing with t and h

hvec=[0.2 0.02 0.002 0.0002] %different widths of peaks
nh=numel(hvec)
tvec=0:0.1:1; %different centers of the function
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
errf1=integ1;
timef1=integ1;
errf2=integ1;
timef2=integ2;
Npointsf2=integ1;
abstol=1e-10;
in.a=0; in.b=1; in.abstol = abstol; 
in.nlo=1000; %more robust
in.nmax=1e8; %maximum cost budget
xtest=sort(rand(1e6,1));
for jj = 1:nt
    jj
    t = tvec(jj);
    for ii=1:nh
        h=hvec(ii);
        %integral test cases
        f=@(x) peakyint(x,t,h);
        tic, integ1(ii,jj)=integral(f,0,1); time1(ii,jj)=toc; 
        tic, fcheb = chebfun(f,[0 1]); integ2(ii,jj)=sum(fcheb); time2(ii,jj)=toc;  
        tic, [integ3(ii,jj),out]=integral_g (f,in); time3(ii,jj)=toc; %integrate using integral_g
        Npoints3(ii,jj)=out.npoints;
        tic, [integ4(ii,jj),out]=integralNoPenalty_g (f,in); time4(ii,jj)=toc;
        Npoints4(ii,jj)=out.npoints;
        %function approximation test cases
        f=@(x) peakyappx(x,t,h); 
        ftest=f(xtest); %function test values
        tic, f1 = chebfun(f,[0 1]); timef1(ii,jj)=toc;
        errf1(ii,jj) = max(abs(ftest-f1(xtest))); % an approximation to the error
        tic, f2=funappxglobal_g (f,in); timef2(ii,jj)=toc;
        errf2(ii,jj) = max(abs(ftest-ppval(f2,xtest)));
        Npointsf2(ii,jj)=out.npoints;
    end
end
err1=abs(exactinteg-integ1);
err2=abs(exactinteg-integ2);
err3=abs(exactinteg-integ3);
err4=abs(exactinteg-integ4);
save(['TestingIntegrationApproxResults_Nmax' int2str(out.nmax) ...
    'Nlo' int2str(out.nlo)])

