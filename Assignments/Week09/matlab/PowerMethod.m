function [ lambda0, v ] = PowerMethod( A, x, maxits, illustrate, delay )
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
v = x / norm( x );
  
% Iterate until the vector doesn't change much anymore or a maximum number
% of iterations have been performed
for k=1:maxits
     
    vold = v;
    
    v = A * v;
    v = v / norm( v );
        
    % Update estimate of lambda
    lambda0 = v' * A * v;
        
    if illustrate ~= 0
        % Extract the approximations to the eigenvalues for later plotting
        lambdas( 1, k ) = lambda0;
    
        if illustrate == 2
            % Animate the matrix convergence of the matrix 
            clc                   % clear the screen
            k                     % print the iteration index
            lambda0               % print the current approximation to lambda0
            pause( delay )        % wait a bit
        end
    end
               
    % Check if v has stopped changing by looking at the component 
    % of vold orthogonal to v
    diff = norm( vold - v'*vold * v , Inf );
    
    % This stopping criteria needs to be refined.  However, it will be more
    % obvious how to do this once we get to the final algorithm
    if diff < 1e-14
        break
    end
       
end
 
if illustrate ~= 0
    ReportConvergence( lambdas(1,1:k), max( eig( A ) ), "\lambda_0" );
end

end
