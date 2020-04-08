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

% Set the number of columns in V
n = 3;

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

% Create a random matrix V
V = 2 * rand( m,n ) - ones( m,n );

% For the Power Methods, set the initial vector equal to the first vector
% of V
x = V( :, 1 );

% Uncomment the routine you want to test

% Execute the Power Method starting with vector x
disp( 'PowerMethod' );

% Set the maximum number of iterations to be performed
maxiters = 30;

[ lambda_0, v0 ] = PowerMethod( A, x, maxiters, 0, delay );

% Report final approximation to lambda_0
disp( 'approximation to lambda_0 = ' );
v0' * A * v0

if (0)
    % Execute the Power Method that starts by subtracting out the component of
    % x in the direction of an eigenvector of lambda_0.  Make sure you also run
    % PowerMethod (above).  You may want to turn off displaying the
    % intermediate results for that experiment.
    %
    % NOTE: for this experiment, you will want to set the maxiters to be pretty
    % large.  Maybe 50.  Why will become clear after you run the experiment.
    disp( 'PowerMethodLambda1' );
    
    % Set the maximum number of iterations to be performed
    maxiters = 50;
    
    [ lambda_1, v1 ] = PowerMethodLambda1( A, x, v0, maxiters, illustrate, ...
        delay );
    
    % Report final approximation to lambda_1
    disp( 'approximation to lambda_1 = ' );
    v1' * A * v1
end

if (0)
    % Execute the Power Method that starts by subtracting out the component of
    % x in the direction of an eigenvector of lambda_0 and reorthogonalizes
    % during each iteration.  Make sure you also run
    % PowerMethod (above).  You may want to turn off displaying the
    % intermediate results for that experiment.
    disp( 'PowerMethodLambda1Reorth' );
    
    % Set the maximum number of iterations to be performed
    maxiters = 30;
    
    [ lambda_1, v1 ] = PowerMethodLambda1Reorth( A, x, v0, ...
        maxiters, illustrate, delay  );
    
    % Report final approximation to lambda_1
    disp( 'approximation to lambda_1 = ' );
    v1' * A * v1
end

if (1)
    % Execute the subspace iteration with a matrix V
    disp( 'SubspaceIteration' );
    
    % Set the maximum number of iterations to be performed
    maxiters = 30;

    [ Lambda, V ] = SubspaceIteration( A, V, maxiters, illustrate, delay  );
    
    % Report V' * A * V as a test to see if the right eigenvectors were
    % computed.  The resulting matrix should be diagonal (and approximately 
    % equal to Lambda)
    disp( 'trans(V) * A * V = ' );
    V' * A * V
end