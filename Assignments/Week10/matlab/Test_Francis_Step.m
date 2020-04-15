format long

rng

m = 5
% Create a random m x m tridiagonal matrix.  Even though we will only
% update the lower triangular part, we create the symmetric matrix.
T = rand( m, m );

% Extract upper triangle plus first subdiagonal.
T = triu( T, -1 );

% Set strictly upper triangular part to transpose of strictly lower
% triangular part
T = tril( T ) + tril( T,-1 )'

% Make a copy of T
T1 = T;

% Perform a few steps of the Francis Implicit QR Step.
% Intermediate results are printed out.

% The (m,m-1) entry should be getting smaller.
T1 = Francis_Step( T1 )

% The (m,m-1) entry should be getting smaller.
T1 = Francis_Step( T1 )

% The (m,m-1) entry should be getting small.  
T1 = Francis_Step( T1 )

% See what happens if you uncomment the next line.  
% T1 = Francis_Step( T1 )

% Only the lower triangular part of T1 was updated.  Here we make it
% symmetric.
T1 = tril( T1 ) + tril( T1, -1 )';

disp( 'eigenvalues of original matrix T' );
eig( T )

% Each matrix T1 should have the same eigenvalues of the original matrix
disp( 'eigenvalues of final matrix T1' );
eig( T1 )

% Print the final matrix.  The (m,m-1) entry should be small.  
disp( 'T1 after ')
T1

