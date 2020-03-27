function showeig( A )
close all

figure

% Set the delay in the animation
delay = 0.1 % seconds

hold on
axis( [-1.1 1.1 -1.1 1.1 ]*norm( A ) ); 

% Set the tick mark colors for the different iterations

xcolor(1) = 'k';
xcolor(2) = 'w';
xcolor(3) = 'k';

ycolor(1) = 'r';
ycolor(2) = 'w';
ycolor(3) = 'r';

for i=1:3

    for rho1 = 0:pi/25:2*pi
      % show axes
      plot( [ -1.1*norm(A); 1.1*norm(A) ], [0;0], '-', 'Color', 'b' );        
      plot( [0;0], [ -1.1*norm(A); 1.1*norm(A) ], '-', 'Color', 'b' );        
      
      % Create and plot the vector on the unit circle
      x = [
         cos( rho1 );
         sin( rho1 );
         ];
      plot( [ x(1) ], [ x( 2 ) ], '.', 'Color', xcolor( i ), 'Linewidth', 4 );
          
      plot( [ 0; x(1) ], [ 0; x( 2 ) ], '-', 'Color', 'k', 'Linewidth', 4 )
      plot( [ 0; x(1) ], [ 0; x( 2 ) ], '-', 'Color', 'w', 'Linewidth', 3 )
      % compute text location as half way up the vector and off by an angle
      % pi/16
      x_text = [ cos( pi/16 ) -sin( pi/16 )
                 sin( pi/16 )  cos( pi/16 ) ] * x / 2;
    
      text( x_text(1), x_text(2), 'x', "Color", 'k' )
      
      % Create and plot the image of the vector
      y = A * x;

      plot( [ y(1) ], [ y( 2 ) ], '.', 'Color', ycolor( i ), 'Linewidth', 4 );
      plot( [ 0; y(1) ], [ 0; y( 2 ) ], '-', 'Color', 'r', 'Linewidth', 2 )

     % compute text location as half way up the vector and off by an angle
     % - pi/16       
      y_text = [ cos( pi/16 ) sin( pi/16 )
                -sin( pi/16 )  cos( pi/16 ) ] * y / 4 * 3;    
      text( y_text(1), y_text(2), 'Ax', "Color", 'r' )
    
      % input('continue?');
      pause( delay );

      plot( [ 0; x(1) ], [ 0; x( 2 ) ], '-', 'Color', 'w', 'Linewidth', 4 )
      text( x_text(1), x_text(2), 'x', "Color", 'w' )
      plot( [ 0; y(1) ], [ 0; y( 2 ) ], '-', 'Color', 'w', 'Linewidth', 2 )    
      text( y_text(1), y_text(2), 'Ax', "Color", 'w' )
    end
end

% Plot the eigenvectors and their images.

% show axes
plot( [ -1.1*norm(A); 1.1*norm(A) ], [0;0], '-', 'Color', 'b' );        
plot( [0;0], [ -1.1*norm(A); 1.1*norm(A) ], '-', 'Color', 'b' ); 
      
% Have matlab compute the matrix Xs and diagonal Lambda such that
% A * Xs = Lambda Xs
% This means that the eigenvalues show up on the diagonal of Lambda
% and the columns of A equal eigenvectors.
% HOWEVER, these eigenvectors may not be linearly independent if the
% eigenvalues are equal.

[ Xs, Lambda ] = eig( A );
 
if ( imag( Lambda(1,1) ) == 0 )
   x0 = Xs(:,1);   % First Eigenvector
   y0 = A * x0;   % Image of first eigenvector
   plot( [ 0; x0( 1 ) ], [ 0; x0( 2 ) ], '-', 'LineWidth', 3, ...
       'Color', 'k' );
   plot( [ 0; x0( 1 ) ], [ 0; x0( 2 ) ], '-', 'LineWidth', 2, ...
       'Color', 'w' );
   x_text = [ cos( pi/16 ) -sin( pi/16 )
              sin( pi/16 )  cos( pi/16 ) ] * x0 / 2;
   text( x_text(1), x_text(2), 'x_0', "Color", 'k' )

   plot( [ 0; y0( 1 ) ], [ 0; y0( 2 ) ], '-', 'Color', 'r' ); 
   y_text = [ cos( pi/16 ) sin( pi/16 )
             -sin( pi/16 )  cos( pi/16 ) ] * y0 * 1.1;    
   text( y_text(1), y_text(2), 'A x_0 = \lambda_0 x_0', "Color", 'r' )

   x1 = Xs(:,2);   % Second Eigenvector
   y1 = A * x1;   % Image of second eigenvector
   plot( [ 0; x1( 1 ) ], [ 0; x1( 2 ) ], '-', 'LineWidth', 3, ...
       'Color', 'k' );
   plot( [ 0; x1( 1 ) ], [ 0; x1( 2 ) ], '-', 'LineWidth', 2, ...
       'Color', 'w' );
   x_text = [ cos( pi/16 ) -sin( pi/16 )
              sin( pi/16 )  cos( pi/16 ) ] * x1 / 2;
   text( x_text(1), x_text(2), 'x_1', "Color", 'k' )

   plot( [ 0; y1( 1 ) ], [ 0; y1( 2 ) ], '-', 'Color', 'r' ); 
   y_text = [ cos( pi/16 ) sin( pi/16 )
             -sin( pi/16 )  cos( pi/16 ) ] * y1 * 1.1;    
   text( y_text(1), y_text(2), 'A x_1 = \lambda_1 x_1', "Color", 'r' )
end

hold off
