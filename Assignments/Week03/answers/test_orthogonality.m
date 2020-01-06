close all

format long

% Set epsilon
epsilon =  1.0e-16;

for i=1:17
    A = [
        1       1       1
        epsilon 0       0
        0       epsilon 0
        0       0       epsilon
        ];

    [ Q_CGS, R_CGS ] = CGS_QR( A );
    [ Q_MGS, R_MGS ] = MGS_QR( A );

    % Call HQR
    [ A_out, t_out ] = HQR( A );
    % Form Q
    [ Q_HQR ] = FormQ( A_out, t_out );

    data( i,: ) = [ epsilon, norm( eye( 3 ) - Q_CGS' * Q_CGS ), ...
        norm( eye( 3 ) - Q_MGS' * Q_MGS ), norm( eye( 3 ) - Q_HQR' * Q_HQR ) ];
    
    epsilon = epsilon * 10;
end

loglog( data(:,1), data(:,2), 'r', 'LineWidth', 3 );
hold on
loglog( data(:,1), data(:,3), 'b', 'LineWidth', 3 );
loglog( data(:,1), data(:,4), 'k', 'LineWidth', 3 );

legend( 'CGS', 'MGS', 'HQR' );
xlabel( 'epsilon' );
ylabel( 'norm( I - Q^T * Q )' );

title( 'How orthonormal are the columns of Q?' );
