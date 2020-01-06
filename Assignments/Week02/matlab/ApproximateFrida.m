IMG = imread( 'Frida.jpg' );    
A = double( IMG( :,:,1 ) );     
imshow( uint8( A ) )          
size( A )

[ U, Sigma, V ] = svd( A );

k = 1
B = uint8( U( :, 1:k ) * Sigma( 1:k,1:k ) * V( :, 1:k )' );   
imshow( B );
