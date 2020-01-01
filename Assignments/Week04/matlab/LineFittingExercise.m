clear
close all

% Coordinates of points ( alpha, beta ):
a = [
    1
    2
    3
    4
    ];

b = [
    -1
    4
    4
    6
    ];

% Create the matrix A
A = [ ones( size(a) ) a ];

% Compute the limits for the axes
amin = min( a )-1;
amax = max(a)+1;
bmin = min(b)-1;
bmax = max(b)+1;

% Plot the points for the first iteration
plot( a, b, 'o', 'MarkerSize', 10, 'Color', 'red' );
axis( [ amin amax bmin bmax ]);
hold on

disp( 'Try to fit the line three times:' );
for i=1:3
    % Get the guesses for chi0 and chi1
    disp( 'Guess chi0 and chi1 such that f( alpha ) = chi0 + chi1 alpha fits the points' );
    chi0 = input( 'Input chi0' );
    chi1 = input( 'Input chi1' );
    
    % Make into a vector
    x = [ chi0
          chi1 ];
      
    hold off
    % Plot the line for the latest guess
    plot( a, b, 'o', 'MarkerSize', 10, 'Color', 'red' );
    axis( [ amin amax bmin bmax ] );
    hold on
    plot( [ amin amax ], [x(1)+x(2)*amin x(1)+x(2)*amax ], '-', 'LineWidth', 4 );

    % Report the norm of the residual
    disp( 'norm( b - A * x )' );
    norm( b - A * x )    
end

disp( 'Your last norm( b - A * x )')
norm( b - A * x )

% Compute and report the best linear least squares fit
x = ( A' * A ) \ A' * b;
plot( [ amin amax ], [ x(1) + x(2)*amin x(1)+x(2)*amax ], '--', 'Color', 'blue', 'LineWidth', 3 );

disp( 'Best fit norm( b - A * x )' );
norm( b - A * x )

legend( 'Points', 'Your last guess', 'Best fit', 'Location', 'SouthEast' );

disp( 'Best choices for chi0 and chi1:')
[ x(1) x(2) ]

