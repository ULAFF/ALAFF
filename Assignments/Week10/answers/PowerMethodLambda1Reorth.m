function [ lambda1, v1 ] = PowerMethodLambda1Reorth( A, x, x0, maxits, ...
        illustrate, delay )
% Performs PowerMethod with vector x
%
% If illustrate = 1, then the matrices V are printed (with delay in seconds)
% and graphs that illustrate the convergence are generated.
% If illustrate == 2, then graphs that illustrate the convergence are generated.
    
[ m, n ] = size( A );
    
% If we illustrate the algorithm, create an array in which to store the 
% approximations for the eigenvalues
if illustrate ~= 0
    lambdas = zeros( 1, maxits );
end

% Create initial vector by normalizing vector x to length 1
v1 = x - x0' * x * x0;
v1 = v1 / norm( v1 );
  
% Iterate until the vector doesn't change much anymore or a maximum number
% of iterations have been performed
for k=1:maxits
     
    v1old = v1;
    
    v1 = A * v1;
    v1 = v1 - x0' * v1 * x0;
    v1 = v1 / norm( v1 );
        
    % Update estimate of lambda
    lambda1 = v1' * A * v1;
        
    if illustrate ~= 0
        % Extract the approximations to the eigenvalues for later plotting
        lambdas( 1, k ) = lambda1;
    
        if illustrate == 2
            % Animate the matrix convergence of the matrix 
            clc                   % clear the screen
            k                     % print the iteration index
            lambda1               % print the current approximation to lambda0
            pause( delay )        % wait a bit
        end
    end
               
    % Check if v has stopped changing by looking at the component 
    % of vold orthogonal to v
    diff = norm( v1old - v1'*v1old * v1, Inf );
    
    % This stopping criteria needs to be refined.  However, it will be more
    % obvious how to do this once we get to the final algorithm
    if diff < 1e-14
        break
    end
       
end
 
if illustrate ~= 0
    ReportConvergence( lambdas, "PowerMethodLambda1Reorth" );
end

end
