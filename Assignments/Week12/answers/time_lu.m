% Set problem size
m = 2000

% Set algorithmic block size
nb_alg = 192;

% Generate random matrix
A = rand( m,m );



% Perform LU factorization with column pivoting
[ L, U, P ] = lu( A );

% Pivot the matrix so no pivoting will be needed.
A = P * A;

% Start the clock
tic 

[ L, U, P ] = lu( A );

% Time the Matlab native lu factorization with pivoting
disp( 'Time for lu( A )' )
toc
disp( 'accuracy for lu( A )')
disp( norm(A - L * U, 'fro' ) )

% Start the clock
tic 

if m > 2000
    disp( 'This is a very large problem size for an unblocked algorithm.' );
    disp( 'You may want to comment out the call to that version.')
end

[ LU ] = LU_right_looking( A );

% Time the unblocked right-looking lu factorization without pivoting
disp( 'Time for LU_right_looking' )
toc

L = tril( LU, -1 ) + eye( size( LU ) );
U = triu( LU );

disp( 'accuracy for LU_right_looking( A )')
disp( norm(A - L * U, 'fro' ) )

% Start the clock
tic 

[ LU ] = LU_blk_right_looking( A, nb_alg );

% Time the blocked right-looking lu factorization without pivoting
disp( 'Time for LU_blk_right_looking' )
toc

L = tril( LU, -1 ) + eye( size( LU ) );
U = triu( LU );

disp( 'accuracy for LU_blk_right_looking( A )')
disp( norm(A - L * U, 'fro' ) )

