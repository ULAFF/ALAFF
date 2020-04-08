function [ Ak, V ] = SimpleShiftedQRAlgwithDeflation( A, maxits, ...
        illustrate, delay )
% Performs a simple shifted QR algorithm (with full matrix) that 
% incorporates deflation.
%
% If illustrate = 1, then the matrices are printed (with delay in seconds) 
% and graphs that illustrate the convergence are generated.
    
[ m, n ] = size( A );
    
% Initialize the matrix in which the eigenvectors are accumulated
% V = I
V = eye( m, m );
    
% Ak holds iteration A^{(k)}
Ak = A;
    
% If we illustrate the algorithm, create an array in which to store the 
% approximations for the eigenvalues
if illustrate
    lambdas = zeros( m, maxits );
end
 
% Originally, we iterate with the full m x m matrix
curm = m;
    
% Iterate until the vectors don't change much anymore or a maximum number
% of iterations have been performed
for k=1:maxits
    % Compute shift
    rho = Ak( curm, curm );

    % Compute QR factorization of active part of Ak
    [ Q, R ] = qr( Ak(1:curm,1:curm) - rho * eye( curm ) );
        
    % Update active part of Ak
    Ak( 1:curm,1:curm) = R * Q + rho * eye( curm );
        
    % Update V
    V(:,1:curm) = V(:,1:curm) * Q;
        
    if illustrate ~= 0
        % Extract the approximations to the eigenvalues for later plotting
        lambdas( :, k ) = diag( Ak )';
    end
    
    if illustrate == 2
        % Animate the matrix convergence of the matrix 
        clc                   % clear the screen
        k                     % print the iteration index
        Ak(1:curm,1:curm)     % print the current active matrix
        pause( delay )            % wait a bit
    end
               
    % Compute the 1 norm of the off diagonal elements of the last active 
    % row
    diff = norm( Ak(curm,1:curm-1), 1 );
    % Compute the 1 norm of the diagonal elements of Ak
    diag_1_norm = norm( diag( Ak ), 1 );   

    % This stopping criteria needs to be refined.  However, it will be more
    % obvious how to do this once we get to the final algorithm
    if diff < 1e-14 * diag_1_norm
        % deflate
        curm = curm-1;
            
        % if active part of matrix is 1 x 1, then you are done
        if curm == 1
            break
        end
    end
       
end
 
if illustrate ~= 0
    ReportConvergence( lambdas(:,1:k), "SimpleShiftedQRAlgWithDeflation" );
end

end
