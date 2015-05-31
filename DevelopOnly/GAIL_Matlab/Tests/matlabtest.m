%% Doctest and Unit tests in Matlab

%% Why we need tests
%
% * Tests reduce bugs in new features
%
% * Tests reduce bugs in existing features
%
% * Tests are good documentation
%
% * Tests reduce the cost of change
%
% * Tests improve design


%% Doctest in Matlab
% Doctest allows you to embed tests in the documentation of your function
% (or class or method), so that they're in the same file as the code they
% test. They can also be valuable demonstrations of how to call your code.
%
% We define a function which is adding 3 to a number as add3.m
%
%   function sum = add3(value) 
%   % adds 3 to a number 
%   % 
%   % add3(value) 
%   % returns (value + 3) 
%   % 
%   % Examples: 
%   % 
%   % >> add3(7) 
%   % 
%   % ans = 
%   % 
%   % 10 
%   % 
%   % >> add3([2 4]) 
%   % 
%   % ans = 
%   % 
%   % 5 7 
%   if ~ isnumeric(value) 
%       error('add3(value) requires value to be a number'); 
%   end
%   sum = value + 3;
%
%
% Run doctest for add3
doctest add3

%%
% Here we want to show a failed example of doctest. We define a new
% function add3failtest.m
%
%   function sum = add3failtest(value) 
%   % adds 3 to a number 
%   % 
%   % add3(value) 
%   % returns (value + 3) 
%   % 
%   % Examples: 
%   % 
%   % >> add3failtest(7) 
%   % 
%   % ans = 
%   % 
%   % 9
%   % 
%   % >> add3failtest([2 4]) 
%   % 
%   % ans = 
%   % 
%   % 5 8 
%   if ~ isnumeric(value) 
%       error('add3(value) requires value to be a number'); 
%   end
%   sum = value + 3;
%
%
%Run doctest for add3failtest
doctest add3failtest

%%

% We can also create a file only for doctest, eg, dt_funappx_g

doctest dt_funappx_g

%% Unit tests in Matlab
% In computer programming, unit testing is a software testing method by
% which individual units of source code, sets of one or more computer
% program modules together with associated control data, usage procedures,
% and operating procedures, are tested to determine whether they are fit
% for use.
% 
% There is a matlab.unittest package in Matlab for user to test a MATLAB
% program.
%% Write Simple Test Case Using Classes
%
% *Create quadraticSolver.m Function*
% 
%
%   function roots = quadraticSolver(a, b, c)
%   % quadraticSolver returns solutions to the 
%   % quadratic equation a*x^2 + b*x + c = 0.
%   if ~isa(a,'numeric') || ~isa(b,'numeric') || ~isa(c,'numeric')
%        error('quadraticSolver:InputMustBeNumeric', ...
%            'Coefficients must be numeric.');
%   end
%   roots(1) = (-b + sqrt(b^2 - 4*a*c)) / (2*a);
%   roots(2) = (-b - sqrt(b^2 - 4*a*c)) / (2*a);
%   end
%
%
% *Create SolverTest Class Definition*
%
%
% To use the matlab.unittest framework, write MATLAB functions (tests) in
% the form of a test case, a class derived from matlab.unittest.TestCase.
%
% Create a subclass, SolverTest.
% 
%    classdef SolverTest < matlab.unittest.TestCase
% 
%        methods (Test)
% 
%        end
% 
%    end
%
% *Create Test Method for Real Solutions*
%
% Create a test method, testRealSolution, to verify that quadraticSolver returns the right value for real solutions. For example, the equation  $x^{2} - 3x + 2 = 0$ has real solutions  $x = 1$ and $x = 2$. This method calls quadraticSolver with the inputs of this equation. The solution, expSolution, is [2,1].
% Use the matlab.unittest.TestCase method, verifyEqual to compare the output of the function, actSolution, to the desired output, expSolution. If the qualification fails, the test continues execution.
%
%   function testRealSolution(testCase)
%       actSolution = quadraticSolver(1,-3,2);
%       expSolution = [2,1];
%       testCase.verifyEqual(actSolution,expSolution)
%    end 
%
% Add this function inside the methods (Test) block.
%
% *Create Test Method for Imaginary Solutions*
%
% Create a test to verify that quadraticSolver returns the right value for imaginary solutions. For example, the equation  $x^{2} - 2x + 10 = 0$ has imaginary solutions  $x = -1 + 3i$ and $x = -1 - 3i$. Add this function, testImaginarySolution, inside the methods (Test) block.
%
%   function testImaginarySolution(testCase)
%       actSolution = quadraticSolver(1,2,10);
%       expSolution = [-1+3i, -1-3i];
%       testCase.verifyEqual(actSolution,expSolution)
%   end
%
% The order of the tests within the block does not matter.
% 
% *Save Class Definition*
% The following is the complete SolverTest class definition. Save this file in a folder on your MATLAB path.
% 
%   classdef SolverTest < matlab.unittest.TestCase
%       % SolverTest tests solutions to the quadratic equation
%       % a*x^2 + b*x + c = 0
%     
%       methods (Test)
%           function testRealSolution(testCase)
%               actSolution = quadraticSolver(1,-3,2);
%               expSolution = [2,1];
%               testCase.verifyEqual(actSolution,expSolution);
%           end
%           function testImaginarySolution(testCase)
%               actSolution = quadraticSolver(1,2,10);
%               expSolution = [-1+3i, -1-3i];
%               testCase.verifyEqual(actSolution,expSolution);
%           end
%       end
%       
%   end 
%
% *Run Tests in SolverTest Test Case*
%
% Run all the tests in the SolverTest class definition file.
run(SolverTest)
%%
%
% *Different Kinds of TestCase*
%
% In funappx_g, we provide warnings for user to notify some situations as
% exceeding budget or number of max iteration. Here we show one example of
% unit test for warning flag and verifing less or equal. Define a subclass
% warninguittest.
%
%   classdef warningunittest < matlab.unittest.TestCase
%       methods(Test)
%           function funappx_gOfexceedbudget(testCase)
%               f = @(x) x.^2;
%               in_param.nmax = 1000;
%               [~, result] = testCase.verifyWarning(@()funappx_g(f,in_param),'MATLAB:funappx_g:exceedbudget');
%               testCase.verifyLessThanOrEqual(result.npoints,result.nmax);
%           end
%         
%           function funappx_gOfexceediter(testCase)
%               f = @(x) x.^2;
%               in_param.maxiter = 2;
%               [~, result] = testCase.verifyWarning(@()funappx_g(f,in_param),'MATLAB:funappx_g:exceediter');
%               testCase.verifyLessThan(result.maxiter,result.iter);
%           end
% 
%       end
%   end
%
% Run warninguittest
run(warningunittest)
%%
% *Failed Unit Test*
%
% Here we show one failed example of unit test. Define a subcalls
% failunittest.
%
%   classdef failunittest < matlab.unittest.TestCase
%       methods(Test)
%           function funappx_gOfexceedbudget(testCase)
%               f = @(x) x.^2;
%               in_param.nmax = 1000;
%               [~, result] = testCase.verifyWarning(@()funappx_g(f,in_param),'MATLAB:funappx_g:exceedbudget');
%               testCase.verifyGreaterThanOrEqual(result.npoints,result.nmax);
%           end
%         
%           function funappx_gOfexceediter(testCase)
%               f = @(x) x.^2;
%               in_param.maxiter = 2;
%               [~, result] = testCase.verifyWarning(@()funappx_g(f,in_param),'MATLAB:funappx_g:exceediter');
%               testCase.verifyLessThan(result.maxiter,result.iter);
%           end
% 
%       end
%   end
%
% Run failunittest
run(failunittest)







