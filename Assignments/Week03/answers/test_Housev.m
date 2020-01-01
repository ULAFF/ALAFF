format long

n = 4;

chi1 = rand( 1, 1 )
x2   = rand( n-1, 1 );
x = [ chi1
       x2 ];

[ rho, ...
   u2, tau ] = Housev( chi1, ...
                        x2 );
                  
u = [ 1
      u2 ];               
               
( eye( n, n ) - u * u' / tau )  * x

rho


