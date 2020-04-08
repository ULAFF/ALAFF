format long

close all

figure
hold

% Reset the random number generator so we always get the same random A and
% x
rng 'default'

m = 10;
n = 3;

maxiters = 400;

xlabel( 'iteration' );
ylabel( 'approximation to \lambda' );

axis( [ 0 maxiters 0 11 ] );

% Create a Hermitian matrix of size n x n with eigenvalues 1, ... , n.

% Create a diagonal matrix
Lambda = diag( [ 1:m ] );

% Create a unitary matrix Q.  We do so by creating a random n x n matrix
% with entries in the range ( -1, 1 ) and then computing its QR
% factorization.
[ Q, R ] = qr( 2 * rand( m,m ) - ones( m,m ) );

% Set A equal to its Spectral Decomposition
A = Q * Lambda * Q';

% Create random initial vector, so all methods start with the same
x = 2*rand( m, 1 )-ones( m,1 );

% Execute the Power Method.
[ lambda0, x0 ] = PowerMethod( A, x, maxiters );

legend( 'PowerMethod', 'Location', 'southeast' );

% Execute the Power Method starting with a vector with no component in the
% direction of x0

%%% [ lambda1, x1 ] = PowerMethodLambda1( A, x, x0, maxiters );

%%% legend( 'PowerMethod', 'PowerMethodLamba1', 'Location', 'southeast' );

% Execute the Power Method starting with a vector with no component in the
% direction of x0, reorthogonalizing in each iteration.

%%% [ lambda1, x1 ] = PowerMethodLambda1Reorth( A, x, x0, maxiters );

%%% legend( 'PowerMethod', 'PowerMethodLamba1', 'PowerMethodLamba1Reorth', ...
%%%     'Location', 'southeast' );

figure
hold
xlabel( 'iteration' );
ylabel( 'approximation to \lambda' );

axis( [ 0 maxiters 0 11 ] );

% Execute the subspace iteration.
V = 2 * rand( m, n ) - ones( m, n );

%%% [ Lambda, V ] = SubspaceIteration( A, V, maxiters );

%%% disp( 'trans(V) * A * V = ' );
%%% V' * A * V