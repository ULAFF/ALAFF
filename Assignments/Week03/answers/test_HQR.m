format long

% Seed the random number generator so we all get the same matrix
rng( 0 )

m = 5;
n = 4;

% Create random m x n matrix A
A = rand( m, n );

% Call HQR
[ A_out, t_out ] = HQR( A );

disp( 'R computed by HQR' );
triu( A_out( 1:n, : ) )

% Call matlab's qr routine
[ Q, R ] = qr( A );

disp( 'R computed by qr (matlab intrinsic routine)' );
triu( R( 1:n, : ) )

disp( 'Report difference' )
triu( A_out( 1:n, : ) - R( 1:n, : ) )

disp( 'Warning: since diagonal elements of R are not chosen to be positive')
disp( '         R may not be unique' );