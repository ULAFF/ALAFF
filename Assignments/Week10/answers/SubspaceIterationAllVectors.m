function [ Ak, V ] = SubspaceIterationAllVectors( A, maxits, ...
    illustrate, delay )
% Performs a subspace iteration with a full matrix
%
% If illustrate = 1, then the matrices are printed (with delay in seconds)
% and graphs that illustrate the convergence are generated.
    
[ m, n ] = size( A );
    
% Initialize the matrix in which the eigenvectors are accumulated
% V = I
V = eye( m, m );
    
% Ak holds the current V' * A * V
Ak = A;
    
% If we illustrate the algorithm, create an array in which to store the 
% approximations for the eigenvalues
if illustrate
    lambdas = zeros( m, maxits );
end
  
% Iterate until the vectors don't change much anymore or a maximum number
% of iterations have been performed
for k=1:maxits
    
    % Compute QR factorization of active part of Ak
    [ V, R ] = qr( A * V );
        
    % Update Ak
    Ak = V' * A * V;
        
    if illustrate ~= 0
        % Extract the approximations to the eigenvalues for later plotting
        lambdas( :, k ) = diag( Ak )';
    end
    
    if illustrate == 2
        % Animate the matrix convergence of the matrix 
        clc                   % clear the screen
        k                     % print the iteration index
        Ak                    % print the current matrix
        pause( delay )            % wait a bit
    end
               
    % Find the maximum element (in absolute value) in the lower triangular
    % matrix
    diff = norm( tril( Ak ), Inf );
    
    % This stopping criteria needs to be refined.  However, it will be more
    % obvious how to do this once we get to the final algorithm
    if diff < 1e-14
        break
    end
       
end
 
if illustrate ~= 0
    ReportConvergence( lambdas(:,1:k), "SubspaceIterationAllVectors" );
end

end
