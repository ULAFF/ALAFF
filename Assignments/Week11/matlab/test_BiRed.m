format long

% matrix size
m = 5;

% Generate a random matrix
A = rand( m, m );

% Create vector in which to store the scalars tau from the Householder
% transformations
t = rand( m, 1 );

% Create vector in which to store the scalars rho from the Householder
% transformations
r = rand( m, 1 );

% Compute the reduction to tridiagonal form
[ B, t, r ] = BiRed( A, t, r );

% Quick check if it was probably done correctly: Check the singular values of
% the bidiagonal matrix (extracted from B) with those of the original matrix.
Bi = BiFromB( B );
disp('Singular values of B')
svd( Bi )

disp('Singular values of A')
svd( A )

