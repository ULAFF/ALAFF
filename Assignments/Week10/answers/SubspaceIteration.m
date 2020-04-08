function [ Ak, V ] = SubspaceIteration( A, V, maxits, ...
        illustrate, delay )
% Performs PowerMethod with vector x
%
% If illustrate = 1, then the matrices V are printed (with delay in seconds)
% and graphs that illustrate the convergence are generated.
% If illustrate == 2, then graphs that illustrate the convergence are generated.
    
[ m, n ] = size( V );
    
% If we illustrate the algorithm, create an array in which to store the 
% approximations for the eigenvalues
if illustrate ~= 0
    lambdas = zeros( n, maxits );
end

% Create initial vector by normalizing vector x to length 1
[ V, R ] = qr( V, 0 );
  
% Iterate until the vector doesn't change much anymore or a maximum number
% of iterations have been performed
for k=1:maxits
     
    [ V, R ] = qr( A * V, 0 );
        
    % Update estimate of lambda
    Ak = V' * A * V;
        
    if illustrate ~= 0
        % Extract the approximations to the eigenvalues for later plotting
        lambdas( :, k ) = diag( Ak );
    
        if illustrate == 2
            % Animate the matrix convergence of the matrix 
            clc                   % clear the screen
            k                     % print the iteration index
            Ak                    % print the current approximation to lambda0
            pause( delay )        % wait a bit
        end
    end
               
    % Check if v has stopped changing by looking at the component 
    % of vold orthogonal to v
    diff = norm( tril( Ak, -1 ), Inf );
    
    % This stopping criteria needs to be refined.  However, it will be more
    % obvious how to do this once we get to the final algorithm
    if diff < 1e-14
        break
    end
       
end
 
if illustrate ~= 0
    ReportConvergence( lambdas, "SubspaceIteration" );
end

end
