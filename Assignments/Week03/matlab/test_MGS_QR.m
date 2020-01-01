m = 5;
n = 4;
A = rand( m, n );

[ Q, R ] = MGS_QR( A );

A - Q * R
