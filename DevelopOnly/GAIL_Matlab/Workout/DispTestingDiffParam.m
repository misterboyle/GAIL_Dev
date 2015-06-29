%% Testing different routines for integration and function approximation
function DispTestingDiffParam(datafile)

%% Initialization
format compact
clc

%% Load data
load(datafile)

%% Integration Results
disp('<strong>Results of Testing Integration and Approximation Routines for the Peaky Function</strong>')
disp('The values of the center of the peaky test function are')
disp(tvec)
disp('The values of the width of the peaky test function are')
disp(hvec)
disp(['The robustness parameter = ' int2str(out.nlo)])
pause
disp(' ')
disp('<strong>Errors of Integration Methods</strong>')
disp('MATLAB''s integral')
erroralert = @(x) max(0,(abs(x)-abstol)/abstol);
disponematrix(err1,tvec,hvec,erroralert)
disp('Chebfun')
disponematrix(err2,tvec,hvec,erroralert)
disp('integral_g (GAIL)')
disponematrix(err3,tvec,hvec,erroralert)
disp('integralNoPenalty_g (GAIL)')
disponematrix(err4,tvec,hvec,erroralert)
pause
disp(' ')
disp('<strong>Times of Integration Methods</strong>')
disp('MATLAB''s integral')
disponematrix(time1,tvec,hvec)
disp('Chebfun')
disponematrix(time2,tvec,hvec)
disp('integral_g (GAIL)')
disponematrix(time3,tvec,hvec)
disp('integralNoPenalty_g (GAIL)')
disponematrix(time4,tvec,hvec)
pause
disp(' ')
disp('<strong>Number of Points Needed for Integration Methods</strong>')
disp('integral_g (GAIL)')
disponematrix(Npoints3,tvec,hvec,@(x) abs(x)>0.9*out.nmax)
disp('integralNoPenalty_g (GAIL)')
disponematrix(Npoints4,tvec,hvec,@(x) abs(x)>0.9*out.nmax)
pause

%% Function Approximation Results
disp(' ')
disp('<strong>Errors of Function Approximation Methods</strong>')
disp('Chebfun')
disponematrix(errf1,tvec,hvec,erroralert)
disp('funappxglobal_g (GAIL)')
disponematrix(errf2,tvec,hvec,erroralert)
disp(' ')
disp('<strong>Times of Function Approximation  Methods</strong>')
disp('Chebfun')
disponematrix(timef1,tvec,hvec)
disp('funappxglobal_g (GAIL)')
disponematrix(timef2,tvec,hvec)
pause
disp(' ')
disp('<strong>Number of Points Needed for Function Approximation Methods</strong>')
disp('funappxglobal_g')
disponematrix(Npointsf2,tvec,hvec,@(x) abs(x)>0.9*out.nmax)

end


function disponematrix(matrix,tvec,hvec,alertfun)
if nargin <=3
   alertfun = @(x) false;
end
fprintf(1,'t     | h');
fprintf(1,'%6.0e',tvec);
fprintf('\n')
disp('---------------------------------------------------------------------------')
for ii = 1:numel(hvec)
   fprintf('%5.0e |  ',hvec(ii))
   for jj = 1:numel(tvec)
      if alertfun(matrix(ii,jj)) > 10
         cprintf('red','%6.0e',matrix(ii,jj));
      elseif alertfun(matrix(ii,jj)) > 1
         cprintf([1 0.5 0],'%6.0e',matrix(ii,jj));
      else
         cprintf('black','%6.0e',matrix(ii,jj));
      end
   end
   fprintf('\n')
end
disp('===========================================================================')
end



