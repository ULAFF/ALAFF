#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <time.h>

#define dabs( x ) ( (x) < 0 ? -(x) : x )

double FLA_Clock();      // This is a routine for extracting elapsed
			 // time borrowed from the libflame library

/* MaxAbsDiff computes the maximum absolute difference over all
   corresponding elements of two matrices */
double MaxAbsDiff( int, int, double *, int, double *, int );

/* RandomMatrix overwrites a matrix with random values */
void RandomMatrix( int, int, double *, int );

/* Prototype for BLAS matrix-matrix multiplication routine (which we will 
   use for the reference implementation */
void dgemm_( char *, char *,                 // transA, transB
	     int *, int *, int *,            // m, n, k
	     double *, double *, int *,      // alpha, A, ldA
	               double *, int *,      //        B, ldB
	     double *, double *, int * );    // beta,  C, ldC

/* Various constants that control what gets timed */

/* My_Gemm is a common interface to all the implementations we will 
   develop so we don't have to keep rewriting this driver routine. */
void MyGemm( int, int, int, double *, int, double *, int, double *, int );

int main(int argc, char *argv[])
{
  int
    m, n, k,
    ldA, ldB, ldC,
    size, first, last, inc,
    i, irep,
    nrepeats;

  double
    d_one = 1.0,
    dtime, dtime_best, 
    diff, maxdiff = 0.0, gflops;

  double
    *A, *B, *C, *Cold, *Cref;

  /* Every time trial is repeated "repeat" times and the fastest run is recorded */
  printf( "%% number of repeats:" );
  scanf( "%d", &nrepeats );
  printf( "%% %d\n", nrepeats );

  /* Timing trials for matrix sizes m=n=k=first to last in increments
     of inc will be performed.  (Actually, we are going to go from
     largest to smallest since this seems to give more reliable 
     timings.  */
  printf( "%% enter first, last, inc:" );
  scanf( "%d%d%d", &first, &last, &inc );

  /* Adjust first and last so that they are multiples of inc */
  last = ( last / inc ) * inc;
  first = ( first / inc ) * inc;
  first = ( first == 0 ? inc : first );
  
  printf( "%% %d %d %d \n", first, last, inc );

  printf( "data = [\n" );
  printf( "%%  n          reference      |         current implementation \n" );
  printf( "%%        time       GFLOPS   |    time       GFLOPS     diff \n" );
  i = 1;
  for ( size=last; size>= first; size-=inc ){
    /* we will only time cases where all three matrices are square */
    m = n = k = size;
    ldA = ldB = ldC = size;

    /* Gflops performed */
    gflops = 2.0 * m * n * k * 1e-09;

    /* Allocate space for the matrices.  We will use five arrays:
       A will be the address where A is stored.   Addressed with alpha(i,j).
       B will be the address where B is stored.   Addressed with beta(i,j).
       C will be the address where C is stored.   Addressed with gamma(i,j).

       Now, we will compute C = A B + C with via routine MyGemm
       and also with a reference implementation.  Therefore, we will
       utilize two more arrays:
 
       Cold will be the address where the original matrix C is
       stored.  

       Cref will be the address where the result of computing C = A B
       + C computed with the reference implementation will be stored.
    */

    A = ( double * ) malloc( ldA * k * sizeof( double ) );
    B = ( double * ) malloc( ldB * n * sizeof( double ) );
    C = ( double * ) malloc( ldC * n * sizeof( double ) );
    Cold = ( double * ) malloc( ldC * n * sizeof( double ) );
    Cref = ( double * ) malloc( ldC * n * sizeof( double ) );

    /* Generate random matrix A */
    RandomMatrix( m, k, A, ldA );

    /* Generate random matrix B */
    RandomMatrix( k, n, B, ldB );

    /* Generate random matrix Cold */
    RandomMatrix( m, n, Cold, ldC );
    
    /* Time reference implementation provided by the BLAS library
       routine dgemm (double precision general matrix-matrix
       multiplicationn */
    for ( irep=0; irep<nrepeats; irep++ ){
      
      /* Copy matrix Cold to Cref */
      memcpy( Cref, Cold, ldC * n * sizeof( double ) );
    
      /* start clock */
      dtime = FLA_Clock();
    
      /* Compute Cref = A B + Cref */
      dgemm_( "No transpose", "No transpose",
	      &m, &n, &k,
	      &d_one, A, &ldA,
	              B, &ldB,
	      &d_one, Cref, &ldC );

      /* stop clock */
      dtime = FLA_Clock() - dtime;

      /* record the best time so far */
      if ( irep == 0 ) 
	dtime_best = dtime;
      else
	dtime_best = ( dtime < dtime_best ? dtime : dtime_best );
    }
  
    printf( " %5d %8.4le %8.4le   ", n, dtime_best, gflops/dtime_best );
    fflush( stdout );  // We flush the output buffer because otherwise
		       // it may throw the timings of a next
		       // experiment.

    /* Time MyGemm */

    for ( irep=0; irep<nrepeats; irep++ ){
      /* Copy vector Cold to C */
      memcpy( C, Cold, ldC * n * sizeof( double ) );
    
      /* start clock */
      dtime = FLA_Clock();
    
      /* Compute C = A B + C */
      MyGemm( m, n, k, A, ldA, B, ldB, C, ldC );

      /* stop clock */
      dtime = FLA_Clock() - dtime;
    
      if ( irep == 0 ) 
	dtime_best = dtime;
      else
	dtime_best = ( dtime < dtime_best ? dtime : dtime_best );
    }

    diff = MaxAbsDiff( m, n, C, ldC, Cref, ldC );
    maxdiff = ( diff > maxdiff ? diff : maxdiff );
    
    printf( " %8.4le %8.4le %8.4le\n", dtime_best, gflops/dtime_best, diff  );
    fflush( stdout );  // We flush the output buffer because otherwise
		       // it may throw the timings of a next
		       // experiment.

    /* Free the buffers */
    free( A );
    free( B );
    free( C );
    free( Cold );
    free( Cref );

    i++;
  }
  printf( "];\n\n" );
  printf( "%% Maximum difference between reference and your implementation: %le.\n", maxdiff );
  
  exit( 0 );
}
