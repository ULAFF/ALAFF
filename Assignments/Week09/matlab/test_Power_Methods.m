format long          % Print 16 digits

close all            % Close all figures

% Indicate if the routines are to generate illustations
% illustrate = 0;    % do not show graphs or animate matrices
% illustrate = 1;    % show graphs, do not animate matrices
illustrate = 2;    % show graphs and animate matrices

% Set delay for animation
delay = 0.5;        % delay between displayed results, in seconds.

% Reset the random number generator so we always get the same random A
rng 'default'

% Set the size of matrix A
m = 5;

% Create a Hermitian matrix of size n x n with eigenvalues 1, ... , n.
% We do so by creating a diagonal matrix, and hitting this diagonal matrix
% with a unitary similarity transformation.

% Create a diagonal matrix
Lambda = diag( [ 1:m ] )

% Create a unitary matrix Q.  We do so by creating a random n x n matrix
% with entries in the range ( -1, 1 ) and then computing its QR
% factorization.
[ Q, R ] = qr( 2 * rand( m,m ) - ones( m,m ) );

% Set A equal to its Spectral Decomposition
A = Q * Lambda * Q';

% Create a random vector x with which to start the various Power Method
% related implementations
x = 2 * rand( m, 1 ) - ones( m, 1 );

% Uncomment the routine you want to test

if (1)
    % Execute the Power Method starting with vector x
    disp( 'PowerMethod' );
    
    % Set the maximum number of iterations to be performed
    maxiters = 30;
    
    [ lambda_0, v0 ] = PowerMethod( A, x, maxiters, 2, delay );
    
    % Report final approximation to lambda_0
    disp( 'approximation to lambda_0 = ' );
    lambda_0
end

if (0)
    % Execute the Inverse Power Method 
    disp( 'Inverse Power Method' );
    
    % Set the maximum number of iterations to be performed
    maxiters = 30;
    
    [ lambda_m_min_1, v_m_min_1 ] = ...
        InversePowerMethod( A, x, maxiters, illustrate, ...
        delay );
    
    % Report final approximation to lambda_1
    disp( 'approximation to lambda_{m-1} = ' );
    v_m_min_1' * A * v_m_min_1
end

if (0)
    % Execute the Shifted Inverse Power Method 
    disp( 'Shifted Inverse Power Method' );
    
    % Set the maximum number of iterations to be performed
    maxiters = 30;
    
    rho = 0.95;
    
    [ lambda_m_min_1, v_m_min_1 ] = ...
        ShiftedInversePowerMethod( A, x, rho, ...
          maxiters, illustrate, delay );
    
    % Report final approximation to lambda_1
    disp( 'approximation to lambda_{m-1} = ' );
    v_m_min_1' * A * v_m_min_1
end

if (0)
    % Execute the Rayleigh Quotient Iteration
    disp( 'Rayleigh Quotient Iteration' );
    
    % Set the maximum number of iterations to be performed
    maxiters = 30;
    
    [ lambda_m_min_1, v_m_min_1 ] = ...
        RayleighQuotientIteration( A, x, maxiters, illustrate, ...
        delay );
    
    % Report final approximation to lambda_1
    disp( 'approximation to lambda_{m-1} = ' );
    v_m_min_1' * A * v_m_min_1
end
