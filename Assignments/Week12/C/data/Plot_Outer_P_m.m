%% Performance of implementations of loop orderings with outer loop indexed with "P"
%% This Live Script
% This Live Script helps you visualize the performance of implementations that 
% order the loops so that the "P" loop is the outer-most loop:  Gemm_PJI.c, Gemm_P_Ger_J_Axpy.c, 
% Gemm_P_Ger_I_Axpy.c, Gemm_P_bli_dger.c, etc.
% 
% (These last ones are part of exercises in Unit 1.6.1).
% 
% To gather the performance data, in the command (terminal) window change the 
% directory to Assignments/Week1/C/.  After implementing the various versions,  
% execute 
% 
% make PJI   (actually, you probably did this one already)
% 
% make P_Ger_J_Axpy
% 
% make P_Ger_I_Axpy
% 
% make P_bli_dger
% 
% make P_dger
% 
% or, alternatively,
% 
% make Outer_P
% 
% This compiles and executes a driver routine (the source of which is in driver.c) 
% that collects accuracy and performance data for the various implementations.  
% 
% When completed, various data is in output file 'output_XYZ.m' (for XYZ $$ 
% \in $$ {PJI, P_Ger_J_Axpy, ...}) in the same directory where you found this 
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
             
% Plot time data for PJI  
output_PJI   % load data for PJI ordering
assert( max(abs(data(:,6))) < 1.0e-10, ...
    'Hmmm, better check if there is an accuracy problem');
plot( data(:,1), data(:,5), 'DisplayName', 'PJI', 'MarkerSize', 8, 'LineWidth', 2, ...
      'Marker', 'o', 'LineStyle', '-.', 'Color', plot_colors( 2,: ) );

% Plot time data for P_Ger_I_Axpy  (to plot change "0" to "1")
if ( 0 ) 
  output_P_Ger_I_Axpy  
  assert( max(abs(data(:,6))) < 1.0e-10, ...
      'Hmmm, better check if there is an accuracy problem');
  plot( data(:,1), data(:,5), 'DisplayName', 'P\_Ger\_I\_Axpy', 'MarkerSize', 10, 'LineWidth', 2, ...
        'Marker', 'x', 'LineStyle', '-.', 'Color', plot_colors( 3,: ) );
end

% Plot time data for P_Ger_J_Axpy  (to plot change "0" to "1")
if ( 0 ) 
  output_P_Ger_J_Axpy
  assert( max(abs(data(:,6))) < 1.0e-10, ...
      'Hmmm, better check if there is an accuracy problem');
  plot( data(:,1), data(:,5), 'DisplayName', 'P\_Ger\_J\_Axpy', 'MarkerSize', 8, 'LineWidth', 2, ...
        'Marker', 'o', 'LineStyle', '-.', 'Color', plot_colors( 4,: ) );
end

% Plot time data for P_bli_dger  (to plot change "0" to "1")
if ( 0 ) 
  output_P_bli_dger
  assert( max(abs(data(:,6))) < 1.0e-10, ...
      'Hmmm, better check if there is an accuracy problem');
  plot( data(:,1), data(:,5), 'DisplayName', 'P\_bli\_dger', 'MarkerSize', 8, 'LineWidth', 2, ...
        'Marker', 'o', 'LineStyle', '-.', 'Color', plot_colors( 5,: ) );
end

% Plot time data for P_dger  (to plot change "0" to "1")
if ( 0 ) 
  output_P_dger
  assert( max(abs(data(:,6))) < 1.0e-10, ...
      'Hmmm, better check if there is an accuracy problem');
  plot( data(:,1), data(:,5), 'DisplayName', 'P\_dger', 'MarkerSize', 8, 'LineWidth', 2, ...
        'Marker', 'o', 'LineStyle', '--', 'Color', plot_colors( 6,: ) );
end

% Adjust the x-axis and y-axis range to start at 0
v = axis;                   % extract the current ranges
axis( [ 0 v(2) 0 v(4) ] )   % start the x axis and y axis at zero

legend2 = legend( axes2, 'show' );
set( legend2, 'Location', 'southeast', 'FontSize', 18) ;

% Uncomment if you want to create a pdf for the graph
% print( 'Plot_Outer_P.png', '-dpng' );
%%