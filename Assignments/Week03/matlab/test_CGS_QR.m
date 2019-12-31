m = 5;
n = 4;
A = rand( m, n );

[ Q, R ] = CGS_QR( A );

A - Q * R
