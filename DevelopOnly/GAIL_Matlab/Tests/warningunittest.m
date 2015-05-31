classdef warningunittest < matlab.unittest.TestCase
    methods(Test)
        function funappx_gOfexceedbudget(testCase)
            f = @(x) x.^2;
            in_param.nmax = 1000;
            [~, result] = testCase.verifyWarning(@()funappx_g(f,in_param),'MATLAB:funappx_g:exceedbudget');
            testCase.verifyLessThanOrEqual(result.npoints,result.nmax);
        end
        
        function funappx_gOfexceediter(testCase)
            f = @(x) x.^2;
            in_param.maxiter = 2;
            [~, result] = testCase.verifyWarning(@()funappx_g(f,in_param),'MATLAB:funappx_g:exceediter');
            testCase.verifyLessThan(result.maxiter,result.iter);
        end

    end
end
