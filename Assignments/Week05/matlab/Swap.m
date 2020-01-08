function [ b10t, beta11, b12t, ...
           B20,    b21,   B22 ]  = Swap( i, a10t, alpha11, a12t, ...
                                             A20,   a21,   A22 )
% Swap Swap the top row of matrix with the row indexed with i

    if ( i == 0 )
        b10t = a10t;  beta11 = alpha11;   b12t = a12t;
        B20  = A20;   b21    = a21;       B22  = A22;
    else
        b10t = A20( i,: ); beta11 = a21( i,: ); b12t = A22( i,: );
        B20  = A20;        b21    = a21;        B22 = A22;
        B20( i,: ) = a10t; b21( i ) = alpha11;  B22( i,: ) = a12t;
    end
end