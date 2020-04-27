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
void dgemv_( char *,                         // transA
	     int *, int *       ,            // m, n
	     double *, double *, int *,      // alpha, A, ldA
	               double *, int *,      //        x, incx
	     double *, double *, int * );    // beta,  y, incy

/* MyGemv is a common interface to all the implementations we will 
   develop so we don't have to keep rewriting this driver routine. */
void MyGemv( int, int, double *, int, double *, int, double *, int );

int main(int argc, char *argv[])
{
  int
    m, n,
    ldA, 
    size, first, last, inc,
    i_one=1,
    AllCorrect;

  double
    d_one = 1.0,
    diff, maxdiff;

  double
    *A, *x, *y, *yold, *yref;

  /* Trials for matrix sizes m=n=first to last in increments
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

  /* AllCorrect keeps track of whether all the trials were correct so
     far */
 
  AllCorrect = 1;

  for ( size=last; size>= first; size-=inc ){
    /* We will only test cases where all three matrices are square.
     obviously, this is not very complete. */
    m = n = size;
    ldA = size;

    /* Allocate space for the matrix and vectors. 
       A will be the address where A is stored.   
       x will be the address where x is stored.   
       y will be the address where y is stored.   

       Now, we will compute y = A x + y with via routine MyGemv
       and also with a reference implementation.  Therefore, we will
       utilize two more arrays:
 
       yold will be the address where the original vector y is
       stored.  

       yref will be the address where the result of computing y = A x
       + y computed with the reference implementation will be stored.
    */

    A = ( double * ) malloc( ldA * n * sizeof( double ) );
    x = ( double * ) malloc( n * sizeof( double ) );
    y = ( double * ) malloc( m * sizeof( double ) );
    yold = ( double * ) malloc( m * sizeof( double ) );
    yref = ( double * ) malloc( m * sizeof( double ) );

    /* Generate random matrix A */
    RandomMatrix( m, n, A, ldA );

    /* Generate random vector x */
    RandomMatrix( n, 1, x, n );

    /* Generate random vector y */
    RandomMatrix( m, 1, yold, m );
    
    /* Time reference implementation provided by the BLAS library
       routine dgemv (double precision general matrix-vector
       multiplicationn */
      
    /* Copy matrix Cold to Cref */
    memcpy( yref, yold, m * sizeof( double ) );
    
    /* Compute yref = A x + yref */
    dgemv_( "No transpose", 
	    &m, &n, 
	    &d_one, A, &ldA,
	            x, &i_one,
	    &d_one, yref, &i_one );

    /* Time MyGemv */

    /* Copy vector yold to y */
    memcpy( y, yold, m * sizeof( double ) );
    
    /* Compute y = A x + y */
    MyGemv( m, n, A, ldA, x, 1, y, 1 );

    diff = MaxAbsDiff( m, 1, y, m, yref, m );
    maxdiff = ( diff > maxdiff ? diff : maxdiff );

    if ( maxdiff > 1.0e-8 )
      /* Looks fishy... */
      AllCorrect = 0;

    /* Free the buffers */
    free( A );
    free( x );
    free( y );
    free( yold );
    free( yref );
  }

  if ( AllCorrect )
    printf("It appears all is well\n");
  else
    printf("At least one test is suspicious\n");

  exit( 0 );
}
