% Report results in long format. 
format long
	
% Seed the random number generator so that we all create the same random matrix U and vector x.

rng( 0 );      
n = 100;         
U = triu( rand( n,n ) );
x = rand( n,1 );

% Compute right-hand side b from known solution x.
b = U * x;

% Solve U xhat = b
xhat = U \ b;

% Report the difference between xhat and x
disp( 'norm( xhat - x )' )
norm( xhat - x )

% Check how close U * xhat is to b
disp( 'norm( b - U xhat )' )
norm( b - U * xhat )

