n = 5

% Create a unit lower triangular matrix L with random strictly lower
% triangular entries
L = tril( ( rand( n, n ) * 2 - 1 ), -1 ) + eye( n, n );

% Create an upper triangular matrix that does not have a small entry along
% the diagonal
U = triu( rand( n, n ) * 2 - 1 ) + 3 * eye( n, n );

% Create A = L * U
A = L * U;

% Factor A
A_out = LU_left_looking( A );

% Extract the unit lower triangular matrix and upper triangular matrix from
% A_out
L_out = tril( A_out, -1 ) + eye( n, n );
U_out = triu( A_out );

% Check if A_out = L_out * U_out
disp( 'norm( A - L_out * U_out )' );
norm( A - L_out * U_out )