format long

% Seed the random number generator so we all get the same matrix
rng( 0 )

m = 4;
n = 5;

% Create random m x n matrix A
A = rand( m, n );

% Call HLQ
[ A_out, t_out ] = HLQ( A );

disp( 'A_out computed by HLQ' );
A_out 

% Call the HQR routine we wrote, with the transpose matrix
[ A_out_QR, t_out_QR ] = HQR( A' );

disp( 'A_out_QR computed by HQR' );
A_out_QR

disp( 'Report difference (should be the zero matrix)' )
A_out - A_out_QR'

