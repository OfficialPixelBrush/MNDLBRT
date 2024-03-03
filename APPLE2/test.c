#include<stdio.h>

int adder(int addend, int augend);

int main()
{
   int first, second, result = 0;

   puts("First enter an integer: ");

   if(scanf("%d", &first) != 1)
   {
      puts("That wasn't right!");
      return -1;
   }

   puts("Now enter a second integer: ");

   if(scanf("%d", &second) != 1)
   {
      puts("That wasn't right!");
      return -1;
   }

   result = adder(first, second);

   printf("The result is: %d\n", result);

   return 0;
}

int adder(addend, augend)
{
   return addend + augend;
}