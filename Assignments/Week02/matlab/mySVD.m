function [ U, Sigma, V ] = mySVD( A )

  [ m, n ] = size( A );    % extract row and column size of A
  U = eye( m, m );         % U = I
  V = eye( n, n );         % V = I
  
  [ ATL, ATR, ...
    ABL, ABR ] = FLA_Part_2x2( A, ...
                               0, 0, 'FLA_TL' );

  [ UL, UR ] = FLA_Part_1x2( U, ...
                               0, 'FLA_LEFT' );

  [ VL, VR ] = FLA_Part_1x2( V, ...
                               0, 'FLA_LEFT' );
                           
  while ( size( ATL, 2 ) < size( A, 2 ) )
      
    [ curm, curn ] = size( ABR );
    
    [ utilde1, sigma11, vtilde1 ] = svds( ABR, 1 )
    
    [ Vtilde, R ] = qr( [ vtilde1 rand( curn, curn-1 ) ] );
    [ Utilde, R ] = qr( [ utilde1 rand( curm, curm-1 ) ] );
    
    Vtilde2 = Vtilde( :, 2:curn );
    Utilde2 = Utilde( :, 2:curm );
    
    VR = VR * Vtilde;
    UR = UR * Utilde;
        
    [ A00,  a01,     A02,  ...
      a10t, alpha11, a12t, ...
      A20,  a21,     A22 ] = FLA_Repart_2x2_to_3x3( ATL, ATR, ...
                                                    ABL, ABR, ...
                                                    1, 1, 'FLA_BR' );

    [ U0, u1, U2 ]= FLA_Repart_1x2_to_1x3( UL, UR, ...
                                         1, 'FLA_RIGHT' );

    [ V0, v1, V2 ]= FLA_Repart_1x2_to_1x3( VL, VR, ...
                                         1, 'FLA_RIGHT' );

    %------------------------------------------------------------%

    alpha11 = sigma11;                a12t = zeros( size( a12t ) );
    a21     = zeros( size( a21 ) );   A22  = Utilde2' * ABR * Vtilde2;
    
    %------------------------------------------------------------%

    [ ATL, ATR, ...
      ABL, ABR ] = FLA_Cont_with_3x3_to_2x2( A00,  a01,     A02,  ...
                                             a10t, alpha11, a12t, ...
                                             A20,  a21,     A22, ...
                                             'FLA_TL' );

    [ UL, UR ] = FLA_Cont_with_1x3_to_1x2( U0, u1, U2, ...
                                           'FLA_LEFT' );

    [ VL, VR ] = FLA_Cont_with_1x3_to_1x2( V0, v1, V2, ...
                                           'FLA_LEFT' );

  end

  Sigma = [ ATL, ATR
            ABL, ABR ];
        
  V = [ VL, VR ];
  U = [ UL, UR ];

return
