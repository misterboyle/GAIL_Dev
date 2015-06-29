%% Testing different routines for integration and function approximation
function DispTestingDiffParam(datafile)

%% Initialization
format compact
set(0,'defaultaxesfontsize',24,'defaulttextfontsize',24) %make font larger
set(0,'defaultLineLineWidth',3) %thick lines

%% Load data
load(datafile)
disp('<strong>Results of Testing Integration and Approximation Routines for the Peaky Function</strong>')
disp('The values of the center of the peaky test function are')
disp(tvec)
disp('The values of the width of the peaky test function are')
disp(hvec)
disp(['The robustness parameter = ' int2str(out.nlo)])
disp(' ')
disp('<strong>Errors of Integration Methods</strong>')
disp('MATLAB''s integral')
disponematrix(err1,tvec,hvec)
disp('Chebfun')
disponematrix(err2,tvec,hvec)
disp('integral_g')
disponematrix(err3,tvec,hvec)
disp('integralNoPenalty_g')
disponematrix(err4,tvec,hvec)

end


function disponematrix(matrix,tvec,hvec)
fprintf(1,'t     | h');
fprintf(1,'%6.0e',tvec);
fprintf('\n')
disp('--------------------------------------------------------------------------')
for ii = 1:numel(hvec)
   fprintf('%5.0e |  ',hvec(ii))
   fprintf(1,'%6.0e',matrix(ii,:));
   fprintf('\n')
end
disp('==========================================================================')
end



