format long

% Seed the random number generator so we all get the same matrix
rng( 0 )

m = 5;
n = 4;

% Create random m x n matrix A
A = rand( m, n );

% Call HQR
[ A_out, t_out ] = HQR( A );

% Set R = upper triangular part of A
R = triu( A_out( 1:n, : ) )

% Form Q
[ Q ] = FormQ( A_out, t_out );

% Check A - Q * R
disp( 'A - Q * R = ' );
A - Q * R

% Report norm( A - Q * R )
disp( 'norm( A - Q * R ) =')
norm( A - Q * R )