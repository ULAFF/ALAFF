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

% Set the maximum number of iterations to be performed
maxiters = 30;

% Create a Hermitian matrix of size n x n with eigenvalues 1, ... , n.
% We do so by creating a diagonal matrix, and hitting this diagonal matrix
% with a unitary similarity transformation.

% Create a diagonal matrix
Lambda = diag( [ 1:m ] );

% Create a unitary matrix Q.  We do so by creating a random n x n matrix
% with entries in the range ( -1, 1 ) and then computing its QR
% factorization.
[ Q, R ] = qr( 2 * rand( m,m ) - ones( m,m ) );

% Set A equal to its Spectral Decomposition
A = Q * Lambda * Q';

if (1) 
    % Execute the subspace iteration with a square matrix V
    [ Lambda, V ] = SubspaceIterationAllVectors( A, maxiters, illustrate, ...
        delay );
end

if (0)
    % Execute simple QR algorithm
    [ Lambda, V ] = SimpleQRAlg( A, maxiters, illustrate, ...
        delay );
end

if (0)
    % Execute simple QR algorithm with a constant shift of rho
    rho = 0.95;
    [ Lambda, V ] = SimpleShiftedQRAlgConstantShift( A, rho, maxiters, ...
       illustrate, delay );
end

if (0)
    % Execute simple shifted QR algorithm
    [ Lambda, V ] = SimpleShiftedQRAlg( A, maxiters, illustrate, ...
        delay );
end

if (0)
    % Execute simple shifted QR algorithm with deflation
    [ Lambda, V ] = SimpleShiftedQRAlgwithDeflation( A, maxiters, ...
        illustrate, delay );
end

V' * A * V
