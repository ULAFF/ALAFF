%% Performance of implementations of loop orderings with outer loop indexed with "J"
%% This Live Script
% This Live Script helps you visualize the performance of implementations that 
% order the loops so that the "J" loop is the outer-most loop:  Gemm_JIP.c, etc.
% 
% To gather the performance data, in the command (terminal) window change the 
% directory to Assignments/Week1/C/.  After implementing the various versions,  
% execute 
% 
% make JPI   (actually, you probably did this one already)
% 
% make J_Gemv_J_Axpy
% 
% make JIP
% 
% make J_Gemv_I_Dots
% 
% make J_dgemv
% 
% make J_bli_dgemv
% 
% or, alternatively,
% 
% make Plot_Outer_J
% 
% This compiles and executes a driver routine (the source of which is in driver.c) 
% that collects accuracy and performance data for the various implementations.  
% 
% When completed, various data is in output file 'output_XYZ.m' (for XYZ $$ 
% \in $$ {JPI, J_Gemv_J_Axpy, ...}) in the same directory where you found this 
% Live Script (LAFF-On-HPC/Assignments/Week1/C/data/).  This Life Script then 
% creates graphs from that timing data.  Go ahead and click on "Run All".  It 
% executes all the code in the rest of this file.  You will want to look at the 
% graphs this creates.

plot_colors = [ 0 0 0; 0 0 1; 0 1 0; 0 1 1; 1 0 0; 1 0 1; 1 1 0; 1 1 1];

% Create figure
figure1 = figure('Name','GFLOPS');

% Create axes, labels, legends.  In future routines for plotting performance, 
% the next few lines will be hidden in the script.
axes2 = axes('Parent',figure1);
hold(axes2,'on');
ylabel( 'GFLOPS', 'FontName', 'Helvetica Neue' );
xlabel( 'matrix dimension m=n=k', 'FontName', 'Helvetica Neue' );
box(axes2,'on');
set( axes2, 'FontName', 'Helvetica Neue', 'FontSize', 18);
             
% Plot time data for JPI  
output_JPI   % load data for JPI ordering
assert( max(abs(data(:,6))) < 1.0e-10, ...
    'Hmmm, better check if there is an accuracy problem');
plot( data(:,1), data(:,5), 'DisplayName', 'JPI', 'MarkerSize', 8, 'LineWidth', 2, ...
      'Marker', 'o', 'LineStyle', '-.', 'Color', plot_colors( 2,: ) );

% Plot time data for JP_Axpy  (to plot change "0" to "1")
if ( 0 ) 
  output_J_Gemv_J_Axpy  
  assert( max(abs(data(:,6))) < 1.0e-10, ...
      'Hmmm, better check if there is an accuracy problem');
  plot( data(:,1), data(:,5), 'DisplayName', 'J\_Gemv\_J\_Axpy ', 'MarkerSize', 8, 'LineWidth', 2, ...
        'Marker', 'o', 'LineStyle', '-.', 'Color', plot_colors( 3,: ) );
end

% Plot time data for JIP  (to plot change "0" to "1")
if ( 0 ) 
  output_JIP
  assert( max(abs(data(:,6))) < 1.0e-10, ...
      'Hmmm, better check if there is an accuracy problem');
  plot( data(:,1), data(:,5), 'DisplayName', 'JIP', 'MarkerSize', 8, 'LineWidth', 2, ...
        'Marker', 'o', 'LineStyle', '-.', 'Color', plot_colors( 4,: ) );
end

% Plot time data for J_Gemv_I_Dots  (to plot change "0" to "1")
if ( 0 ) 
  output_J_Gemv_I_Dots
  assert( max(abs(data(:,6))) < 1.0e-10, ...
      'Hmmm, better check if there is an accuracy problem');
  plot( data(:,1), data(:,5), 'DisplayName', 'J\_Gemv\_I\_Dots', 'MarkerSize', 8, 'LineWidth', 2, ...
        'Marker', 'o', 'LineStyle', '-.', 'Color', plot_colors( 5,: ) );
end

% Plot time data for J_dgemv  (to plot change "0" to "1")
if ( 0 ) 
  output_J_dgemv
  assert( max(abs(data(:,6))) < 1.0e-10, ...
      'Hmmm, better check if there is an accuracy problem');
  plot( data(:,1), data(:,5), 'DisplayName', 'J\_dgemv', 'MarkerSize', 8, 'LineWidth', 2, ...
        'Marker', 'o', 'LineStyle', '--', 'Color', plot_colors( 6,: ) );
end

% Plot time data for J_bli_dgemv  (to plot change "0" to "1")
if ( 0 ) 
  output_J_bli_dgemv 
  assert( max(abs(data(:,6))) < 1.0e-10, ...
      'Hmmm, better check if there is an accuracy problem');
  plot( data(:,1), data(:,5), 'DisplayName', 'J\_bli\_dgemv', 'MarkerSize', 8, 'LineWidth', 2, ...
        'Marker', 'o', 'LineStyle', '--', 'Color', plot_colors( 7,: ) );
end

legend2 = legend( axes2, 'show' );
set( legend2, 'Location', 'southeast', 'FontSize', 18) ;

% Adjust the x-axis and y-axis range to start at 0
v = axis;                   % extract the current ranges
axis( [ 0 v(2) 0 v(4) ] )   % start the x axis and y axis at zero
%%