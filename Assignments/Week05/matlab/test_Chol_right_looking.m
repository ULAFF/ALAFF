n = 5

% Create a unit lower triangular matrix L with random strictly lower
% triangular entries and nonzero diagonal entries (equal to 2 for
% simplicity)
L = tril( ( rand( n, n ) * 2 - 1 ), -1 ) + 2 * eye( n, n );

% Create A = L * L'
A = L * L';

% Factor A
A_out = Chol_right_looking( A );

% Extract the lower triangular matrix from A_out
L_out = tril( A_out );

% Check if A_out = L_out * L_out'.  Notice that the strictly upper
% triangular part should not have changed.
disp( 'norm( A - ( tril( L_out * trans( L_out ) ) + triu( A, 1 ) ) )' );
norm(  A - ( tril( L_out * L_out') + triu( A, 1 ) ) )