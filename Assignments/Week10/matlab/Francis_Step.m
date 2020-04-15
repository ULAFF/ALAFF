function T = Francis_Step( T )
    %Francis_Step Perform one Francis Implicit QR Step

    [ m, n ] = size( T );
    if m <= 2 
        return
    end
    
    % Introduce the bulge
    % Compute the first Givens' rotation
    G = Givens_rotation( [ T(1,1) - T( m,m ) 
                                T(2,1)      ]);
    
    % Compute the updates to the matrix, using only lower triangular 
    % entries, but first also computing the one entry that is above the
    % diagonal, resulting in a temporary matrix, S
    S =[ G' * [ T(1,1) T(2,1)
                T(2,1) T(2,2) ] 
                  0    T(3,2) ] * G;
    % Place the entries in the right place in T
    T( 1,1 ) = S( 1,1 );
    T( 2,1 ) = S( 2,1 ); T( 2,2 ) = S( 2,2 );
    T( 3,1 ) = S( 3,1 ); T( 3,2 ) = S( 3,2 );
    
    % Chase the bulge until it is in the last row of the matrix
    for i=1:m-3
      G = Givens_rotation( [ T(i+1,i) 
                             T(i+2,i)      ]);
      S =[ G' * [ T(i+1,i) T(i+1,i+1) T(i+2,i+1)
                  T(i+2,i) T(i+2,i+1) T(i+2,i+2) ]
                     0          0     T(i+3,i+2) ] * ...
                     [ 1    [ 0 0 ]
                     [ 0
                       0 ]     G    ] ;
      % Place the entries in the right place in T
      T( i+1,i ) = S(1,1);  T( i+1,i+1) = S(1,2); 
      T( i+2,i ) = 0;       T( i+2,i+1) = S(2,2); T( i+2,i+2 ) = S(2,3);
                            T( i+3,i+1) = S(3,2); T( i+3,i+2 ) = S(3,3);
    end
    
    % Remove the bulge from the last row
    G = Givens_rotation( [ T(m-1,m-2) 
                           T(m,  m-2) ]);
                         
    S = G' * [ T(m-1,m-2) T(m-1,m-1) T(m,m-1)
                T(m  ,m-2) T(m,  m-1) T(m,m) ] * ...
                     [ 1    [ 0 0 ]
                     [ 0
                       0 ]     G    ] ;
    % Place the entries in the right place in T
    T( m-1,m-2 ) = S(1,1);  T( m-1,m-1 ) = S(1,2); 
    T( m  ,m-2 ) = 0;       T( m,  m-1 ) = S(2,2); T( m,m ) = S(2,3);
end