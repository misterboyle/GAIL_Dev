function sum = add3failtest(value) 
% adds 3 to a number 
% 
% add3(value) 
% returns (value + 3) 
% 
% Examples: 
% 
% >> add3failtest(7) 
% 
% ans = 
% 
% 9 
% 
% >> add3failtest([2 4]) 
% 
% ans = 
% 
% 5 8 
if ~ isnumeric(value) 
    error('add3(value) requires value to be a number'); 
end

sum = value + 3;

end