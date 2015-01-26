%ut_workout_integral_g unit test for workout_integral_g
classdef ut_workout_integral_g < matlab.unittest.TestCase

  methods(Test)
             
    function testWorkout_integral_g(testCase)
      nrep=10000; nmax=1e7; abstol=1e-8;
      [succnowarn, succwarn] = workout_integral_g(nrep,nmax,abstol);
      succrates = succnowarn + succwarn;   
      testCase.verifyGreaterThanOrEqual(succrates,[0.1,0.5,0.8]);
    end
    
  end
end