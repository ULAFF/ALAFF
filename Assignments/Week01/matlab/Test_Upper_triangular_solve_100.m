format long             % Report results in long format. 

rng( 0 );               % Seed the random number generator so that we all 
                        % create the same random matrix U and vector x
n = 100                 % Problem size
U = triu( rand( n,n ) );% Create random upper triangular matrix
x = rand( n,1 );        % Create random solution

b = U * x;              % Compute right-hand side b from known solution x.

xhat = U \ b;           % Solve U * xhat = b

disp( 'norm( xhat - x ) = ')
norm( xhat - x  )       % Report the difference between xhat and x.

disp( 'b - U * xhat = ')
norm( b - U * xhat )    % Check how close U * xhat  is to b = U % x