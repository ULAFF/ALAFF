rng(0)

m = 5

% Create a symmetric m x m matrix
A = rand( m,m );
A = tril( A ) + tril( A,-1)';

% Remember the original matrix
Aold = A;

disp( A );

disp( 'Every time the matrix is displayed, pick the i and j entry you want to zero' );
disp( 'i = -1 means: leave the loop' );

while i ~= -1
    i = input( 'enter i:' );
    if i < 1 || i > m
        if i ~= -1
            disp( 'Reenter 1 <= i,j <= m and i ~= j' )
        end
        continue
    end
    
    j = input( 'enter j:' ); 
    if j < 1 || j > m || i == j
        disp( 'Reenter 1 <= i,j <= m')
        continue
    end
    
    % Compute J
    [ J, Lambda ] = Jacobi_rotation( [ A( i,i )  A(i,j) 
                                       A( j,i )  A(j,j) ] );
    
    % Apply J' from left 
    rowi = A( i,: );
    A( i,: ) = J(1,1) * rowi + J(2,1) * A( j,: );
    A( j,: ) = J(1,2) * rowi + J(2,2) * A( j,: );

    % Apply J from right
    coli = A( :,i );
    A( :,i ) = coli * J( 1,1 ) + A( :,j ) * J( 2,1 );
    A( :,j ) = coli * J( 1,2 ) + A( :,j ) * J( 2,2 );
    
    disp( A );
end

disp( 'final A' );
disp( A );

disp( 'Eigenvalues of original matrix' );
eig( Aold )
