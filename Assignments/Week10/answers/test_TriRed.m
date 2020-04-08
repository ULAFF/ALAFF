format long

% matrix size
m = 5;

% Generate a random matrix
A = rand( m, m );

% The matrix is now assumed to be symmetric, stored in the lower triangular
% part of A.  We compute the reduction to tridiagonal form, updating only
% the lower triangular part of the matrix.

% Create vector in which to store the scalars tau from the Householder
% transformations
t = rand( m, 1 );

% Compute the reduction to tridiagonal form
[ T, t ] = TriRed( A, t );

% Quick check if it was probably done correctly: Check the eigenvalues of
% the tridiagonal matrix (extracted from the diagonal and first subdiagonal
% of T) with those of the original matrix.
T = TriFromBi( T );
disp('Eigenvalues of T')
eig( T )

% Make A symmetric
A = tril( A ) + tril( A, -1)';
disp('Eigenvalues of A')
eig( A )

